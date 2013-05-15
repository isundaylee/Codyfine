//
//  CDFMainController.h
//  Codyfine
//
//  Created by Jiahao Li on 5/15/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFMainView.h"

@class CDFMainView; 

@interface CDFMainController : NSController <ACEViewDelegate>

@property (nonatomic) CDFMainView *view;
@property (nonatomic) NSWindow *window;
@property (nonatomic) BOOL edited;
@property (nonatomic, readonly) NSString *currentFilename; 

- (void) close;

- (void) miniaturize;

- (void) open;

- (void) save;

- (void) create; 

@end
