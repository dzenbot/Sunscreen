//
//  SUNEventManager.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/13/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNEventManager.h"

@interface SUNEventManager ()
@property (nonatomic, strong) NSEvent *increaseEvent;
@end

@implementation SUNEventManager

+ (instancetype)sharedManager
{
    static SUNEventManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)startMonitoring
{
    NSLog(@"%s",__FUNCTION__);
    
    self.increaseEvent = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask
                                                          handler:^(NSEvent *event) {
                                                              
                                                              NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
                                                              
                                                              NSLog(@"flags : %@", @(flags));
                                                              NSLog(@"characters : %@", [event characters]);

                                                              if (flags == NSCommandKeyMask ) {
                                                                  NSLog(@"cmd + %@", [event characters]);
                                                                  
                                                                  if ([[event characters] isEqualToString:@"1"]) {
                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kDecreaseBrightnessNotification object:nil];
                                                                  }
                                                                  if ([[event characters] isEqualToString:@"2"]) {
                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kIncreaseBrightnessNotification object:nil];
                                                                  }
                                                              }
                                                              if (flags == NSFunctionKeyMask ) {
                                                                  NSLog(@"f + %@", [event characters]);
                                                              }
                                                              
                                                              return event;
                                                          }];
}

- (void)stopMonitoring
{
    [NSEvent removeMonitor:self.increaseEvent];
    _increaseEvent = nil;
}

@end
