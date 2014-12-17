//
//  SUNScreen.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNScreen.h"

@implementation SUNScreen

+ (instancetype)new
{
    return [super new];
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSUInteger)hash
{
    return _identifier;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p | name: %@ | id: %@>", NSStringFromClass([self class]), self, _name, @(_identifier)];
}

@end
