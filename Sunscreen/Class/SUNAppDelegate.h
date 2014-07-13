//
//  SUNAppDelegate.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern CFAbsoluteTime startTime;

@interface SUNAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

- (IBAction)quit:(id)sender;

@end
