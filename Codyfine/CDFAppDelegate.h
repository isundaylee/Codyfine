//
//  CDFAppDelegate.h
//  Codyfine
//
//  Created by Jiahao Li on 5/14/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CDFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenuItem *runMenu;
@property (assign) IBOutlet NSMenuItem *sandboxMenu; 

@end
