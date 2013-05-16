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
    frame.size = NSMakeSize(1150, 700);
    [[self window] setFrame:frame display:YES];
    [[self window] center]; 
    
    // Insert the view
    [[self window] setContentView:[controller view]];
    
    // Linking the run menu item to the command
    [[self runMenu] setTarget:controller];
    [[self runMenu] setAction:@selector(run)];
    
    [[self sandboxMenu] setTarget:controller];
    [[self sandboxMenu] setAction:@selector(sandbox)];
    
    [controller setSandboxMenuItem:[self sandboxMenu]];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
