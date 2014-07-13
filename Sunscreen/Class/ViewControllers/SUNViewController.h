//
//  SUNViewController.h
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SUNView.h"

@class SUNScreen;

@interface SUNViewController : NSViewController

@property (nonatomic, strong) SUNScreen *screen;

@property (strong) SUNView *view;

- (IBAction)sliderDidChange:(id)sender;
//- (IBAction)checkBoxDidChange:(id)sender;

- (void)refreshSubviews;

@end
