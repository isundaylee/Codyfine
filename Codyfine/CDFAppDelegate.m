//
//  CDFAppDelegate.m
//  Codyfine
//
//  Created by Jiahao Li on 5/14/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import "CDFAppDelegate.h"
#import "CDFMainView.h"
#import "CDFMainController.h"

@implementation CDFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Initialize view controller
    CDFMainController *controller = [[CDFMainController alloc] init];
    [controller setWindow:[self window]]; 
    
    // Resize and relocate the window
    NSRect frame = [[self window] frame];
    frame.size = NSMakeSize(1024, 768);
    [[self window] setFrame:frame display:YES];
    [[self window] center]; 
    
    // Insert the view
    [[self window] setContentView:[controller view]];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
