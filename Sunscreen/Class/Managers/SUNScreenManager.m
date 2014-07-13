//
//  SUNScreenManager.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SunscreenManager.h"
#import "CGDirectDisplayUtility.h"

#include <stdlib.h>
#include <limits.h>

#import <IOKit/graphics/IOGraphicsLib.h>
#import <IOKit/IOBSD.h>

const int kMaxDisplays = 16;
const CFStringRef kDisplayBrightness = CFSTR(kIODisplayBrightnessKey);

static NSString *kBrightnessMode = @"com.dzn.Sunscreen.brightnessMode";

@interface SUNScreenManager ()
@property (nonatomic) BOOL didStartMonitoringLight;
@property (nonatomic, strong) NSMutableArray *cachedScreens;
@end

@implementation SUNScreenManager

+ (void)initialize
{
    [super initialize];
    

}

+ (instancetype)sharedManager
{
    static SUNScreenManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        _sharedManager.cachedScreens = [NSMutableArray new];
    });
    return _sharedManager;
}


#pragma mark - Getters

- (SUNScreen *)screenForDisplayID:(CGDirectDisplayID)dspy
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayID == %@", @(dspy)];
    NSArray *screens = [[NSArray arrayWithArray:_cachedScreens] filteredArrayUsingPredicate:predicate];
    
    if ([screens firstObject]) {
        return [screens firstObject];
    }
    
    NSDictionary *screenInfo = (__bridge NSDictionary *)IOServiceInfoFromCGDisplayID(dspy);
    
    SUNScreen *screen = [SUNScreen new];
    screen.displayID = dspy;
    screen.name = [[screenInfo objectForKey:@"DisplayProductName"] objectForKey:@"en_US"];
    screen.iconPath = [screenInfo objectForKey:@"display-icon"];
    
    return screen;
}

- (NSArray *)availableScreens
{
    CGDirectDisplayID display[kMaxDisplays];
    CGDisplayCount numDisplays;
    CGDisplayErr err = CGGetActiveDisplayList(kMaxDisplays, display, &numDisplays);
    
    if (err != CGDisplayNoErr) {
        printf("cannot get list of displays (error %d)\n", err);
        return nil;
    }
    
    NSMutableArray *screens = [[NSMutableArray alloc] initWithCapacity:numDisplays];
    
    for (CGDisplayCount i = 0; i < numDisplays; ++i) {
        
        CGDirectDisplayID dspy = display[i];
        SUNScreen *screen = [self screenForDisplayID:dspy];

        [screens addObject:screen];
        [_cachedScreens addObject:screen];
    }
    
    return screens;
}

- (SUNScreenBrightnessMode)brightnessMode
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kBrightnessMode];
}

- (float)brightnessLevelFromScreen:(SUNScreen *)screen
{
	CGDirectDisplayID display[kMaxDisplays];
	CGDisplayCount numDisplays;
	CGDisplayErr err = CGGetActiveDisplayList(kMaxDisplays, display, &numDisplays);
	
	if (err != CGDisplayNoErr) {
		printf("cannot get list of displays (error %d)\n", err);
    }
    
    io_service_t serv = IOServicePortFromCGDisplayID(screen.displayID);
    if (!serv) {
        return 1.0;
    }
    
    float brightness;
    err = IODisplayGetFloatParameter(serv, kNilOptions, kDisplayBrightness, &brightness);
    
    if (err != kIOReturnSuccess) {
        fprintf(stderr,
                "failed to get brightness of display 0x%x (error %d)",
                (unsigned int)screen.displayID, err);
        return 1.0;
    }
    
    IOObjectRelease(serv);
    
    return brightness;
}


#pragma mark - Setters

- (void)setBrightnessMode:(SUNScreenBrightnessMode)mode
{
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrightnessMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setGlobalBrightnessLevel:(float)level
{
    [self setBrightnessLevel:level toScreen:nil];
}

- (void)setBrightnessLevel:(float)level toScreen:(SUNScreen *)screen
{
    CGDirectDisplayID display[kMaxDisplays];
    CGDisplayCount numDisplays;
    CGDisplayErr err = CGGetActiveDisplayList(kMaxDisplays, display, &numDisplays);
    
    if (err != CGDisplayNoErr) {
        printf("cannot get list of displays (error %d)\n", err);
    }
    
    io_service_t service;
    if (!service) {
        return;
    }
    
    io_iterator_t iterator = 0;
    kern_return_t result = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator);

    // If not successful
    if (result != kIOReturnSuccess) {
        printf("IOServiceGetMatchingServices failed: %d\n", result);
        return;
    }
    
    NSInteger i = 0;
    
    while ((service = IOIteratorNext(iterator))) {
        
        if (screen) {
            SUNScreen *_cachedScreen = [self availableScreens][i];
            
            if (_cachedScreen.displayID == screen.displayID) {
                IODisplaySetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), level);
            }
        }
        else {
            IODisplaySetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), level);
        }
        
        // Let the object go
        IOObjectRelease(service);
        
        // We iterate throught all the available displays
        i++;
    }
    
    IOObjectRelease(iterator);
}


#pragma mark - iSight Ambient Sensor

- (void)getAmbientLight
{
//    if (self.didStartMonitoringLight) {
//        return;
//    }
    
    NSLog(@"%s",__FUNCTION__);
    
    CGDirectDisplayID display[kMaxDisplays];
    CGDisplayCount numDisplays;
	CGDisplayErr err;
	err = CGGetActiveDisplayList(kMaxDisplays, display, &numDisplays);
    
    if (err != CGDisplayNoErr) {
		printf("cannot get list of displays (error %d)\n", err);
    }
    
    CGDirectDisplayID dspy = display[1];
    CGDisplayModeRef originalMode = CGDisplayCopyDisplayMode(dspy);
    
    NSString *displayName = [NSString stringWithFormat:@"%s", getDisplayName(dspy)];
    NSLog(@"modifying : %@", displayName);

    
    if (originalMode == NULL) {
        return;
    }
    
    io_service_t service = IOServicePortFromCGDisplayID(dspy);
    if (!service) {
        return;
    }
    
    io_connect_t port = 0;
    IOServiceOpen(service, mach_task_self(), 0, &port);
    
    uint32_t outputs = 2;
    uint64_t values[outputs];
    
    kern_return_t result = IOConnectCallMethod(port, 0, nil, 0, nil, 0, values , &outputs, nil, 0);
    
    NSLog(@"result : %@", @(result));
    NSLog(@"kIOReturnSuccess : %@", (result == kIOReturnSuccess) ? @"YES" : @"NO");
    
    NSLog(@"Left:%i, Right:%i", (int)values[0], (int)values[1]);
    
    if (result == kIOReturnSuccess) {
        NSLog(@"values 0 : %@", @(values[0]));
        NSLog(@"values 1 : %@", @(values[1]));
    }
}

@end
