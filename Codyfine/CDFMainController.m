//
//  CDFMainController.m
//  Codyfine
//
//  Created by Jiahao Li on 5/15/13.
//  Copyright (c) 2013 Jiahao Li. All rights reserved.
//

#import "CDFMainController.h"

@implementation CDFMainController {
    BOOL loaded;
}

@synthesize view;
@synthesize window;
@synthesize edited;
@synthesize currentFilename;
@synthesize compiler; 

- (void)textDidChange:(NSNotification *)notification
{
    
    // Because of the loading time of ACEView, block the first change
    if (loaded)
        [self setEdited:YES];
    else
        loaded = YES;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        // Intiailizing the main view
        [self setView:[[CDFMainView alloc] initWithController:self]];
        [[self view] setThemeColor:[NSColor blackColor]];
        [[self view] setMessage:@"Keep calm and ... happy coding! :)"];
        
        [self create];
        
        compiler = [[CDFLocalCompiler alloc] init];
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

- (void) open
{
    if ([self edited]) {
        if (![self askSave])
            return;
    }
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"cpp", @"c", nil]];
    
    NSInteger result = [openPanel runModal];
    
    if (result == NSOKButton) {
        // Open the file
        [self readFile:[[openPanel URL] path]]; 
    }
}

- (void) create
{
    if ([self edited]) {
        if (![self askSave])
            return;
    }
    
    
    NSString *sampleCodes = [NSString stringWithFormat:
                             @"\n"
                             "/*\n"
                             " * Just a simple editor that does not know how to sell meng :) \n"
                             " */\n"
                             "\n"
                             "#include <stdio.h>\n"
                             "#include <stdlib.h>\n"
                             "\n"
                             "int main()\n"
                             "{\n"
                             "    printf(\"Hello, world! \"); \n"
                             "\n"
                             "    return 0; \n"
                             "}\n"
                             ];
    
    currentFilename = nil;
    [[[self view] codeView] setString:sampleCodes];
    [self setEdited:NO];
}

- (void) save
{
    [self attemptSave];
}

- (BOOL) askSave
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"The codes has not been saved yet. Wanna keep them? :)" defaultButton:@"Yeah" alternateButton:@"Cancel" otherButton:@"Nope" informativeTextWithFormat:@""];
    
    NSInteger response = [alert runModal];
    
    if (response == NSAlertDefaultReturn) {
        // Chose to save
        return [self attemptSave];
    } else if (response == NSAlertOtherReturn) {
        // Not to save
        return YES;
    } else {
        // To cancel; 
        return NO;
    }
}

- (BOOL) attemptSave
{
    if ([self currentFilename])
        return [self writeFile];
    else {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        
        [savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"cpp", @"c", nil]];
        
        NSInteger result = [savePanel runModal];
        currentFilename = [[savePanel URL] path];
        
        return [self writeFile];
    }
}

- (BOOL) writeFile
{
    // Check if the filename is set
    if ([self currentFilename] == nil) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"The filename does not seem to work ... :(" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        
        [alert runModal];
        return NO;
    }
    
    // Write the content
    NSString *content = [[[self view] codeView] string];
    NSError *error;
    [content writeToFile:[self currentFilename] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Ouch ... Seems that something happened ... :(" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        
        [alert runModal];
        return NO;
    }
    
    [self setEdited:NO];
    return YES; 
}

- (BOOL) readFile:(NSString *)path
{
    NSError *error;
    
    NSStringEncoding encoding;
    NSString *content = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:&error];
    
    if (error) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Ahhhh ... Seems that I hit something bad ... :(" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
        return NO;
    }
    
    [[[self view] codeView] setString:content];
    currentFilename = path;
    [self setEdited:NO];
    return YES;
}

- (void) run
{
    if (![self attemptSave]) {
        return;
    }
    
    [[self view] setMessage:@"Compiling hard T_T ..."];
    
    BOOL result = [[self compiler] run:[self currentFilename]];
    
    if (result) {
        // Success
        [[self view] setMessage:@"Compilation succeeded! :)"];
    } else {
        // Failure
        [[self view] setMessage:@"Compilation failed :("];
    }
}

@end
