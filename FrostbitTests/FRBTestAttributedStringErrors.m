//
//  FRBTestAttributedStringErrors.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestAttributedStringErrors.h"

#pragma mark -
#pragma mark FRBTestAttributedStringErrors implementation

@implementation FRBTestAttributedStringErrors

- (void) test_emptyStyle
{
    [self assertExceptionForString: @"[][/]"];
}


- (void) test_notClosedStyle
{
    [self assertExceptionForString: @"[style]string"];
}


- (void) test_wrongClosingStyle
{
    [self assertExceptionForString: @"[style]string[/font]"];
}


- (void) test_wrongIntersectingStyles
{
    [self assertExceptionForString: @"[a]st[b]ring[/a][/b]"];
}


- (void) test_notClosedStartStyleName
{
    [self assertExceptionForString: @"[style"];
}


- (void) test_notClosedEndStyleName
{
    [self assertExceptionForString: @"[style]string[/style"];
}


- (void) test_closingNotOpenStyle
{
    [self assertExceptionForString: @"string[/style]"];
}


- (void) test_closingBrackets
{
    [self assertExceptionForString: @"strin]g"];
}


- (void) test_bracketsInsideStyleName
{
    [self assertExceptionForString: @"[a[]b]string[/a[]b]"];
}

@end
