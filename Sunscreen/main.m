//
//  main.m
//  Sunscreen
//
//  Created by Ignacio Romero Z. on 7/12/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

CFAbsoluteTime startTime;

int main(int argc, const char * argv[])
{
    startTime = CFAbsoluteTimeGetCurrent();
    
    return NSApplicationMain(argc, argv);
}
