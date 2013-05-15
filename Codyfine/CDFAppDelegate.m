//
//  CDFAppDelegate.m
//  Codyfine
//
//  Created by Jiahao Li on 5/14/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import "CDFAppDelegate.h"
#import "CDFMainView.h"

@implementation CDFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    CDFMainView *view = [[CDFMainView alloc] init];
    [view setThemeColor:[NSColor blackColor]];
    
    // Resize and relocate the window
    NSRect frame = [[self window] frame];
    frame.size = NSMakeSize(1024, 768);
    [[self window] setFrame:frame display:YES];
    [[self window] center]; 
    
    // Insert the main view
    [[self window] setContentView:view];
}

@end
