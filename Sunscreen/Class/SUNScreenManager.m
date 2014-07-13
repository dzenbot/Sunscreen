//
//  SunscreenManager.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SunscreenManager.h"
#import "CGDirectDisplayUtility.h"

#include <stdlib.h>
#include <limits.h>

#include <IOKit/graphics/IOGraphicsLib.h>
#include <IOKit/graphics/IOGraphicsLib.h>

const int kMaxDisplays = 16;
const CFStringRef kDisplayBrightness = CFSTR(kIODisplayBrightnessKey);

static NSString *kAutoBrightnessMode = @"com.dzn.Sunscreen.autoBrightnessMode";

@interface SunscreenManager ()
@property (nonatomic) BOOL didStartMonitoringLight;
@end

@implementation SunscreenManager

+ (void)initialize
{
    [super initialize];
    

}

+ (instancetype)sharedManager
{
    static SunscreenManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        
        if ([_sharedManager autoBrightnessMode]) {
            [_sharedManager getAmbientLight];
        }
    });
    return _sharedManager;
}


#pragma mark - Getters

- (BOOL)autoBrightnessMode
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAutoBrightnessMode];
}

- (float)brightnessLevel
{
	CGDirectDisplayID display[kMaxDisplays];
	CGDisplayCount numDisplays;
	CGDisplayErr err;
	err = CGGetActiveDisplayList(kMaxDisplays, display, &numDisplays);
	
	if (err != CGDisplayNoErr) {
		printf("cannot get list of displays (error %d)\n", err);
    }
    
	for (CGDisplayCount i = 0; i < numDisplays; ++i) {
        
        CGDirectDisplayID dspy = display[i];
		CGDisplayModeRef originalMode = CGDisplayCopyDisplayMode(dspy);
        
		if (originalMode == NULL) {
			continue;
        }
        
        io_service_t serv = IOServicePortFromCGDisplayID(dspy);
        if (!serv) {
            break;
        }
        
		float brightness;
		err = IODisplayGetFloatParameter(serv, kNilOptions, kDisplayBrightness, &brightness);
        
		if (err != kIOReturnSuccess) {
			fprintf(stderr,
					"failed to get brightness of display 0x%x (error %d)",
					(unsigned int)dspy, err);
			continue;
		}
        
        IOObjectRelease(serv);

		return brightness;
	}
	return 1.0; //couldn't get brightness for any display
}


#pragma mark - Setters

- (void)setAutoBrightnessMode:(BOOL)on
{
    if (on) {
        [self getAmbientLight];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kAutoBrightnessMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBrightnessLevel:(float)level
{
    CGDirectDisplayID display[kMaxDisplays];
	CGDisplayCount numDisplays;
	CGDisplayErr err;
	err = CGGetActiveDisplayList(kMaxDisplays, display, &numDisplays);
    
    if (err != CGDisplayNoErr) {
		printf("cannot get list of displays (error %d)\n", err);
    }
    
    io_iterator_t iterator;
    kern_return_t result = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator);
    
    // If we were successful
    if (result == kIOReturnSuccess)
    {
        for (CGDisplayCount i = 0; i < numDisplays; ++i) {
            
            CGDirectDisplayID dspy = display[i];
            CGDisplayModeRef originalMode = CGDisplayCopyDisplayMode(dspy);
            
//            NSString *displayName = [NSString stringWithFormat:@"%s", getDisplayName(dspy)];
//            NSLog(@"modifying : %@", displayName);
            
            if (originalMode == NULL) {
                continue;
            }
            
            io_service_t service = IOServicePortFromCGDisplayID(dspy);
            if (!service) {
                continue;
            }
            
            while ((service = IOIteratorNext(iterator))) {
                IODisplaySetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), level);
                
                // Let the object go
                IOObjectRelease(service);
            }
        }
    }
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
