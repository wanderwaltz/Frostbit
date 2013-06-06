//
//  FRBTestAttributedStringEscapes.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "FRBAttributedStringTest.h"

#pragma mark -
#pragma mark FRBTestAttributedStringEscapes interface

/*! This test suite verifies that the escape sequences specific to the
   for FRBAttributedStringBuilder are processed correctly.
 
   Allowed escape sequences are \[ and \]
 
   The escaped brackets are not allowed within the style definition.
 */
@interface FRBTestAttributedStringEscapes : FRBAttributedStringTest
@end
