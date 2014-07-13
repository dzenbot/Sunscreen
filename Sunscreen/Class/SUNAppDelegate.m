//
//  SUNAppDelegate.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNAppDelegate.h"
#import "SunscreenManager.h"

@interface SUNAppDelegate ()
@property (nonatomic, readonly) NSStatusItem *statusItem;
@property (nonatomic, readonly) NSMenu *mainMenu;
@property (nonatomic, readonly) NSMenuItem *optionsItem;
@end

@implementation SUNAppDelegate
@synthesize statusItem = _statusItem;
@synthesize mainMenu = _mainMenu;
@synthesize optionsItem = _optionsItem;


#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // applicationDidFinishLaunching
}


#pragma mark - NSMenuDelegate

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    [self updateMenu];
}


#pragma mark - Initializers

- (void)awakeFromNib
{
    [self.statusItem setEnabled:YES];
}


#pragma mark - Getters

- (NSStatusItem *)statusItem
{
    if (!_statusItem)
    {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        _statusItem.highlightMode = YES;
        _statusItem.image = [NSImage imageNamed:@"light_low"];
        _statusItem.alternateImage = [NSImage imageNamed:@"light_low_white"];
        _statusItem.menu = self.mainMenu;
    }
    return _statusItem;
}

- (NSMenu *)mainMenu
{
    if (!_mainMenu)
    {
        _mainMenu = [[NSMenu alloc] initWithTitle:@"Sunscreen"];
        _mainMenu.delegate = self;
        
        [_mainMenu addItem:self.optionsItem];
        
        NSMenuItem *separator = [NSMenuItem separatorItem];
        NSMenuItem *quiteItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit:) keyEquivalent:@"q"];
        
        [_mainMenu addItem:separator];
        [_mainMenu addItem:quiteItem];
    }
    return _mainMenu;
}

- (NSMenuItem *)optionsItem
{
    if (!_optionsItem)
    {
        _optionsItem = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
        _optionsItem.view = self.contentView;
    }
    return _optionsItem;
}


#pragma mark - IBActions

- (IBAction)sliderChanged:(id)sender
{
    float level = self.slider.doubleValue/100;
    
    [SunscreenManager sharedManager].brightnessLevel = level;
}

- (IBAction)adjustAutomatically:(id)sender
{
    BOOL on = self.checkbox.state;
    [self enableSlider:!on];
    
    [SunscreenManager sharedManager].autoBrightnessMode = on;
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:sender];
}


#pragma mark - Updates

- (void)updateMenu
{
    BOOL autoBrightness = [SunscreenManager sharedManager].autoBrightnessMode;
    self.checkbox.state = autoBrightness;
    
    self.slider.doubleValue = [SunscreenManager sharedManager].brightnessLevel*100;
    [self enableSlider:!autoBrightness];
}

- (void)enableSlider:(BOOL)enable
{
    [self.slider setEnabled:enable];
    self.slider.alphaValue = enable ? 1.0 : 0.5;
}


#pragma mark - Lifeterm

- (void)dealloc
{
    _statusItem = nil;
    _mainMenu = nil;
    _optionsItem = nil;
}

@end
