//
//  FRBAttributedStringTest.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBAttributedStringTest.h"

#pragma mark -
#pragma mark FRBAttributedStringTest implementation

@implementation FRBAttributedStringTest

#pragma mark -
#pragma mark methods

- (void) assertString: (NSAttributedString *) string 
             fontSize: (CGFloat) fontSize 
              atIndex: (NSInteger) index
{
    NSDictionary *attributes = [string attributesAtIndex: index 
                                          effectiveRange: NULL];
    
    XCTAssertNotNil(attributes, @"");
    
    CTFontRef font = (__bridge CTFontRef)[attributes objectForKey: 
                                          (__bridge id)kCTFontAttributeName];
    
    XCTAssertTrue(font != NULL, @"");
    
    CGFloat size = CTFontGetSize(font);
    
    XCTAssertEqualWithAccuracy(size, fontSize, 0.5, @"");
}


- (void) assertString: (NSAttributedString *) string 
             fontName: (NSString *) fontName
              atIndex: (NSInteger) index
{
    NSDictionary *attributes = [string attributesAtIndex: index 
                                          effectiveRange: NULL];
    
    XCTAssertNotNil(attributes, @"");
    
    CTFontRef font = (__bridge CTFontRef)[attributes objectForKey: 
                                          (__bridge id)kCTFontAttributeName];
    
    XCTAssertTrue(font != NULL, @"");
    
    NSString *name = (__bridge_transfer NSString *)CTFontCopyName(font, kCTFontFullNameKey);
    
    XCTAssertEqualObjects(name, fontName, @"");
}


- (void) assertString: (NSAttributedString *) string 
            fontColor: (UIColor *) fontColor
              atIndex: (NSInteger) index
{
    NSDictionary *attributes = [string attributesAtIndex: index 
                                          effectiveRange: NULL];
    
    XCTAssertNotNil(attributes, @"");
    
    CGColorRef color = (__bridge CGColorRef)[attributes objectForKey: 
                                          (__bridge id)kCTForegroundColorAttributeName];
    
    XCTAssertTrue(color != NULL, @"");
    
    UIColor *uiColor = [UIColor colorWithCGColor: color];
    
    XCTAssertEqualObjects(uiColor, fontColor, @"");
}


- (void) assertString: (NSAttributedString *) string 
       underlineColor: (UIColor *) underlineColor
              atIndex: (NSInteger) index
{
    NSDictionary *attributes = [string attributesAtIndex: index 
                                          effectiveRange: NULL];
    
    XCTAssertNotNil(attributes, @"");
    
    CGColorRef color = (__bridge CGColorRef)[attributes objectForKey: 
                                             (__bridge id)kCTUnderlineColorAttributeName];
    
    XCTAssertTrue(color != NULL, @"");
    
    UIColor *uiColor = [UIColor colorWithCGColor: color];
    
    XCTAssertEqualObjects(uiColor, underlineColor, @"");
}


- (void) assertString: (NSAttributedString *) string 
       underlineStyle: (CTUnderlineStyle) underlineStyle
              atIndex: (NSInteger) index
{
    NSDictionary *attributes = [string attributesAtIndex: index 
                                          effectiveRange: NULL];
    
    XCTAssertNotNil(attributes, @"");
    
    CTUnderlineStyle style = [[attributes objectForKey: 
                               (__bridge id)kCTUnderlineStyleAttributeName] intValue];
    
    XCTAssertEqual(style, underlineStyle, @"");
}


- (void) assertExceptionForString: (NSString *) string
{
    
    id attributed = nil;
    
    XCTAssertThrows(attributed = [_stringBuilder stringWithString: string], @"");
}


#pragma mark -
#pragma mark GHTestCase

- (void) setUp
{
    [super setUp];
    _stringBuilder = [FRBAttributedStringBuilder new];
}


- (void) tearDown
{
    _stringBuilder = nil;
    [super tearDown];
}

@end
