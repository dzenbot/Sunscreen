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
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, readonly) NSStatusItem *statusItem;
@property (nonatomic, readonly) NSMenu *mainMenu;
@property (nonatomic, readonly) NSView *adjustmentView;
@end

@implementation SUNAppDelegate
@synthesize statusItem = _statusItem;
@synthesize mainMenu = _mainMenu;
@synthesize adjustmentView = _adjustmentView;


#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustGlobalBrightness:) name:kAdjustGlobalBrightnessNotification object:nil];
}


#pragma mark - NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu
{
    NSLog(@"%s",__FUNCTION__);
    
    [self refreshMenu];
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    NSLog(@"%s",__FUNCTION__);
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
        
        for (SUNScreen *screen in [SUNScreenManager sharedManager].availableScreens) {
            
            if (!_viewControllers) {
                _viewControllers = [[NSMutableArray alloc] init];
                _items = [[NSMutableArray alloc] init];
            }

            NSInteger idx = _mainMenu.itemArray.count;
            [self insertScreen:screen atMenuIndex:idx];
        }
        
        NSMenuItem *globalItem = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
        globalItem.view = self.adjustmentView;
        [_mainMenu addItem:globalItem];
        
        [_mainMenu addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *launchItem = [[NSMenuItem alloc] initWithTitle:@"Open at Login" action:@selector(lauchAtStartup:) keyEquivalent:@""];
        [_mainMenu addItem:launchItem];
        
        [_mainMenu addItem:[NSMenuItem separatorItem]];

        NSString *appName = [NSString stringWithFormat:@"Quit %@", [SUNAppDelegate appName]];
        NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:appName action:@selector(quit:) keyEquivalent:@"q"];
        [_mainMenu addItem:quitItem];
    }
    return _mainMenu;
}

- (NSView *)adjustmentView
{
    if (!_adjustmentView)
    {
        _adjustmentView = [[NSView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 230.0, 44.0)];
        
        NSButton *checkbox = [[NSButton alloc] initWithFrame:NSMakeRect(12.0, 12.0, 206, 20)];
        [checkbox setButtonType:NSSwitchButton];
        [checkbox setTitle:@"Global Brightness Adjustment"];
        [checkbox setTarget:self];
        [checkbox setAction:@selector(allowGlobalBrightness:)];
        
        [_adjustmentView addSubview:checkbox];
    }
    return _adjustmentView;
}


#pragma mark - IBActions

- (IBAction)allowGlobalBrightness:(NSMenuItem *)sender
{
    [[SUNScreenManager sharedManager] setBrightnessMode:sender.state];
    
    if (sender.state == SUNScreenBrightnessModeGlobal) {
        double level = 0.5;
        [[SUNScreenManager sharedManager] setGlobalBrightnessLevel:level];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdjustGlobalBrightnessNotification object:@(level)];
    }
}

- (IBAction)lauchAtStartup:(NSMenuItem *)sender
{
    sender.state = !sender.state;
    
    NSLog(@"%s",__FUNCTION__);
}

- (IBAction)quit:(NSMenuItem *)sender
{
    [NSApp terminate:sender];
}


#pragma mark - Updates

- (NSArray *)presentedScreens
{
    NSMutableArray *screens = [NSMutableArray new];
    
    for (SUNViewController *controller in _viewControllers) {
        [screens addObject:controller.screen];
    }
    
    return screens;
}

- (void)refreshMenu
{
    NSLog(@"%s",__FUNCTION__);
    
    NSArray *screens = [SUNScreenManager sharedManager].availableScreens;

    // Should insert new items
    if (screens.count > _viewControllers.count) {
        
        NSLog(@"Should insert new items");
        
        NSMutableSet *set = [NSMutableSet setWithArray:screens];
        [set minusSet:[NSSet setWithArray:[self presentedScreens]]];
        
        for (SUNScreen *screen in [set allObjects]) {
            NSInteger idx = _mainMenu.itemArray.count-4;
            [self insertScreen:screen atMenuIndex:idx];
        }
    }
    // Should remove old items
    else if (screens.count < _viewControllers.count) {
        
        NSLog(@"Should remove old items");

        NSMutableSet *set = [NSMutableSet setWithArray:[self presentedScreens]];
        [set intersectSet:[NSSet setWithArray:screens]];
        
        for (SUNScreen *screen in [set allObjects]) {
            [self removeScreen:screen];
        }
    }
    // Should update current items
    else {
        
        NSLog(@"Should update current items");
        
        for (SUNViewController *controller in self.viewControllers) {
            [controller refreshSubviews];
        }
    }
}

- (void)insertScreen:(SUNScreen *)screen atMenuIndex:(NSInteger)idx
{
    NSLog(@"%s : %ld",__FUNCTION__, (long)idx);
    
    if (idx < 0 || !screen) {
        return;
    }
    
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    
    SUNViewController *controller = [[SUNViewController alloc] init];
    controller.screen = screen;
    item.view = (NSView *)controller.view;
    
    [_viewControllers addObject:controller];
    [_items addObject:item];
    
    [_mainMenu insertItem:item atIndex:idx];
    [_mainMenu addItem:[NSMenuItem separatorItem]];
}

- (void)removeScreen:(SUNScreen *)screen
{
    NSInteger arrayIdx = -1;
    
    for (SUNViewController *controller in _viewControllers) {
        if (controller.screen.displayID != screen.displayID) {
            arrayIdx = [_viewControllers indexOfObject:controller];
        }
    }
    
    if (arrayIdx < 0) {
        return;
    }
    
    NSMenuItem *item = _items[arrayIdx];
    [self.mainMenu removeItem:item];
    
    [_viewControllers removeObjectAtIndex:arrayIdx];
    [_items removeObjectAtIndex:arrayIdx];
}

- (IBAction)adjustGlobalBrightness:(NSNotification *)notification
{
    for (SUNViewController *controller in self.viewControllers) {
        double level = [notification.object doubleValue]*100;
        [controller.view.slider setDoubleValue:level];
    }
}

- (void)resetMenu
{
    [_viewControllers removeAllObjects];
    _viewControllers = nil;
    
    [_items removeAllObjects];
    _items = nil;
    
    _mainMenu = nil;
    self.statusItem.menu = self.mainMenu;
}


#pragma mark - Lifeterm

- (void)dealloc
{
    _statusItem = nil;
    _mainMenu = nil;
}

@end
