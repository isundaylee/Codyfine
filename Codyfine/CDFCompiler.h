//
//  CDFCompiler.h
//  Codyfine
//
//  Created by Jiahao Li on 5/15/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDFCompiler : NSObject

@property (nonatomic, readonly) NSMutableArray *errors;

- (BOOL) run:(NSString *)path;

@end
