//
//  SunscreenManager.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunscreenManager : NSObject

@property (nonatomic, readwrite) float brightnessLevel;
@property (nonatomic, readwrite) BOOL autoBrightnessMode;

+ (instancetype)sharedManager;

@end
