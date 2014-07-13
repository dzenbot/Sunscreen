//
//  SUNAppDelegate.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SUNAppDelegate.h"
#import "SUNViewController.h"

#import "SUNScreenManager.h"

#import "NSObject+System.h"

@interface SUNAppDelegate ()
@property (nonatomic, strong) NSMutableArray *viewControllers;

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

- (void)menuWillOpen:(NSMenu *)menu
{
    
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    NSLog(@"%s",__FUNCTION__);
    
    [self refreshMenu];
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
        
        if (!_viewControllers) {
            _viewControllers = [[NSMutableArray alloc] init];
        }
        
        for (SUNScreen *screen in [SUNScreenManager sharedManager].availableScreens) {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
            
            SUNViewController *controller = [[SUNViewController alloc] init];
            controller.screen = screen;
            item.view = controller.view;
            
            NSLog(@"screen : %@", screen.description);
            
            [_viewControllers addObject:controller];
            
            [_mainMenu addItem:item];
            
            NSMenuItem *separator = [NSMenuItem separatorItem];
            [_mainMenu addItem:separator];
        }
        
        NSString *appName = [NSString stringWithFormat:@"Quit %@", [SUNAppDelegate appName]];
        NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:appName action:@selector(quit:) keyEquivalent:@"q"];
        [_mainMenu addItem:quitItem];
    }
    return _mainMenu;
}


#pragma mark - IBActions

- (IBAction)quit:(id)sender
{
    [NSApp terminate:sender];
}


#pragma mark - Updates

- (void)refreshMenu
{
    [_viewControllers removeAllObjects];
    _viewControllers = nil;
    
    _mainMenu = nil;
    self.statusItem.menu = self.mainMenu;
}


#pragma mark - Lifeterm

- (void)dealloc
{
    _statusItem = nil;
    _mainMenu = nil;
    _optionsItem = nil;
}

@end
