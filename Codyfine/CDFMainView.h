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
@property (nonatomic) NSTextField *messageField;
@property (nonatomic) NSString *message;

@property (nonatomic) NSButton *runButton;
@property (nonatomic) NSButton *stopButton;

@property (nonatomic) NSButton *createButton;
@property (nonatomic) NSButton *openButton;
@property (nonatomic) NSButton *saveButton;

@property (nonatomic) NSButton *closeButton;
@property (nonatomic) NSButton *miniaturizeButton;

@property (nonatomic) CDFMainController *controller;

- (id)initWithController:(CDFMainController *)controller; 

@end
