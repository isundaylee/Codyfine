//
//  CDFLocalCompiler.m
//  Codyfine
//
//  Created by Jiahao Li on 5/15/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import "CDFLocalCompiler.h"

@implementation CDFLocalCompiler

- (BOOL)run:(NSString *)path
{
    NSString *directory = [path stringByDeletingLastPathComponent];
    NSString *basename = [[path lastPathComponent] stringByDeletingPathExtension];
    
    NSString *outname = [directory stringByAppendingPathComponent:basename];
    
    NSString *compiler = @"/usr/bin/g++";
    
    NSTask *compileTask = [[NSTask alloc] init];
    
    [compileTask setLaunchPath:compiler];
    [compileTask setArguments:[NSArray arrayWithObjects:@"-o", outname, path, nil]];
    
    NSPipe *pipe = [NSPipe pipe];
    
    [compileTask setStandardError:pipe];
    
    NSFileHandle *reader = [pipe fileHandleForReading];
    
    [compileTask launch];
    
    NSData *data = [reader readDataToEndOfFile];
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [compileTask waitUntilExit]; 
    
    if ([compileTask terminationStatus] == 0) {
        NSTask *runTask = [[NSTask alloc] init];
        [runTask setLaunchPath:@"/usr/bin/open"];
        [runTask setArguments:[NSArray arrayWithObject:outname]];
        [runTask launch];
        return YES; 
    } else {
        NSArray *entries = [result componentsSeparatedByString:@"\n"];
        for (int i=0; i<[entries count]; i++) {
            NSString *entry = [entries objectAtIndex:i];
            NSLog(@"%@", entry); 
        }
        return NO;
    }
}

@end
