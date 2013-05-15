//
//  CDFMainView.m
//  Codyfine
//
//  Created by Jiahao Li on 5/14/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import "CDFMainView.h"

@implementation CDFMainView

@synthesize themeColor;
@synthesize codeView; 

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (self) {
        [self setCodeView:[ACEView new]];
        [self addSubview:[self codeView]];
        [self replaceComponents];
    }
    
    return self;
}

- (void) replaceComponents
{
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    NSRect innerBounds = bounds;
    
    innerBounds.origin.x += 50;
    innerBounds.origin.y += 50;
    innerBounds.size.width -= 100;
    innerBounds.size.height -= 100; 
    
    // Set color
    [[self themeColor] set];
    [[NSColor whiteColor] setFill];
    
    // Draw the border
    NSBezierPath *border = [NSBezierPath bezierPathWithRoundedRect:innerBounds xRadius:10.0 yRadius:10.0];
    [border setLineWidth:2.0];
    [border fill];
    [border stroke];
    
    // Draw the logo
    NSRect logoRect;
    logoRect.origin.x = 15;
    logoRect.origin.y = bounds.size.height - 85;
    logoRect.size.width = 70;
    logoRect.size.height = 70;
    
    // Draw the logo. 
    NSBezierPath *logo = [NSBezierPath bezierPathWithOvalInRect:logoRect];
    [logo setLineWidth:2.0];
    [logo fill];
    [logo stroke];
    
    // Draw the seperation line
    NSBezierPath *sepLine = [[NSBezierPath alloc] init];
    [sepLine moveToPoint:NSMakePoint(innerBounds.origin.x, innerBounds.origin.y + innerBounds.size.height - 60)];
    [sepLine lineToPoint:NSMakePoint(innerBounds.size.width + innerBounds.origin.x, innerBounds.origin.y + innerBounds.size.height - 60)];
    [sepLine setLineWidth:2.0];
    [sepLine stroke];
    
    // Draw the code border
    NSRect contentBorderRect = innerBounds;
    contentBorderRect.origin.x += 15;
    contentBorderRect.origin.y += 15;
    contentBorderRect.size.height -= 90;
    contentBorderRect.size.width -= 30;
    NSBezierPath *contentBorder = [NSBezierPath bezierPathWithRect:contentBorderRect];
    [contentBorder setLineWidth:2.0]; 
    [contentBorder stroke];
}

@end
