//
//  SUNScreen.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUNScreen : NSObject

@property (nonatomic, readwrite) CGDirectDisplayID displayID;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *iconPath;

@property (nonatomic, readwrite) float brightnessLevel;
@property (nonatomic, readwrite) BOOL adjustsBrightnessAutomatically;

@end
