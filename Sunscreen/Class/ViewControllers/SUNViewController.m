//
//  SUNViewController.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNViewController.h"
#import "SUNScreenManager.h"
#import "SUNEventManager.h"

#define kCellMaxCount 16
#define kCellValue roundf(self.view.slider.maxValue/kCellMaxCount)

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceIncrease:) name:kDecreaseBrightnessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceDecrease:) name:kDecreaseBrightnessNotification object:nil];

    }
    return self;
}

- (void)forceIncrease:(id)sender
{
    if (self.view.slider.doubleValue < self.view.slider.maxValue) {
        double value = self.view.slider.doubleValue+kCellValue;
        NSLog(@"value : %@", @(value));
        
        [self.view.slider setDoubleValue:value];
        [[SUNScreenManager sharedManager] setBrightnessLevel:value/100 toScreen:self.screen];
    }
}

- (void)forceDecrease:(id)sender
{
    if (self.view.slider.doubleValue > self.view.slider.minValue) {
        double value = self.view.slider.doubleValue-kCellValue;
        NSLog(@"value : %@", @(value));

        [self.view.slider setDoubleValue:value];
        [[SUNScreenManager sharedManager] setBrightnessLevel:value/100 toScreen:self.screen];
    }
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


#pragma mark - Updates

- (void)refreshSubviews
{
    float level = [[SUNScreenManager sharedManager] brightnessLevelFromScreen:self.screen];
    self.view.slider.doubleValue = level*100;
}

@end
