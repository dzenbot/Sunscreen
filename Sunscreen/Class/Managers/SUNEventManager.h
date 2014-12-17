//
//  SUNEventManager.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/13/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kIncreaseBrightnessNotification = @"com.dzn.Sunscreen.increaseBrightness";
static NSString *kDecreaseBrightnessNotification = @"com.dzn.Sunscreen.decreaseBrightness";

@interface SUNEventManager : NSObject

+ (instancetype)sharedManager;

- (void)startMonitoring;
- (void)stopMonitoring;

@end
