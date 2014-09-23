//
//  FRBDiffTestTrivial.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 4/23/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "FRBDiffTestTrivial.h"


#pragma mark -
#pragma mark FRBDiffTestTrivial implementation

@implementation FRBDiffTestTrivial

- (void) testEmptyDictionary
{
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: @{} newRevision: @{}];
    
    XCTAssertFalse(diff.hasDifferences,
                  @"hasDifferences should return NO for two empty dictionaries");
}


- (void) testSameNonemptyDictionary
{
    id dictionary = @{ @"key" : @"value",
                       @12345 : @6789012 };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: dictionary
                                             newRevision: dictionary];
    XCTAssertFalse(diff.hasDifferences,
                  @"hasDifferences should return NO for two identical pointers "
                  @"regardless of their content");
}

@end
