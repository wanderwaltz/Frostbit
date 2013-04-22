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
    id string = [FRBAttributedStringBuilder stringWithString: @"string"];
    STAssertNotNil(string, @"");
}


- (void) test_isKindOfClass
{
    id string = [FRBAttributedStringBuilder stringWithString: @"string"];
    STAssertTrue([string isKindOfClass: [NSAttributedString class]], @"");
}


- (void) test_length_noStyle
{
    NSAttributedString *string = [FRBAttributedStringBuilder stringWithString: @"string"];
    STAssertEquals(string.length, 6u, @"");
}


- (void) test_length_style
{
    NSAttributedString *string = [FRBAttributedStringBuilder stringWithString: 
                                  @"[long style name]string[/long style name]"];
    STAssertEquals(string.length, 6u, @"");
}


- (void) test_styleNames
{
    STAssertNoThrow({
        // A style named 'style'
        [FRBAttributedStringBuilder stringWithString: @"[style]string[/style]"];
        
        // A style named 'style/substyle'
        [FRBAttributedStringBuilder stringWithString: @"[style/substyle]string[/style/substyle]"];
        
        // A style named 'style#other'
        [FRBAttributedStringBuilder stringWithString: @"[style#other]string[/style#other]"];
        
        // A style named '1'
        [FRBAttributedStringBuilder stringWithString: @"[1]string[/1]"];
        
        // A style named '!#$%%^^&'
        [FRBAttributedStringBuilder stringWithString: @"[!#$%%^^&]string[/!#$%%^^&]"];
    }, @"");
}


#pragma mark -
#pragma mark simple style tests

- (void) test_fontSize
{
    [FRBAttributedStringBuilder setFontName: @"Helvetica" 
                                       size: 36 
                               forStyleName: @"a"];
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontSize: 36 atIndex: i];   
    }
}


- (void) test_fontName
{
    [FRBAttributedStringBuilder setFontName: @"Zapfino" 
                                       size: 36 
                               forStyleName: @"a"];
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontName: @"Zapfino" atIndex: i];   
    }
}


- (void) test_fontNameSize
{
    [FRBAttributedStringBuilder setFontName: @"Marker Felt Wide" 
                                       size: 36 
                               forStyleName: @"a"];
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontSize: 36                  atIndex: i];   
        [self assertString: string fontName: @"Marker Felt Wide" atIndex: i];   
    }
}


- (void) test_fontColor
{
    [FRBAttributedStringBuilder setFontColor: [UIColor redColor]
                                forStyleName: @"a"];
 
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string fontColor: [UIColor redColor] atIndex: i];   
    }
}


- (void) test_underlineColor
{
    [FRBAttributedStringBuilder setUnderlineColor: [UIColor redColor]
                                     forStyleName: @"a"];
    
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a]string[/a]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineColor: [UIColor redColor] atIndex: i];   
    }
}


- (void) test_underlineStyle
{
    [FRBAttributedStringBuilder setUnderlineStyle: kCTUnderlineStyleSingle
                                     forStyleName: @"single"];
    
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[single]string[/single]"];
    
    for (NSInteger i = 0; i < string.length; ++i)
    {
        [self assertString: string underlineStyle: kCTUnderlineStyleSingle atIndex: i];   
    }
}


#pragma mark -
#pragma mark multiple styles per string

- (void) test_twoStyles_noIntersect
{
    [FRBAttributedStringBuilder setFontName: @"Helvetica" 
                                       size: 36 
                               forStyleName: @"a"];
    
    [FRBAttributedStringBuilder setFontName: @"Zapfino" 
                               size: 12 
                       forStyleName: @"b"];
    
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a]string[/a] with multiple [b]styles[/b]"];
    
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
    [FRBAttributedStringBuilder setFontName: @"Helvetica" 
                                       size: 36 
                               forStyleName: @"a"];
    
    [FRBAttributedStringBuilder setFontName: @"Zapfino" 
                                       size: 12 
                               forStyleName: @"b"];
    
    NSAttributedString *string = 
    [FRBAttributedStringBuilder stringWithString: @"[a]1[b]2[/b]3[/a]"];
    
    [self assertString: string fontSize: 36           atIndex: 0];   
    [self assertString: string fontName: @"Helvetica" atIndex: 0];   
    
    [self assertString: string fontSize: 12           atIndex: 1];   
    [self assertString: string fontName: @"Zapfino"   atIndex: 1];   
    
    [self assertString: string fontSize: 36           atIndex: 2];   
    [self assertString: string fontName: @"Helvetica" atIndex: 2];   
}


@end
