//
//  SUNScreen.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNScreen.h"

@implementation SUNScreen

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@; display id: %@", _name, @(_displayID)];
}

@end
