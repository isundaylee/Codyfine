//
//  CDFLocalCompiler.m
//  Codyfine
//
//  Created by Jiahao Li on 5/15/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import "CDFLocalCompiler.h"

@implementation CDFLocalCompiler

@synthesize errors;

/*
 * Used to check if the compile environment is set
 */
- (BOOL)checkEnvironment
{
    // For now simply run a g++ -v to check if g++ is installed correctly
    
    NSTask *test = [[NSTask alloc] init];
    
    [test setLaunchPath:@"/usr/bin/g++"];
    [test setArguments:[NSArray arrayWithObject:@"-v"]];
    
    @try {
        [test launch];
    } @catch (NSException *exception) {
        return NO;
    }
    
    [test waitUntilExit];
    
    return ([test terminationStatus] == 0);
}

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
    
    errors = [NSMutableArray array];
    
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
            
            // See if matches :line:column:
            NSString *regexp1 = @":([0-9]*):([0-9]*): error:(.*)$";
            NSRegularExpression *reg1 = [NSRegularExpression regularExpressionWithPattern:regexp1 options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *result1 = [reg1 firstMatchInString:entry options:0 range:NSMakeRange(0, [entry length])];
            
            if (result1) {
                NSNumber *line = [NSNumber numberWithInteger:[[entry substringWithRange:[result1 rangeAtIndex:1]] integerValue]];
                NSNumber *column = [NSNumber numberWithInteger:[[entry substringWithRange:[result1 rangeAtIndex:2]] integerValue]];
                NSString *error = [entry substringWithRange:[result1 rangeAtIndex:3]];
                [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:line, @"line", column, @"column", error, @"error", nil]];
                continue;
            }
            
            // See if matches :line:
            NSString *regexp = @":([0-9]*): error:(.*)$";
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regexp options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *result = [reg firstMatchInString:entry options:0 range:NSMakeRange(0, [entry length])];
            if (result) {
                NSNumber *line = [NSNumber numberWithInteger:[[entry substringWithRange:[result rangeAtIndex:1]] integerValue]];
                NSString *error = [entry substringWithRange:[result rangeAtIndex:2]];
                [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:line, @"line", error, @"error", nil]];
            }
        }
        return NO;
    }
}

@end
