//
//  FRBDiffTestDictionaryNested.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 4/25/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBDiffTestDictionaryNested.h"


#pragma mark -
#pragma mark FRBDiffTestDictionaryNested implementation

@implementation FRBDiffTestDictionaryNested

- (void) testRemovedKeyPathsHasNestedPath
{
    id old = @{ @"nested" : @{ @"key" : @"value" } };
    id new = @{ @"nested" : @{} };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    XCTAssertTrue([diff.removedKeyPaths containsObject: @"nested.key"],
                 @"removedKeyPaths should contain all key paths for keys which were removed "
                 @"from the new revision");

}


- (void) testRemovedKeyPathsUpdateHasBasePath
{
    id old = @{ @"nested" : @{ @"key" : @"value" } };
    id new = @{ @"nested" : @{} };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    XCTAssertTrue([diff.updatedKeyPaths containsObject: @"nested"],
                 @"updatedKeyPaths should contain all updated key paths");
    
}


- (void) testAddedKeyPathsHasNestedPath
{
    id old = @{ @"nested" : @{} };
    id new = @{ @"nested" : @{ @"key" : @"value" } };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    XCTAssertTrue([diff.addedKeyPaths containsObject: @"nested.key"],
                 @"addedKeyPaths should contain all key paths for keys which were removed "
                 @"from the new revision");
    
}


- (void) testAddedKeyPathsUpdateHasBasePath
{
    id old = @{ @"nested" : @{} };
    id new = @{ @"nested" : @{ @"key" : @"value" } };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    XCTAssertTrue([diff.updatedKeyPaths containsObject: @"nested"],
                 @"updatedKeyPaths should contain all updated key paths");
    
}


- (void) testUpdatedKeyPathsHasNestedPath
{
    id old = @{ @"nested" : @{ @"key" : @"value" } };
    id new = @{ @"nested" : @{ @"key" : @"other value" } };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    XCTAssertTrue([diff.updatedKeyPaths containsObject: @"nested.key"],
                 @"updatedKeyPaths should contain all updated key paths");
    
}


- (void) testUpdatedKeyPathsUpdateHasBasePath
{
    id old = @{ @"nested" : @{ @"key" : @"value" } };
    id new = @{ @"nested" : @{ @"key" : @"other value" } };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    XCTAssertTrue([diff.updatedKeyPaths containsObject: @"nested"],
                 @"updatedKeyPaths should contain all updated key paths");
    
}

@end
