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
@synthesize errors;
@synthesize currentErrorIndex;
@synthesize sandboxMenuItem; 

- (void)setSandboxMenuItem:(NSMenuItem *)newItem
{
    sandboxMenuItem = newItem;
    [[self sandboxMenuItem] setEnabled:([self currentFilename] == nil)];
}

- (void)setCurrentFilename:(NSString *)newName
{
    [[[self view] sandboxButton] setEnabled:(newName == nil)];
    [[self sandboxMenuItem] setEnabled:(newName == nil)]; 
    currentFilename = newName;
}

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
//        [[self view] setMessage:@"Users/Sunday/Desktop/hello.cpp:18: error: expected `;' before 'ut'"];
        
        [self create];
        
        compiler = [[CDFLocalCompiler alloc] init];
        
        currentErrorIndex = -1; 
        [self tweakNavigators];
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
    
    [self setCurrentFilename:nil];
    
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
        
        if (result != NSOKButton) {
            return NO;
        }
        
        [self setCurrentFilename:[[savePanel URL] path]];
        
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
    [self setCurrentFilename:path];
    [self setEdited:NO];
    return YES;
}

- (void) run
{
    if (![self attemptSave]) {
        return;
    }
    
    if (![[self compiler] checkEnvironment]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Ahhh ... I don't seem to have anything to compile with ... Get me some compiler first 2333" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
        return;
    }
    
    [[self view] setMessage:@"Compiling hard T_T ..."];
    
    BOOL result = [[self compiler] run:[self currentFilename]];
    
    if (result) {
        // Success
        [[self view] setMessage:@"Compilation succeeded! :)"];
        [self tweakNavigators]; 
    } else {
        // Failure
        errors = [compiler errors]; 
        [[self view] setMessage:[NSString stringWithFormat:@"Compilation failed, %ld errors. :(", [[self errors] count]]];
        [self setCurrentErrorIndex:-1];
        [self tweakNavigators];
    }
}

- (void)next
{
    if (currentErrorIndex == -1 && [self errors] && [[self errors] count] > 0)
        [self selectErrorIndex:0]; 
    else if (currentErrorIndex + 1 < [[self errors] count])
        [self selectErrorIndex:currentErrorIndex + 1];
}

- (void)prev
{
    if (currentErrorIndex == -1 && [self errors] && [[self errors] count] > 0)
        [self selectErrorIndex:0];
    else if (currentErrorIndex > 0)
        [self selectErrorIndex:currentErrorIndex - 1];
}

- (void) selectErrorIndex:(NSInteger) index
{
    [self setCurrentErrorIndex:index];
    
    NSDictionary *error = [[self errors] objectAtIndex:[self currentErrorIndex]];
    
    [[self view] setMessage:[error objectForKey:@"error"]];
    
    NSInteger line = [[error objectForKey:@"line"] integerValue];
    NSInteger column = 0;
    
    if ([error objectForKey:@"column"])
        column = [[error objectForKey:@"column"] intValue];
    
    [[[self view] codeView] gotoLine:line column:column animated:YES];
    [self tweakNavigators];
}

- (void)tweakNavigators
{
    if (currentErrorIndex == -1) {
        // Nothing selected
        if ([self errors] && [[self errors] count] > 0) {
            [[[self view] nextButton] setEnabled:YES];
            [[[self view] prevButton] setEnabled:YES];
        } else {
            [[[self view] nextButton] setEnabled:NO];
            [[[self view] prevButton] setEnabled:NO];
        }
    } else {
        if ([self currentErrorIndex] + 1 < [[self errors] count]) {
            [[[self view] nextButton] setEnabled:YES];
        } else {
            [[[self view] nextButton] setEnabled:NO];
        }
        
        if ([self currentErrorIndex] > 0) {
            [[[self view] prevButton] setEnabled:YES];
        } else {
            [[[self view] prevButton] setEnabled:NO]; 
        }
    }
}

- (void)sandbox
{
    if ([self currentFilename])
        return;
    
    NSString *filename = [[self temporaryFilePath] stringByAppendingString:@".cpp"];
    
    [self setCurrentFilename:filename];
    
    [self attemptSave];
}

- (NSString*)UUIDString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    return (__bridge NSString *) string; 
}

- (NSString*)temporaryFilePath
{
    while (true) {
        NSString *randstr = [self UUIDString];
        NSString *filename = [NSString stringWithFormat:@"/var/tmp/%@", randstr];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
            return filename;
    }
}

- (void)revealFile
{
    if (![self currentFilename])
        return;
    
    [[NSWorkspace sharedWorkspace] selectFile:[self currentFilename] inFileViewerRootedAtPath:[[self currentFilename] stringByDeletingLastPathComponent]]; 
}

@end
