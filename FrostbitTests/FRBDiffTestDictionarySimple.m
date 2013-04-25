//
//  FRBDiffTestDictionarySimple.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 4/25/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBDiffTestDictionarySimple.h"


#pragma mark -
#pragma mark FRBDiffTestDictionarySimple implementation

@implementation FRBDiffTestDictionarySimple

- (void) testNoDifferences
{
    id old = @{ @"key" : @"value" };
    id new = @{ @"key" : @"value" };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    STAssertFalse(diff.hasDifferences,
                  @"-hasDifferences should return NO for different dictionaries "
                  @"with the same key/value pairs");
}


- (void) testHasDifferencesAddedKey
{
    id old = @{};
    id new = @{ @"key" : @"value" };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    STAssertTrue(diff.hasDifferences,
                  @"-hasDifferences should return YES if adding a new key/value pair");
}


- (void) testHasDifferencesRemovedKey
{
    id old = @{ @"key" : @"value" };
    id new = @{};
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    STAssertTrue(diff.hasDifferences,
                 @"-hasDifferences should return YES if removing a key/value pair");
}


- (void) testHasDifferencesChangedValue
{
    id old = @{ @"key" : @"value" };
    id new = @{ @"key" : @"other value"};
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    STAssertTrue(diff.hasDifferences,
                 @"-hasDifferences should return YES if changing a value for key");
}


- (void) testRemovedKeys
{
    id old = @{ @"key" : @"value" };
    id new = @{};
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    STAssertTrue([diff.removedKeys containsObject: @"key"],
                 @"removedKeys should contain all keys which were removed "
                 @"from the new revision");
}


- (void) testAddedKeys
{
    id old = @{};
    id new = @{ @"key" : @"value" };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    STAssertTrue([diff.addedKeys containsObject: @"key"],
                 @"addedKeys should contain all keys which were added "
                 @"to the new revision");
}


- (void) testUpdatedKeys
{
    id old = @{ @"key" : @"value"};
    id new = @{ @"key" : @"other value" };
    
    FRBDiff *diff = [[FRBDiff alloc] initWithOldRevision: old newRevision: new];
    
    STAssertTrue([diff.updatedKeys containsObject: @"key"],
                 @"updatedKeys should contain all keys whose values were updated "
                 @"in the new revision");
}

@end
