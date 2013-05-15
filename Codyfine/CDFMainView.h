//
//  CDFMainView.h
//  Codyfine
//
//  Created by Jiahao Li on 5/14/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ACEView/ACEView.h"
#import "CDFMainController.h"

@class CDFMainController; 

@interface CDFMainView : NSView

@property (nonatomic) NSColor *themeColor;
@property (nonatomic) ACEView *codeView;
@property (nonatomic) NSScrollView *messageScroll; 
@property (nonatomic) NSTextView *messageField;
@property (nonatomic) NSString *message;

@property (nonatomic) NSButton *runButton;
@property (nonatomic) NSButton *stopButton;

@property (nonatomic) NSButton *createButton;
@property (nonatomic) NSButton *openButton;
@property (nonatomic) NSButton *saveButton;

@property (nonatomic) NSButton *closeButton;
@property (nonatomic) NSButton *miniaturizeButton;

@property (nonatomic) NSButton *nextButton;
@property (nonatomic) NSButton *prevButton;

@property (nonatomic) NSImageView *logoView;
@property (nonatomic) NSImageView *maskingView; 

@property (nonatomic) CDFMainController *controller;

- (id)initWithController:(CDFMainController *)controller;

- (void) performClose:(id)sender;
- (void) performMiniaturize:(id)sender;
- (void) saveDocument:(id)sender;
- (void) newDocument:(id)sender;
- (void) openDocument:(id)sender; 

@end
