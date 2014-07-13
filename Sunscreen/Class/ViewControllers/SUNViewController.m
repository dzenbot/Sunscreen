//
//  SUNViewController.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNViewController.h"
#import "SUNScreenManager.h"

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
        
    }
    return self;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshSubviews];
}

#pragma mark - Setters

- (void)setScreen:(SUNScreen *)screen
{
    _screen = screen;
    
    [self.view.iconView setImage:[[NSImage alloc] initWithContentsOfFile:screen.iconPath]];
    [self.view.titleLabel setStringValue:screen.name];
}


#pragma mark - IBActions

- (IBAction)sliderDidChange:(id)sender
{
    float level = self.view.slider.doubleValue/100;

    SUNScreenBrightnessMode mode = [SUNScreenManager sharedManager].brightnessMode;
    
    if (mode == SUNScreenBrightnessModeDedicated) {
        [[SUNScreenManager sharedManager] setBrightnessLevel:level toScreen:self.screen];
    }
    else {
        [[SUNScreenManager sharedManager] setGlobalBrightnessLevel:level];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdjustGlobalBrightnessNotification object:@(level)];
    }
}

//- (IBAction)checkBoxDidChange:(id)sender
//{
//    NSLog(@"%s",__FUNCTION__);
//    
//    BOOL on = self.view.checkbox.state;
//    self.view.slider.enabled = !on;
//    
//    [SUNScreenManager sharedManager].autoBrightnessMode = on;
//}


#pragma mark - Updates

- (void)refreshSubviews
{
    float level = [[SUNScreenManager sharedManager] brightnessLevelFromScreen:self.screen];
    self.view.slider.doubleValue = level*100;
    
//    BOOL autoBrightness = [SUNScreenManager sharedManager].autoBrightnessMode;
//    self.view.checkbox.state = autoBrightness;
//    self.view.slider.enabled = !autoBrightness;
}

@end
