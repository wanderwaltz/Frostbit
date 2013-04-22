//
//  FRBAttributedStringTest.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

#import "FRBAttributedStringBuilder.h"

#pragma mark -
#pragma mark FRBAttributedStringTest interface

/*! Each test case clears the registered styles
    for FRBAttributedStringBuilder prior to execution
 */
@interface FRBAttributedStringTest : SenTestCase

- (void) assertString: (NSAttributedString *) string 
             fontSize: (CGFloat) fontSize 
              atIndex: (NSInteger) index;

- (void) assertString: (NSAttributedString *) string 
             fontName: (NSString *) fontName
              atIndex: (NSInteger) index;

- (void) assertString: (NSAttributedString *) string 
            fontColor: (UIColor *) fontColor
              atIndex: (NSInteger) index;

- (void) assertString: (NSAttributedString *) string 
       underlineColor: (UIColor *) underlineColor
              atIndex: (NSInteger) index;

- (void) assertString: (NSAttributedString *) string 
       underlineStyle: (CTUnderlineStyle) underlineStyle
              atIndex: (NSInteger) index;


- (void) assertExceptionForString: (NSString *) string;

@end
