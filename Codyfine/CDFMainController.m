//
//  CDFMainController.m
//  Codyfine
//
//  Created by Jiahao Li on 5/15/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import "CDFMainController.h"

@implementation CDFMainController

@synthesize view;
@synthesize window; 

- (id)init
{
    self = [super init];
    
    if (self) {
        // Intiailizing the main view
        [self setView:[[CDFMainView alloc] initWithController:self]];
        [[self view] setThemeColor:[NSColor blackColor]];
        [[self view] setMessage:@"Keep calm and ... happy coding! :)"];
    }
    
    return self;
}

- (void) close
{
    [[self window] close];
}

- (void) miniaturize
{
    [[self window] miniaturize:nil]; 
}

@end
