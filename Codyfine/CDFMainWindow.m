//
//  CDFMainWindow.m
//  Codyfine
//
//  Created by Jiahao Li on 5/14/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import "CDFMainWindow.h"

@implementation CDFMainWindow {
    NSView *childContentView;
}

const int WINDOW_FRAME_PADDING = 75;

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super
            initWithContentRect:contentRect
            styleMask:NSBorderlessWindowMask
            backing:bufferingType
            defer:flag];
    
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
    }
    
    return self;
}

- (NSRect) contentRectForFrameRect:(NSRect)frameRect
{
    frameRect.origin = NSZeroPoint;
    return NSInsetRect(frameRect, WINDOW_FRAME_PADDING, WINDOW_FRAME_PADDING);
}

- (NSRect) frameRectForContentRect:(NSRect)contentRect
{
    return NSInsetRect(contentRect, -WINDOW_FRAME_PADDING, -WINDOW_FRAME_PADDING);
}

- (BOOL)canBecomeKeyWindow
{
    return YES; 
}

@end
