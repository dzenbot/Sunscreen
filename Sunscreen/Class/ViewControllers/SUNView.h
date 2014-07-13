//
//  SUNView.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/13/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SUNSlider.h"

@interface SUNView : NSView

@property (nonatomic, weak) IBOutlet NSImageView *iconView;
@property (nonatomic, weak) IBOutlet NSTextField *titleLabel;
@property (nonatomic, weak) IBOutlet SUNSlider *slider;

@end
