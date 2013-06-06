//
//  FRBTestMultipleBuilders.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 6/6/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestMultipleBuilders.h"


#pragma mark -
#pragma mark FRBTestMultipleBuilders implementation

@implementation FRBTestMultipleBuilders

#pragma mark -
#pragma mark initialization methods

- (void) setUp
{
    [super setUp];
    _otherBuilder = [FRBAttributedStringBuilder new];
}


- (void) tearDown
{
    _otherBuilder = nil;
    [super tearDown];
}


#pragma mark -
#pragma mark tests

- (void) test_sameName_inline
{
    NSAttributedString *stringZapfino1 =
    [_stringBuilder stringWithString: @"[a: font=Zapfino]1[/a]"];
    
    NSAttributedString *stringArial =
    [_otherBuilder stringWithString: @"[a: font=Arial]1[/a]"];
    
    NSAttributedString *stringZapfino2 =
    [_stringBuilder stringWithString: @"[a: font=Zapfino]1[/a]"];
    
    
    [self assertString: stringZapfino1 fontName: @"Zapfino" atIndex: 0];
    [self assertString: stringZapfino2 fontName: @"Zapfino" atIndex: 0];
    [self assertString: stringArial    fontName: @"Arial"   atIndex: 0];
}


- (void) test_sameName_registered
{
    [_stringBuilder setFontName: @"Zapfino" size: 14.0 forStyleName: @"a"];
    [_otherBuilder  setFontName: @"Arial"   size: 14.0 forStyleName: @"a"];
    
    NSAttributedString *stringZapfino1 =
    [_stringBuilder stringWithString: @"[a]1[/a]"];
    
    NSAttributedString *stringArial =
    [_otherBuilder stringWithString: @"[a]1[/a]"];
    
    NSAttributedString *stringZapfino2 =
    [_stringBuilder stringWithString: @"[a]1[/a]"];
    
    
    [self assertString: stringZapfino1 fontName: @"Zapfino" atIndex: 0];
    [self assertString: stringZapfino2 fontName: @"Zapfino" atIndex: 0];
    [self assertString: stringArial    fontName: @"Arial"   atIndex: 0];
}



@end
