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
@synthesize messageField;

@synthesize runButton;
@synthesize stopButton;

@synthesize createButton;
@synthesize openButton;
@synthesize saveButton;

@synthesize closeButton;
@synthesize miniaturizeButton; 

@synthesize nextButton;
@synthesize prevButton;

@synthesize logoView;
@synthesize maskingView; 

@synthesize controller;

- (BOOL)canBecomeKeyView
{
    return YES; 
}

- (void)setMessage:(NSString *)message
{
    [[self messageField] setString:message];
}

- (NSString *)message
{
    return [[self messageField] string];
}

- (id)initWithController:(CDFMainController *)controller; 
{
    self = [super init];
    
    if (self) {
        
        // Setting the controller
        
        [self setController:controller]; 
        
        // Initializing the message scroll view
        
        [self setMessageScroll:[NSScrollView new]];
        [[self messageScroll] setBorderType:NSNoBorder];
        [[self messageScroll] setHasVerticalScroller:YES];
        [[self messageScroll] setHasHorizontalScroller:NO];
        [[self messageScroll] setBackgroundColor:[NSColor blackColor]];
        [[[self messageScroll] verticalScroller] setControlSize:NSMiniControlSize]; 
        [self addSubview:[self messageScroll]];
        
        // Initializing the message label. 
        
        [self setMessageField:[[NSTextView alloc] init]];
        [[self messageField] setFont:[NSFont fontWithName:@"Monaco" size: 13]];
//        [[self messageField] setDrawsBackground:NO];
        [[self messageField] setEditable:NO];
        [[self messageField] setAlignment:NSCenterTextAlignment];
        [[self messageField] setHorizontallyResizable:NO]; 
        [[self messageScroll] setDocumentView:[self messageField]];
        
        // Initializing the code editor
        
        [self setCodeView:[[ACEView alloc] init]];
        
        // This line is creepy. But I guess the one that designed the ACEView Cocoa intended to only let it work through NIB-loading?
        [[self codeView] awakeFromNib];
        
        [[self codeView] setDelegate:[self controller]];
        [[self codeView] setMode:ACEModeCPP];
        [[self codeView] setTheme:ACEThemeTextmate];
        
        [self addSubview:[self codeView]];
        
        // Initiailizing the buttons
        
        [self setRunButton:[[NSButton alloc] init]];
        [[self runButton] setImage:[NSImage imageNamed:@"build"]];
        [[[self runButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown]; 
        [[self runButton] setBordered:NO];
        [[self runButton] setTarget:[self controller]];
        [[self runButton] setAction:@selector(run)]; 
        [self addSubview:[self runButton]];
        
//        [self setStopButton:[[NSButton alloc] init]];
//        [[self stopButton] setImage:[NSImage imageNamed:@"stop"]];
//        [[[self stopButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown];
//        [[self stopButton] setBordered:NO];
//        [self addSubview:[self stopButton]];
        
        [self setCreateButton:[[NSButton alloc] init]];
        [[self createButton] setImage:[NSImage imageNamed:@"create"]];
        [[[self createButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown];
        [[self createButton] setBordered:NO];
        [[self createButton] setTarget:self];
        [[self createButton] setAction:@selector(newDocument:)];
        [self addSubview:[self createButton]];
        
        [self setOpenButton:[[NSButton alloc] init]];
        [[self openButton] setImage:[NSImage imageNamed:@"open"]];
        [[[self openButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown];
        [[self openButton] setBordered:NO];
        [[self openButton] setTarget:self];
        [[self openButton] setAction:@selector(openDocument:)];
        [self addSubview:[self openButton]];
        
        [self setSaveButton:[[NSButton alloc] init]];
        [[self saveButton] setImage:[NSImage imageNamed:@"save"]];
        [[[self saveButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown];
        [[self saveButton] setBordered:NO];
        [[self saveButton] setTarget:self];
        [[self saveButton] setAction:@selector(saveDocument:)];
        [self addSubview:[self saveButton]];
        
        // Initializing application control buttons
        
        [self setCloseButton:[[NSButton alloc] init]];
        [[self closeButton] setImage:[NSImage imageNamed:@"close"]];
        [[[self closeButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown];
        [[self closeButton] setBordered:NO];
        [[self closeButton] setTarget:self];
        [[self closeButton] setAction:@selector(performClose:)];
        [self addSubview:[self closeButton]];
        
        [self setMiniaturizeButton:[[NSButton alloc] init]];
        [[self miniaturizeButton] setImage:[NSImage imageNamed:@"miniaturize"]];
        [[[self miniaturizeButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown];
        [[self miniaturizeButton] setBordered:NO];
        [[self miniaturizeButton] setTarget:self];
        [[self miniaturizeButton] setAction:@selector(performMiniaturize:)];
        [self addSubview:[self miniaturizeButton]];
        
        // Initializing the masking view
        [self setMaskingView:[NSImageView new]];
        [[self maskingView] setImage:[NSImage imageNamed:@"blank.png"]];
        [self addSubview:[self maskingView]];
        
        // Initializing error message navigation buttons
        
        [self setNextButton:[NSButton new]];
        [[self nextButton] setImage:[NSImage imageNamed:@"next"]];
        [[self nextButton] setBordered:NO];
        [[[self nextButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown]; 
        [[self nextButton] setTarget:[self controller]];
        [[self nextButton] setAction:@selector(next)];
        [self addSubview:[self nextButton]];
        
        [self setPrevButton:[NSButton new]];
        [[self prevButton] setImage:[NSImage imageNamed:@"prev"]];
        [[self prevButton] setBordered:NO];
        [[[self prevButton] cell] setImageScaling:NSImageScaleProportionallyUpOrDown];
        [[self prevButton] setTarget:[self controller]];
        [[self prevButton] setAction:@selector(prev)];
        [self addSubview:[self prevButton]];
        
        // Initializing the logo ivew
        [self setLogoView:[NSImageView new]];
        [[self logoView] setImage:[NSImage imageNamed:@"logo.png"]];
        [self addSubview:[self logoView]];
    }
    
    return self;
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
    [[self logoView] setFrame:logoRect];
    
    // Draw the seperation line
    NSBezierPath *sepLine = [[NSBezierPath alloc] init];
    [sepLine moveToPoint:NSMakePoint(innerBounds.origin.x, innerBounds.origin.y + innerBounds.size.height - 70)];
    [sepLine lineToPoint:NSMakePoint(innerBounds.size.width + innerBounds.origin.x, innerBounds.origin.y + innerBounds.size.height - 70)];
    [sepLine setLineWidth:2.0];
    [sepLine stroke];
    
    // Draw the message box border
    NSRect messageBox = NSMakeRect(innerBounds.origin.x + innerBounds.size.width / 2 - 200, innerBounds.origin.y + innerBounds.size.height - 55, 400, 40);
    NSBezierPath *messageBoxBorder = [NSBezierPath bezierPathWithRoundedRect:messageBox xRadius:5.0 yRadius:5.0];
    [messageBoxBorder setLineWidth:2.0];
    [messageBoxBorder stroke];
    
    // Replace the message field
    [[self messageScroll] setFrame:NSInsetRect(messageBox, 13.0, 12.0)];
    [[self messageField] setFrame:NSMakeRect(0, 0, [self messageScroll].contentSize.width, [self messageScroll].contentSize.height)];
    
    // Place the errors navigation buttons
    NSRect nextBox = NSMakeRect(messageBox.origin.x + messageBox.size
                                .width - 25, messageBox.origin.y + 12, 16, 16);
    NSRect prevBox = NSMakeRect(messageBox.origin.x + 9, messageBox.origin.y + 12, 16, 16);
    [[self nextButton] setFrame:nextBox];
    [[self prevButton] setFrame:prevBox];
    [[self maskingView] setFrame:nextBox];
    
    // Place the buttons
    NSRect buttonBox = NSMakeRect(innerBounds.origin.x + innerBounds.size.width / 2 - 300, innerBounds.origin.y + innerBounds.size.height - 50, 30, 30);
//    [[self stopButton] setFrame:buttonBox];
//    
//    buttonBox.origin.x -= 50;
    [[self runButton] setFrame:buttonBox];
    
    buttonBox = NSMakeRect(innerBounds.origin.x + innerBounds.size.width / 2 + 270, innerBounds.origin.y + innerBounds.size.height - 50, 30, 30);
    [[self createButton] setFrame:buttonBox];
    
    buttonBox.origin.x += 50;
    [[self openButton] setFrame:buttonBox];
    
    buttonBox.origin.x += 50;
    [[self saveButton] setFrame:buttonBox];
    
    // Place the window control buttons
    buttonBox = NSMakeRect(innerBounds.origin.x + innerBounds.size.width - 20, innerBounds.origin.y + innerBounds.size.height - 20, 10, 10);
    [[self closeButton] setFrame:buttonBox];
    
    buttonBox.origin.y -= 20;
    [[self miniaturizeButton] setFrame:buttonBox]; 
    
    // Define the code border
    NSRect contentBorderRect = innerBounds;
    contentBorderRect.origin.x += 15;
    contentBorderRect.origin.y += 15;
    contentBorderRect.size.height -= 100;
    contentBorderRect.size.width -= 30;
    
    // Replace the code view
    [[self codeView] setFrame:NSInsetRect(contentBorderRect, 0.0f, 0.0f)];
    
    NSBezierPath *maskingBezier = [NSBezierPath bezierPathWithRect:nextBox];
    [maskingBezier fill];
}

- (void)performClose:(id)sender
{
    [[self controller] close];
}

- (void)performMiniaturize:(id)sender
{
    [[self controller] miniaturize]; 
}

- (void)saveDocument:(id)sender
{
    [[self controller] save]; 
}

- (void)newDocument:(id)sender
{
    [[self controller] create]; 
}

- (void)openDocument:(id)sender
{
    [[self controller] open];
}

@end
