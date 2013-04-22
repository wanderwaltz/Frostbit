//
//  FRBTestAttributedStringInlineStylesApplication.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestAttributedStringInlineStylesApplication.h"

#pragma mark -
#pragma mark FRBTestAttributedStringInlineStylesApplication implementation

@implementation FRBTestAttributedStringInlineStylesApplication

- (void) test_fontSize
{
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: size=16]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontSize: 16 atIndex: i];   
    }
}


- (void) test_fontName
{
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: font=Zapfino]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontName: @"Zapfino" atIndex: i];   
    }
}


- (void) test_fontColor
{
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: color=FF0000]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontColor: [UIColor redColor] atIndex: i];   
    }
}


- (void) test_underlineColor
{
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: underlineColor=FF0000]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineColor: [UIColor redColor] atIndex: i];   
    }
}


- (void) test_underlineStyle
{
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: underline=single]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineStyle: kCTUnderlineStyleSingle atIndex: i];   
    }
    
    
    string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: underline=double]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineStyle: kCTUnderlineStyleDouble atIndex: i];   
    }

    
    string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: underline=thick]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineStyle: kCTUnderlineStyleThick atIndex: i];   
    }

    
    string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: underline=none]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineStyle: kCTUnderlineStyleNone atIndex: i];   
    }
}


- (void) test_fontNameSize
{
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: font=Marker Felt Wide, size = 36]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontSize: 36                  atIndex: i];   
        [self assertString: string fontName: @"Marker Felt Wide" atIndex: i];   
    }
}


- (void) test_reuse
{
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a: font=Zapfino]1[/a]2[a]3[/a]"];
    
    [self assertString: string fontName: @"Zapfino" atIndex: 0];   
    [self assertString: string fontName: @"Zapfino" atIndex: 2];   
}


- (void) test_redefine
{
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString:
     @"[#: size=1]A[/#]B[#: size=2]C[/#]"];
    
    [self assertString: string fontSize: 2 atIndex: 0];   
    [self assertString: string fontSize: 2 atIndex: 2];   
}

@end
