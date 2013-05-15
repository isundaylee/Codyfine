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

@interface CDFMainController : NSController

@property (nonatomic) CDFMainView *view;
@property (nonatomic) NSWindow *window; 

- (void) close;

- (void) miniaturize; 

@end
