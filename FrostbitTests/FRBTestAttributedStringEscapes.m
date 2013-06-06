//
//  FRBTestAttributedStringEscapes.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestAttributedStringEscapes.h"

#pragma mark -
#pragma mark FRBTestAttributedStringEscapes implementation

@implementation FRBTestAttributedStringEscapes

#pragma mark -
#pragma mark no errors

- (void) test_escapedBrackets
{
    NSAttributedString *attributed = [_stringBuilder stringWithString: @"\\[\\]"];
    STAssertEqualObjects(attributed.string, @"[]", @"");
}


- (void) test_slash
{
    NSAttributedString *attributed = [_stringBuilder stringWithString: @"\\"];
    STAssertEqualObjects(attributed.string, @"\\", @"");
}


- (void) test_multiSlash
{
    NSAttributedString *attributed = [_stringBuilder stringWithString: @"\\\\\\"];
    STAssertEqualObjects(attributed.string, @"\\\\\\", @"");
}


- (void) test_defaultEscapes
{
    NSAttributedString *attributed = [_stringBuilder stringWithString: @"\\n\\p\\t"];
    STAssertEqualObjects(attributed.string, @"\\n\\p\\t", @"");
}


- (void) test_slashesAndBrackets
{
    NSAttributedString *attributed = [_stringBuilder stringWithString: @"\\\\\\[\\]\\\\"];
    STAssertEqualObjects(attributed.string, @"\\\\[]\\\\", @"");
}


#pragma mark -
#pragma mark errors

- (void) test_error_escapeWithinStyle
{
    // We are trying to use a style with name 'style[0]'
    [self assertExceptionForString: @"[style\\[0\\]]string[/style\\[0\\]]"];
}

@end
