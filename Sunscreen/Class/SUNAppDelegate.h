//
//  SUNAppDelegate.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SUNAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (nonatomic, weak) IBOutlet NSView *contentView;
@property (nonatomic, weak) IBOutlet NSSlider *slider;
@property (nonatomic, weak) IBOutlet NSButton *checkbox;

- (IBAction)sliderChanged:(id)sender;
- (IBAction)adjustAutomatically:(id)sender;
- (IBAction)quit:(id)sender;

@end
