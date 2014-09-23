//
//  FRBTestAttributedStringRegisteredStylesApplication.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglitnsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestAttributedStringRegisteredStylesApplication.h"

#pragma mark -
#pragma mark FRBTestAttributedStringRegisteredStylesApplication implementation

@implementation FRBTestAttributedStringRegisteredStylesApplication

#pragma mark -
#pragma mark the very basic tests

- (void) test_notNil
{
    id string = [_stringBuilder stringWithString: @"string"];
    XCTAssertNotNil(string, @"");
}


- (void) test_isKindOfClass
{
    id string = [_stringBuilder stringWithString: @"string"];
    XCTAssertTrue([string isKindOfClass: [NSAttributedString class]], @"");
}


- (void) test_length_noStyle
{
    NSAttributedString *string = [_stringBuilder stringWithString: @"string"];
    XCTAssertEqual(string.length, 6u, @"");
}


- (void) test_length_style
{
    NSAttributedString *string = [_stringBuilder stringWithString: 
                                  @"[long style name]string[/long style name]"];
    XCTAssertEqual(string.length, 6u, @"");
}


- (void) test_styleNames
{
    XCTAssertNoThrow({
        // A style named 'style'
        [_stringBuilder stringWithString: @"[style]string[/style]"];
        
        // A style named 'style/substyle'
        [_stringBuilder stringWithString: @"[style/substyle]string[/style/substyle]"];
        
        // A style named 'style#other'
        [_stringBuilder stringWithString: @"[style#other]string[/style#other]"];
        
        // A style named '1'
        [_stringBuilder stringWithString: @"[1]string[/1]"];
        
        // A style named '!#$%%^^&'
        [_stringBuilder stringWithString: @"[!#$%%^^&]string[/!#$%%^^&]"];
    }, @"");
}


#pragma mark -
#pragma mark simple style tests

- (void) test_fontSize
{
    [_stringBuilder setFontName: @"Helvetica" 
                           size: 36
                   forStyleName: @"a"];
    NSAttributedString *string = 
    [_stringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontSize: 36 atIndex: i];   
    }
}


- (void) test_fontName
{
    [_stringBuilder setFontName: @"Zapfino" 
                           size: 36
                   forStyleName: @"a"];
    NSAttributedString *string = 
    [_stringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontName: @"Zapfino" atIndex: i];   
    }
}


- (void) test_fontNameSize
{
    [_stringBuilder setFontName: @"Marker Felt Wide" 
                           size: 36
                   forStyleName: @"a"];
    NSAttributedString *string = 
    [_stringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontSize: 36                  atIndex: i];   
        [self assertString: string fontName: @"Marker Felt Wide" atIndex: i];   
    }
}


- (void) test_fontColor
{
    [_stringBuilder setFontColor: [UIColor redColor]
                    forStyleName: @"a"];
 
    NSAttributedString *string = 
    [_stringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontColor: [UIColor redColor] atIndex: i];   
    }
}


- (void) test_underlineColor
{
    [_stringBuilder setUnderlineColor: [UIColor redColor]
                         forStyleName: @"a"];
    
    NSAttributedString *string = 
    [_stringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineColor: [UIColor redColor] atIndex: i];   
    }
}


- (void) test_underlineStyle
{
    [_stringBuilder setUnderlineStyle: kCTUnderlineStyleSingle
                         forStyleName: @"single"];
    
    NSAttributedString *string = 
    [_stringBuilder stringWithString: @"[single]string[/single]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineStyle: kCTUnderlineStyleSingle atIndex: i];   
    }
}


#pragma mark -
#pragma mark multiple styles per string

- (void) test_twoStyles_noIntersect
{
    [_stringBuilder setFontName: @"Helvetica" 
                           size: 36
                   forStyleName: @"a"];
    
    [_stringBuilder setFontName: @"Zapfino" 
                           size: 12
                   forStyleName: @"b"];
    
    NSAttributedString *string = 
    [_stringBuilder stringWithString: @"[a]string[/a] with multiple [b]styles[/b]"];
    
    for (NSInteger i = 0; i < 6; ++i)
    {
        [self assertString: string fontSize: 36           atIndex: i];   
        [self assertString: string fontName: @"Helvetica" atIndex: i];   
    }
    
    
    for (NSInteger i = 21; i < 27; ++i)
    {
        [self assertString: string fontSize: 12         atIndex: i];   
        [self assertString: string fontName: @"Zapfino" atIndex: i];   
    }
}


- (void) test_twoStyles_contain
{
    [_stringBuilder setFontName: @"Helvetica" 
                           size: 36
                   forStyleName: @"a"];
    
    [_stringBuilder setFontName: @"Zapfino" 
                           size: 12
                   forStyleName: @"b"];
    
    NSAttributedString *string = 
    [_stringBuilder stringWithString: @"[a]1[b]2[/b]3[/a]"];
    
    [self assertString: string fontSize: 36           atIndex: 0];   
    [self assertString: string fontName: @"Helvetica" atIndex: 0];   
    
    [self assertString: string fontSize: 12           atIndex: 1];   
    [self assertString: string fontName: @"Zapfino"   atIndex: 1];   
    
    [self assertString: string fontSize: 36           atIndex: 2];   
    [self assertString: string fontName: @"Helvetica" atIndex: 2];   
}


@end
