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


- (void) testInitWithKeyedSet
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    FRBKeyedSet *clone = [[FRBKeyedSet alloc] initWithKeyedSet: set];
    STAssertTrue([clone isKindOfClass: [FRBKeyedSet class]],
                 @"Got '%@' instead", NSStringFromClass([clone class]));
    
    STAssertEquals(clone.count, 3u, @"");
    STAssertEquals([clone countForKey:   @"key"], 2u, @"");
    STAssertEquals([clone countForKey: @"other"], 1u, @"");
    
    STAssertTrue([clone containsObject: @1 forKey:   @"key"], @"");
    STAssertTrue([clone containsObject: @2 forKey:   @"key"], @"");
    STAssertTrue([clone containsObject: @3 forKey: @"other"], @"");
}


- (void) testInitWithDictionary
{
    FRBKeyedSet *set = [[FRBKeyedSet alloc] initWithDictionary:
                        @{ @"key1" : @1, @"key2" : @2, @"key3" : @3 }];
    
    STAssertEquals(set.count, 3u, @"");
    STAssertEquals([set countForKey: @"key1"], 1u, @"");
    STAssertEquals([set countForKey: @"key2"], 1u, @"");
    STAssertEquals([set countForKey: @"key3"], 1u, @"");
    
    STAssertTrue([set containsObject: @1 forKey: @"key1"], @"");
    STAssertTrue([set containsObject: @2 forKey: @"key2"], @"");
    STAssertTrue([set containsObject: @3 forKey: @"key3"], @"");
}


- (void) testNSCopying
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    FRBKeyedSet *clone = [set copy];
    STAssertTrue([clone isKindOfClass: [FRBKeyedSet class]],
                 @"Got '%@' instead", NSStringFromClass([clone class]));
    
    STAssertEquals(clone.count, 3u, @"");
    STAssertEquals([clone countForKey:   @"key"], 2u, @"");
    STAssertEquals([clone countForKey: @"other"], 1u, @"");
    
    STAssertTrue([clone containsObject: @1 forKey:   @"key"], @"");
    STAssertTrue([clone containsObject: @2 forKey:   @"key"], @"");
    STAssertTrue([clone containsObject: @3 forKey: @"other"], @"");
}


- (void) testNSMutableCopying
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    FRBKeyedSet *clone = [set mutableCopy];
    STAssertTrue([clone isKindOfClass: [FRBKeyedSet class]],
                 @"Got '%@' instead", NSStringFromClass([clone class]));
    
    STAssertEquals(clone.count, 3u, @"");
    STAssertEquals([clone countForKey:   @"key"], 2u, @"");
    STAssertEquals([clone countForKey: @"other"], 1u, @"");
    
    STAssertTrue([clone containsObject: @1 forKey:   @"key"], @"");
    STAssertTrue([clone containsObject: @2 forKey:   @"key"], @"");
    STAssertTrue([clone containsObject: @3 forKey: @"other"], @"");
}


- (void) testNSCoding
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: set];
    
    FRBKeyedSet *decoded = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    STAssertTrue([decoded isKindOfClass: [FRBKeyedSet class]],
                 @"Got '%@' instead", NSStringFromClass([decoded class]));
    
    STAssertEquals(decoded.count, 3u, @"");
    STAssertEquals([decoded countForKey:   @"key"], 2u, @"");
    STAssertEquals([decoded countForKey: @"other"], 1u, @"");
    
    STAssertTrue([decoded containsObject: @1 forKey:   @"key"], @"");
    STAssertTrue([decoded containsObject: @2 forKey:   @"key"], @"");
    STAssertTrue([decoded containsObject: @3 forKey: @"other"], @"");
}


- (void) testUnionSelf
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set unionKeyedSet: set];
    
    STAssertEquals(set.count, 3u, @"");
    STAssertEquals([set countForKey:   @"key"], 2u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");
    
    STAssertTrue([set containsObject: @1 forKey:   @"key"], @"");
    STAssertTrue([set containsObject: @2 forKey:   @"key"], @"");
    STAssertTrue([set containsObject: @3 forKey: @"other"], @"");
}


- (void) testUnion
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    FRBKeyedSet *other = [FRBKeyedSet new];
    [other addObject: @1 forKey: @"key"];
    [other addObject: @4 forKey: @"key"];
    [other addObject: @5 forKey: @"someKey"];
    
    [set unionKeyedSet: other];
    
    STAssertEquals(set.count, 5u, @"");
    STAssertEquals([set countForKey:     @"key"], 3u, @"");
    STAssertEquals([set countForKey:   @"other"], 1u, @"");
    STAssertEquals([set countForKey: @"someKey"], 1u, @"");
    
    STAssertTrue([set containsObject: @1 forKey:     @"key"], @"");
    STAssertTrue([set containsObject: @2 forKey:     @"key"], @"");
    STAssertTrue([set containsObject: @4 forKey:     @"key"], @"");
    STAssertTrue([set containsObject: @3 forKey:   @"other"], @"");
    STAssertTrue([set containsObject: @5 forKey: @"someKey"], @"");
    
    
    STAssertEquals(other.count, 3u, @"");
    STAssertEquals([other countForKey:     @"key"], 2u, @"");
    STAssertEquals([other countForKey:   @"other"], 0u, @"");
    STAssertEquals([other countForKey: @"someKey"], 1u, @"");
}


- (void) testMinusSelf
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set minusKeyedSet: set];
    
    STAssertEquals(set.count, 0u, @"");
}


- (void) testMinus
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    
    [set addObject: @1 forKey: @"other"];
    [set addObject: @3 forKey: @"other"];
    
    FRBKeyedSet *other = [FRBKeyedSet new];
    [other addObject: @1 forKey: @"key"];
    [other addObject: @4 forKey: @"key"];
    [other addObject: @5 forKey: @"someKey"];
    
    [set minusKeyedSet: other];
    
    STAssertEquals(set.count, 3u, @"");
    STAssertEquals([set countForKey:     @"key"], 1u, @"");
    STAssertEquals([set countForKey:   @"other"], 2u, @"");
    STAssertEquals([set countForKey: @"someKey"], 0u, @"");
    
    STAssertFalse([set containsObject: @1 forKey: @"key"], @"");
    
    STAssertTrue([set containsObject: @2 forKey:   @"key"], @"");
    STAssertTrue([set containsObject: @1 forKey: @"other"], @"");
    STAssertTrue([set containsObject: @3 forKey: @"other"], @"");
    
    
    STAssertEquals(other.count, 3u, @"");
    STAssertEquals([other countForKey:     @"key"], 2u, @"");
    STAssertEquals([other countForKey:   @"other"], 0u, @"");
    STAssertEquals([other countForKey: @"someKey"], 1u, @"");
}


- (void) testIntersectSelf
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set intersectKeyedSet: set];
    
    STAssertEquals(set.count, 3u, @"");
    STAssertEquals([set countForKey:   @"key"], 2u, @"");
    STAssertEquals([set countForKey: @"other"], 1u, @"");
    
    STAssertTrue([set containsObject: @1 forKey:   @"key"], @"");
    STAssertTrue([set containsObject: @2 forKey:   @"key"], @"");
    STAssertTrue([set containsObject: @3 forKey: @"other"], @"");
}


- (void) testIntersect
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    
    [set addObject: @1 forKey: @"other"];
    [set addObject: @3 forKey: @"other"];
    
    
    FRBKeyedSet *other = [FRBKeyedSet new];
    [other addObject: @1 forKey: @"key"];
    [other addObject: @4 forKey: @"key"];
    [other addObject: @5 forKey: @"someKey"];
    
    [set intersectKeyedSet: other];
    
    STAssertEquals(set.count, 1u, @"");
    STAssertEquals([set countForKey:     @"key"], 1u, @"");
    
    STAssertTrue([set containsObject: @1 forKey: @"key"], @"");
    
    STAssertEquals(other.count, 3u, @"");
    STAssertEquals([other countForKey:     @"key"], 2u, @"");
    STAssertEquals([other countForKey:   @"other"], 0u, @"");
    STAssertEquals([other countForKey: @"someKey"], 1u, @"");
}


- (void) testAddObjectForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set addObject: nil forKey:  @1], @"");
    STAssertThrows([set addObject: @1  forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set addObject: nil forKey:  @1], @"");
    STAssertNoThrow([set addObject: @1  forKey: nil], @"");
}


- (void) testAddObjectsFromArrayForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set addObjectsFromArray: nil forKey:  @1], @"");
    STAssertThrows([set addObjectsFromArray: @[] forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set addObjectsFromArray: nil forKey:  @1], @"");
    STAssertNoThrow([set addObjectsFromArray: @[] forKey: nil], @"");
}


- (void) testAddObjectsFromSetForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set addObjectsFromArray: nil         forKey:  @1], @"");
    STAssertThrows([set addObjectsFromArray: [NSSet set] forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set addObjectsFromSet: nil         forKey:  @1], @"");
    STAssertNoThrow([set addObjectsFromSet: [NSSet set] forKey: nil], @"");
}


- (void) testAddObjectsFromDictionaryException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set addObjectsFromDictionary: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set addObjectsFromDictionary: nil], @"");
}


- (void) testCountForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set countForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set countForKey: nil],     @"");
    STAssertEquals ([set countForKey: nil], 0u, @"");
}


- (void) testContainsObjectForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set containsObject: nil forKey:  @1], @"");
    STAssertThrows([set containsObject:  @1 forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set containsObject: nil forKey:  @1], @"");
    STAssertNoThrow([set containsObject:  @1 forKey: nil], @"");
    
    STAssertEquals ([set containsObject: nil forKey: nil], NO, @"");
    STAssertEquals ([set containsObject:  @1 forKey:  @1], NO, @"");
}


- (void) testContainsObjectException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set containsObject: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set containsObject: nil],     @"");
    STAssertEquals ([set containsObject: nil], NO, @"");
}


- (void) testArrayOfObjectsForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set arrayOfObjectsForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set arrayOfObjectsForKey: nil], @"");
    STAssertNil    ([set arrayOfObjectsForKey: nil], @"");
}


- (void) testSetOfObjectsForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set setOfObjectsForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set setOfObjectsForKey: nil], @"");
    STAssertNil    ([set setOfObjectsForKey: nil], @"");
}


- (void) testAnyObjectForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set anyObjectForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set anyObjectForKey: nil], @"");
    STAssertNil    ([set anyObjectForKey: nil], @"");
}


- (void) testRemoveAllObjectsForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set removeAllObjectsForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set removeAllObjectsForKey: nil], @"");
}


- (void) testRemoveObjectException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set removeObject: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set removeObject: nil], @"");
}


- (void) testRemoveObjectForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set removeObject: nil forKey:  @1], @"");
    STAssertThrows([set removeObject:  @1 forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set removeObject: nil forKey:  @1], @"");
    STAssertNoThrow([set removeObject:  @1 forKey: nil], @"");
}


- (void) testRemoveObjectsFromArrayException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set removeObjectsFromArray: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set removeObjectsFromArray: nil], @"");
}


- (void) testRemoveObjectsFromSetException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set removeObjectsFromSet: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set removeObjectsFromSet: nil], @"");
}


- (void) testEnumerateObjectsUsingBlockException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set enumerateObjectsUsingBlock: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set enumerateObjectsUsingBlock: nil], @"");
}


- (void) testEnumerateObjectsForKeyUsingBlockException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set enumerateObjectsForKey: nil usingBlock:
                    ^(id object, FRBKeyedSetKey key, BOOL *stop){}], @"");
    
    STAssertThrows([set enumerateObjectsForKey:  @1 usingBlock: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set enumerateObjectsForKey: nil usingBlock:
                    ^(id object, FRBKeyedSetKey key, BOOL *stop){}], @"");
    
    STAssertNoThrow([set enumerateObjectsForKey:  @1 usingBlock: nil], @"");
}


- (void) testUnionKeyedSetException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set unionKeyedSet: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set unionKeyedSet: nil], @"");
}


- (void) testMinusKeyedSetException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set minusKeyedSet: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set minusKeyedSet: nil], @"");
}


- (void) testIntersectKeyedSetException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    STAssertThrows([set intersectKeyedSet: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    STAssertNoThrow([set intersectKeyedSet: nil], @"");
}

@end
