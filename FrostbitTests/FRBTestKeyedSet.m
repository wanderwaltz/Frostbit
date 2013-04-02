//
//  FRBTestKeyedSet.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.04.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestKeyedSet.h"


#pragma mark -
#pragma mark FRBTestKeyedSet implementation

@implementation FRBTestKeyedSet

- (void) testDesignatedInitializer
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertEquals(set.count, 0u, @"");
    STAssertEquals([set countForKey: @"some key"], 0u, @"");
    
    STAssertEquals(set.arrayOfAllObjects.count, 0u, @"");
    STAssertEquals(set.setOfAllObjects.count, 0u,   @"");
    
    STAssertNil([set arrayOfObjectsForKey: @"other key"], @"");
    STAssertNil([set setOfObjectsForKey: @"another key"], @"");
    STAssertNil([set anyObjectForKey:         @"object"], @"");
}


- (void) testAddObject
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    STAssertEquals(set.count, 1u, @"");
    
    [set addObject: @2 forKey: @"key"];
    STAssertEquals(set.count, 2u, @"");
    
    [set addObject: @3 forKey: @"other key"];
    STAssertEquals(set.count, 3u, @"");
    
    NSArray *array = set.arrayOfAllObjects;
    STAssertNotNil(array, @"");
    STAssertEquals(array.count, 3u, @"");
    
    STAssertTrueNoThrow([array containsObject: @1], @"");
    STAssertTrueNoThrow([array containsObject: @2], @"");
    STAssertTrueNoThrow([array containsObject: @3], @"");
    
    NSSet *all = set.setOfAllObjects;
    STAssertNotNil(all, @"");
    STAssertEquals(all.count, 3u, @"");
    
    STAssertTrueNoThrow([all containsObject: @1], @"");
    STAssertTrueNoThrow([all containsObject: @2], @"");
    STAssertTrueNoThrow([all containsObject: @3], @"");
}


- (void) testCounts
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other key"];
    
    STAssertEquals(set.count, 3u, @"");
    STAssertEquals([set countForKey: @"key"], 2u, @"");
    STAssertEquals([set countForKey: @"other key"], 1u, @"");
    STAssertEquals([set countForKey: @"unexistent key"], 0u, @"");
}


- (void) testSubsetsSubarrays
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    NSString *key      = @"key";
    NSString *otherKey = @"other key";
    
    [set addObject: @1 forKey: key];
    [set addObject: @2 forKey: key];
    [set addObject: @2 forKey: key];
    [set addObject: @2 forKey: key];
    
    [set addObject: @3 forKey: otherKey];
    [set addObject: @4 forKey: otherKey];
    [set addObject: @5 forKey: otherKey];
    
    NSArray *arrayForKey = [set arrayOfObjectsForKey: key];
    STAssertTrueNoThrow([arrayForKey containsObject: @1], @"");
    STAssertTrueNoThrow([arrayForKey containsObject: @2], @"");
    STAssertTrueNoThrow(![arrayForKey containsObject: @3], @"");
    STAssertTrueNoThrow(![arrayForKey containsObject: @4], @"");
    STAssertTrueNoThrow(![arrayForKey containsObject: @5], @"");
    
    STAssertEquals(arrayForKey.count, 2u, @"");
    
    NSSet *setForKey = [set setOfObjectsForKey: key];
    STAssertTrueNoThrow([setForKey containsObject: @1], @"");
    STAssertTrueNoThrow([setForKey containsObject: @2], @"");
    STAssertTrueNoThrow(![setForKey containsObject: @3], @"");
    STAssertTrueNoThrow(![setForKey containsObject: @4], @"");
    STAssertTrueNoThrow(![setForKey containsObject: @5], @"");
    
    STAssertEquals(setForKey.count, 2u, @"");
    
    
    NSArray *arrayForOtherKey = [set arrayOfObjectsForKey: otherKey];
    STAssertTrueNoThrow(![arrayForOtherKey containsObject: @1], @"");
    STAssertTrueNoThrow(![arrayForOtherKey containsObject: @2], @"");
    STAssertTrueNoThrow([arrayForOtherKey containsObject: @3], @"");
    STAssertTrueNoThrow([arrayForOtherKey containsObject: @4], @"");
    STAssertTrueNoThrow([arrayForOtherKey containsObject: @5], @"");
    
    STAssertEquals(arrayForOtherKey.count, 3u, @"");
    
    NSSet *setForOtherKey = [set setOfObjectsForKey: otherKey];
    STAssertTrueNoThrow(![setForOtherKey containsObject: @1], @"");
    STAssertTrueNoThrow(![setForOtherKey containsObject: @2], @"");
    STAssertTrueNoThrow([setForOtherKey containsObject: @3], @"");
    STAssertTrueNoThrow([setForOtherKey containsObject: @4], @"");
    STAssertTrueNoThrow([setForOtherKey containsObject: @5], @"");
    
    STAssertEquals(setForOtherKey.count, 3u, @"");
}


- (void) testNonStringKeys
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @2];
    STAssertEquals(set.count, 1u, @"");
    STAssertEqualObjects([set arrayOfObjectsForKey: @2][0], @1, @"");
}


- (void) testAny
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    NSString *key = @"key";
    
    [set addObject: @1 forKey: key];
    [set addObject: @2 forKey: key];
 
    STAssertTrueNoThrow([[set anyObjectForKey: key] isEqual: @1] ||
                        [[set anyObjectForKey: key] isEqual: @2], @"");
}


- (void) testRemoveAll
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeAllObjects];
    STAssertEquals(set.count, 0u, @"");
    STAssertEquals([set countForKey:   @"key"], 0u, @"");
    STAssertEquals([set countForKey: @"other"], 0u, @"");
}


- (void) testRemoveObjectFromSingleKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeObject: @1];
    
    STAssertEquals(set.count, 2u, @"");
    STAssertEquals([set countForKey:   @"key"], 1u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");
    
    STAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    STAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
}


- (void) testRemoveObjectFromMultiKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    [set addObject: @1 forKey: @"other"];
    
    [set removeObject: @1];
    
    STAssertEquals(set.count, 2u, @"");
    STAssertEquals([set countForKey:   @"key"], 1u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");
    
    STAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    STAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
}


- (void) testRemoveObjectForKeyFromSingleKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeObject: @1 forKey: @"key"];
    
    STAssertEquals(set.count, 2u, @"");
    STAssertEquals([set countForKey:   @"key"], 1u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");
    
    STAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    STAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
}


- (void) testRemoveObjectForKeyFromMultiKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    [set addObject: @1 forKey: @"other"];
    
    [set removeObject: @1 forKey: @"key"];
    
    STAssertEquals(set.count, 3u, @"");
    STAssertEquals([set countForKey:   @"key"], 1u, @"");
    STAssertEquals([set countForKey: @"other"], 2u, @"");
    
    STAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    STAssertTrue( [[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
}


- (void) testRemoveAllForKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeAllObjectsForKey: @"key"];
    
    STAssertEquals(set.count, 1u, @"");
    STAssertEquals([set countForKey:   @"key"], 0u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");
    
    STAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    STAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
    
    STAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @2], @"");
    STAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @2], @"");
}


- (void) testRemoveObjectsFromArray
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeObjectsFromArray: @[@1, @2, @3]];
    
    STAssertEquals(set.count, 0u, @"");
    STAssertEquals([set countForKey:   @"key"], 0u, @"");
    STAssertEquals([set countForKey: @"other"], 0u, @"");    
}


- (void) testRemoveObjectsFromSet
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeObjectsFromSet: [NSSet setWithArray: @[@1, @2, @3]]];
    
    STAssertEquals(set.count, 0u, @"");
    STAssertEquals([set countForKey:   @"key"], 0u, @"");
    STAssertEquals([set countForKey: @"other"], 0u, @"");
}


- (void) testContainsObject
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    STAssertTrue([set containsObject: @1], @"");
    STAssertTrue([set containsObject: @2], @"");
    STAssertTrue([set containsObject: @3], @"");
    
    STAssertFalse([set containsObject: @4], @"");
}


- (void) testContainsObjectForKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    STAssertTrue([set containsObject: @1 forKey:   @"key"], @"");
    STAssertTrue([set containsObject: @2 forKey:   @"key"], @"");
    STAssertTrue([set containsObject: @3 forKey: @"other"], @"");
    
    STAssertFalse([set containsObject: @1 forKey: @"other"], @"");
    STAssertFalse([set containsObject: @2 forKey: @"other"], @"");
    STAssertFalse([set containsObject: @3 forKey:   @"key"], @"");
}



- (void) testAddObjectsFromArray
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObjectsFromArray: @[@1, @2] forKey: @"key"];
    [set addObjectsFromArray: @[@3]     forKey: @"other"];
    
    STAssertEquals(set.count, 3u, @"");
    STAssertEquals([set countForKey:   @"key"], 2u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");

    STAssertTrue([set containsObject: @1], @"");
    STAssertTrue([set containsObject: @2], @"");
    STAssertTrue([set containsObject: @3], @"");
}


- (void) testAddObjectsFromSet
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObjectsFromSet: [NSSet setWithArray: @[@1, @2]] forKey: @"key"];
    [set addObjectsFromSet: [NSSet setWithArray: @[@3]]     forKey: @"other"];
    
    STAssertEquals(set.count, 3u, @"");
    STAssertEquals([set countForKey:   @"key"], 2u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");
    
    STAssertTrue([set containsObject: @1], @"");
    STAssertTrue([set containsObject: @2], @"");
    STAssertTrue([set containsObject: @3], @"");
}


- (void) testAddObjectsFromDictionary
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObjectsFromDictionary: @{
     @"key"   : @1,
     @"other" : @2
     }];
    
    
    STAssertEquals(set.count, 2u, @"");
    STAssertEquals([set countForKey:   @"key"], 1u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");
    
    STAssertTrue([set containsObject: @1], @"");
    STAssertTrue([set containsObject: @2], @"");
}


- (void) testEnumerate
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    NSMutableSet *allObjects = [set.setOfAllObjects mutableCopy];

    [set enumerateObjectsUsingBlock:
     ^(id object, FRBKeyedSetKey key, BOOL *stop){
         
         STAssertTrue(allObjects.count > 0, @"");
         [allObjects removeObject: object];
     }];
    
    STAssertEquals(allObjects.count, 0u, @"");
}


- (void) testEnumerateStop
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    __block BOOL stopped = NO;
    
    [set enumerateObjectsUsingBlock:
     ^(id object, FRBKeyedSetKey key, BOOL *stop){
         
         STAssertFalse(stopped, @"");
         stopped = YES;
         *stop   = YES;
     }];
}


- (void) testEnumerateForKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    NSMutableSet *allObjects = [set.setOfAllObjects mutableCopy];
    
    [set enumerateObjectsForKey: @"key"
                     usingBlock:
     ^(id object, FRBKeyedSetKey key, BOOL *stop){
         [allObjects removeObject: object];
     }];
    
    STAssertEquals(allObjects.count, 1u, @"");
    STAssertTrue([allObjects containsObject: @3], @"");
}


- (void) testEnumerateForKeyStop
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    __block BOOL stopped = NO;
    
    [set enumerateObjectsForKey: @"key"
                     usingBlock:
     ^(id object, FRBKeyedSetKey key, BOOL *stop){
         
         STAssertFalse(stopped, @"");
         stopped = YES;
         *stop   = YES;
     }];
}

@end
