//
//  SUNViewController.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SUNScreen;
@class SUNSlider;

@interface SUNViewController : NSViewController

@property (nonatomic, strong) SUNScreen *screen;

@property (nonatomic, weak) IBOutlet NSTextField *titleLabel;
@property (nonatomic, weak) IBOutlet SUNSlider *slider;
@property (nonatomic, weak) IBOutlet NSButton *checkbox;

- (IBAction)sliderDidChange:(id)sender;

- (IBAction)didMoveSlider:(id)sender;
- (IBAction)didCheckBox:(id)sender;

- (void)refresh;

@end
