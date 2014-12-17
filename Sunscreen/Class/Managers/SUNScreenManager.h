//
//  SUNScreenManager.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUNScreen.h"

static NSString *kAdjustGlobalBrightnessNotification = @"com.dzn.Sunscreen.updateGlobalBrightness";

typedef NS_ENUM(NSUInteger, SUNScreenBrightnessMode) {
    SUNScreenBrightnessModeDedicated,
    SUNScreenBrightnessModeGlobal
};

@interface SUNScreenManager : NSObject

@property (nonatomic, readonly) NSArray *availableScreens;
@property (nonatomic, readwrite) SUNScreenBrightnessMode brightnessMode;

+ (instancetype)sharedManager;

- (float)brightnessLevelFromScreen:(SUNScreen *)screen;
- (void)setBrightnessLevel:(float)level toScreen:(SUNScreen *)screen;
- (void)setGlobalBrightnessLevel:(float)level;

@end
