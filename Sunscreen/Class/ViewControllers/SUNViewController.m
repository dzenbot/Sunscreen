//
//  SUNViewController.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNViewController.h"
#import "SUNScreenManager.h"

#import "SUNSlider.h"

@interface SUNViewController ()
@end

@implementation SUNViewController

#pragma mark - initializers

- (id)init
{
    return [self initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:@"SUNViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Initialization code here.
    }
    return self;
}

#pragma mark - Setters

- (void)setScreen:(SUNScreen *)screen
{
    _screen = screen;

    [self.titleLabel setStringValue:screen.name];
    
    NSLog(@"self.titleLabel : %@", self.titleLabel);
    
    for (NSView *subview in self.view.subviews) {
        NSLog(@"subview : %@", subview);
    }
}


#pragma mark - IBActions

- (IBAction)sliderDidChange:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
}

- (IBAction)didMoveSlider:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
    
//    float level = self.slider.doubleValue/100;
//    
//    [SUNScreenManager sharedManager].brightnessLevel = level;
}

- (IBAction)didCheckBox:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
    
//    BOOL on = self.checkbox.state;
//    self.slider.enabled = !on;
//    
//    [SUNScreenManager sharedManager].autoBrightnessMode = on;
}


#pragma mark - Updates

- (void)refresh
{
    BOOL autoBrightness = [SUNScreenManager sharedManager].autoBrightnessMode;
    self.checkbox.state = autoBrightness;
    
    self.slider.doubleValue = [SUNScreenManager sharedManager].brightnessLevel*100;
    self.slider.enabled = !autoBrightness;
}

@end
