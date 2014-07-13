//
//  SUNSlider.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNSlider.h"

@implementation SUNSlider

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.alphaValue = enabled ? 1.0 : 0.75;
}

@end
