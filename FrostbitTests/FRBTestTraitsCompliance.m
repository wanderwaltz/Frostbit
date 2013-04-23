//
//  FRBTestTraitsCompliance.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 4/23/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestTraitsCompliance.h"


#pragma mark -
#pragma mark FRBTestTraitsCompliance implementation

@implementation FRBTestTraitsCompliance

- (void) testDictionaryCompliance
{
    STAssertTrue([NSDictionary conformsToProtocol: @protocol(FRBDictionaryTraits)],
                 @"NSDictionary class should conform to FRBDictionaryTraits");
}


- (void) testMutableDictionaryCompliance
{
    STAssertTrue([NSMutableDictionary conformsToProtocol: @protocol(FRBDictionaryTraits)],
                 @"NSMutableDictionary class should conform to FRBDictionaryTraits");
}

@end
