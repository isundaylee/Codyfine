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
    
    BOOL shouldDrag;
    BOOL shouldRedoInitials;
    NSPoint initialLocation;
    NSPoint initialLocationOnScreen;
    NSRect initialFrame;
    NSPoint currentLocation;
    NSPoint newOrigin;
    NSRect screenFrame;
    NSRect windowFrame;
    float minY; 
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

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (shouldRedoInitials) {
        initialLocation = [theEvent locationInWindow];
        initialLocationOnScreen = [self convertBaseToScreen:[theEvent locationInWindow]];
        
        initialFrame = [self frame];
        shouldRedoInitials = NO;
        
        screenFrame = [[NSScreen mainScreen] frame];
        windowFrame = [self frame];
        
        minY = windowFrame.origin.y + (windowFrame.size.height - 288);
    }
    
    currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
    
    newOrigin.x = currentLocation.x - initialLocation.x;
    newOrigin.y = currentLocation.y - initialLocation.y;
    
    if ((newOrigin.y + windowFrame.size.height) > (screenFrame.origin.y + screenFrame.size.height))
    {
        newOrigin.y = screenFrame.origin.y + (screenFrame.size.height - windowFrame.size.height);
    }
    
    [self setFrameOrigin:newOrigin];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    shouldRedoInitials = YES;
}

@end
