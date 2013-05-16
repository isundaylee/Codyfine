//
//  CDFMainController.h
//  Codyfine
//
//  Created by Jiahao Li on 5/15/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFMainView.h"
#import "CDFCompiler.h"
#import "CDFLocalCompiler.h"

@class CDFMainView; 

@interface CDFMainController : NSController <ACEViewDelegate>

@property (nonatomic) CDFMainView *view;
@property (nonatomic) NSWindow *window;
@property (nonatomic) BOOL edited;
@property (nonatomic, readonly) NSString *currentFilename;
@property (nonatomic, readonly) CDFCompiler *compiler;
@property (nonatomic, readonly) NSMutableArray *errors;
@property (nonatomic) NSInteger currentErrorIndex;

@property (nonatomic) NSMenuItem *sandboxMenuItem;

- (void) close;

- (void) miniaturize;

- (void) open;

- (void) save;

- (void) create;

- (void) run;

- (void) next;

- (void) prev;

- (void) revealFile; 

@end
