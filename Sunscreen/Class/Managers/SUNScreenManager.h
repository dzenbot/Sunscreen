//
//  SUNScreenManager.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUNScreen.h"

@interface SUNScreenManager : NSObject

@property (nonatomic, readwrite) float brightnessLevel;
@property (nonatomic, readwrite) BOOL autoBrightnessMode;

@property (nonatomic, readonly) NSNumber *displayCount;
@property (nonatomic, readonly) NSArray *availableScreens;

+ (instancetype)sharedManager;

@end
