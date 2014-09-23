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
    
    XCTAssertEqual(set.count, 0u, @"");
    XCTAssertEqual([set countForKey: @"some key"], 0u, @"");
    
    XCTAssertEqual(set.arrayOfAllObjects.count, 0u, @"");
    XCTAssertEqual(set.setOfAllObjects.count, 0u,   @"");
    
    XCTAssertNil([set arrayOfObjectsForKey: @"other key"], @"");
    XCTAssertNil([set setOfObjectsForKey: @"another key"], @"");
    XCTAssertNil([set anyObjectForKey:         @"object"], @"");
}


- (void) testAddObject
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    XCTAssertEqual(set.count, 1u, @"");
    
    [set addObject: @2 forKey: @"key"];
    XCTAssertEqual(set.count, 2u, @"");
    
    [set addObject: @3 forKey: @"other key"];
    XCTAssertEqual(set.count, 3u, @"");
    
    NSArray *array = set.arrayOfAllObjects;
    XCTAssertNotNil(array, @"");
    XCTAssertEqual(array.count, 3u, @"");
    
    XCTAssertTrue([array containsObject: @1], @"");
    XCTAssertTrue([array containsObject: @2], @"");
    XCTAssertTrue([array containsObject: @3], @"");
    
    NSSet *all = set.setOfAllObjects;
    XCTAssertNotNil(all, @"");
    XCTAssertEqual(all.count, 3u, @"");
    
    XCTAssertTrue([all containsObject: @1], @"");
    XCTAssertTrue([all containsObject: @2], @"");
    XCTAssertTrue([all containsObject: @3], @"");
}


- (void) testCounts
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other key"];
    
    XCTAssertEqual(set.count, 3u, @"");
    XCTAssertEqual([set countForKey: @"key"], 2u, @"");
    XCTAssertEqual([set countForKey: @"other key"], 1u, @"");
    XCTAssertEqual([set countForKey: @"unexistent key"], 0u, @"");
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
    XCTAssertTrue([arrayForKey containsObject: @1], @"");
    XCTAssertTrue([arrayForKey containsObject: @2], @"");
    XCTAssertTrue(![arrayForKey containsObject: @3], @"");
    XCTAssertTrue(![arrayForKey containsObject: @4], @"");
    XCTAssertTrue(![arrayForKey containsObject: @5], @"");
    
    XCTAssertEqual(arrayForKey.count, 2u, @"");
    
    NSSet *setForKey = [set setOfObjectsForKey: key];
    XCTAssertTrue([setForKey containsObject: @1], @"");
    XCTAssertTrue([setForKey containsObject: @2], @"");
    XCTAssertTrue(![setForKey containsObject: @3], @"");
    XCTAssertTrue(![setForKey containsObject: @4], @"");
    XCTAssertTrue(![setForKey containsObject: @5], @"");
    
    XCTAssertEqual(setForKey.count, 2u, @"");
    
    
    NSArray *arrayForOtherKey = [set arrayOfObjectsForKey: otherKey];
    XCTAssertTrue(![arrayForOtherKey containsObject: @1], @"");
    XCTAssertTrue(![arrayForOtherKey containsObject: @2], @"");
    XCTAssertTrue([arrayForOtherKey containsObject: @3], @"");
    XCTAssertTrue([arrayForOtherKey containsObject: @4], @"");
    XCTAssertTrue([arrayForOtherKey containsObject: @5], @"");
    
    XCTAssertEqual(arrayForOtherKey.count, 3u, @"");
    
    NSSet *setForOtherKey = [set setOfObjectsForKey: otherKey];
    XCTAssertTrue(![setForOtherKey containsObject: @1], @"");
    XCTAssertTrue(![setForOtherKey containsObject: @2], @"");
    XCTAssertTrue([setForOtherKey containsObject: @3], @"");
    XCTAssertTrue([setForOtherKey containsObject: @4], @"");
    XCTAssertTrue([setForOtherKey containsObject: @5], @"");
    
    XCTAssertEqual(setForOtherKey.count, 3u, @"");
}


- (void) testNonStringKeys
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @2];
    XCTAssertEqual(set.count, 1u, @"");
    XCTAssertEqualObjects([set arrayOfObjectsForKey: @2][0], @1, @"");
}


- (void) testAny
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    NSString *key = @"key";
    
    [set addObject: @1 forKey: key];
    [set addObject: @2 forKey: key];
 
    XCTAssertTrue([[set anyObjectForKey: key] isEqual: @1] ||
                        [[set anyObjectForKey: key] isEqual: @2], @"");
}


- (void) testRemoveAll
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeAllObjects];
    XCTAssertEqual(set.count, 0u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 0u, @"");
    XCTAssertEqual([set countForKey: @"other"], 0u, @"");
}


- (void) testRemoveObjectFromSingleKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeObject: @1];
    
    XCTAssertEqual(set.count, 2u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 1u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");
    
    XCTAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    XCTAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
}


- (void) testRemoveObjectFromMultiKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    [set addObject: @1 forKey: @"other"];
    
    [set removeObject: @1];
    
    XCTAssertEqual(set.count, 2u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 1u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");
    
    XCTAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    XCTAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
}


- (void) testRemoveObjectForKeyFromSingleKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeObject: @1 forKey: @"key"];
    
    XCTAssertEqual(set.count, 2u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 1u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");
    
    XCTAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    XCTAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
}


- (void) testRemoveObjectForKeyFromMultiKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    [set addObject: @1 forKey: @"other"];
    
    [set removeObject: @1 forKey: @"key"];
    
    XCTAssertEqual(set.count, 3u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 1u, @"");
    XCTAssertEqual([set countForKey: @"other"], 2u, @"");
    
    XCTAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    XCTAssertTrue( [[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
}


- (void) testRemoveAllForKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeAllObjectsForKey: @"key"];
    
    XCTAssertEqual(set.count, 1u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 0u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");
    
    XCTAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @1], @"");
    XCTAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @1], @"");
    
    XCTAssertFalse([[set setOfObjectsForKey:   @"key"] containsObject: @2], @"");
    XCTAssertFalse([[set setOfObjectsForKey: @"other"] containsObject: @2], @"");
}


- (void) testRemoveObjectsFromArray
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeObjectsFromArray: @[@1, @2, @3]];
    
    XCTAssertEqual(set.count, 0u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 0u, @"");
    XCTAssertEqual([set countForKey: @"other"], 0u, @"");    
}


- (void) testRemoveObjectsFromSet
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set removeObjectsFromSet: [NSSet setWithArray: @[@1, @2, @3]]];
    
    XCTAssertEqual(set.count, 0u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 0u, @"");
    XCTAssertEqual([set countForKey: @"other"], 0u, @"");
}


- (void) testContainsObject
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    XCTAssertTrue([set containsObject: @1], @"");
    XCTAssertTrue([set containsObject: @2], @"");
    XCTAssertTrue([set containsObject: @3], @"");
    
    XCTAssertFalse([set containsObject: @4], @"");
}


- (void) testContainsObjectForKey
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    XCTAssertTrue([set containsObject: @1 forKey:   @"key"], @"");
    XCTAssertTrue([set containsObject: @2 forKey:   @"key"], @"");
    XCTAssertTrue([set containsObject: @3 forKey: @"other"], @"");
    
    XCTAssertFalse([set containsObject: @1 forKey: @"other"], @"");
    XCTAssertFalse([set containsObject: @2 forKey: @"other"], @"");
    XCTAssertFalse([set containsObject: @3 forKey:   @"key"], @"");
}



- (void) testAddObjectsFromArray
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObjectsFromArray: @[@1, @2] forKey: @"key"];
    [set addObjectsFromArray: @[@3]     forKey: @"other"];
    
    XCTAssertEqual(set.count, 3u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 2u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");

    XCTAssertTrue([set containsObject: @1], @"");
    XCTAssertTrue([set containsObject: @2], @"");
    XCTAssertTrue([set containsObject: @3], @"");
}


- (void) testAddObjectsFromSet
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObjectsFromSet: [NSSet setWithArray: @[@1, @2]] forKey: @"key"];
    [set addObjectsFromSet: [NSSet setWithArray: @[@3]]     forKey: @"other"];
    
    XCTAssertEqual(set.count, 3u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 2u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");
    
    XCTAssertTrue([set containsObject: @1], @"");
    XCTAssertTrue([set containsObject: @2], @"");
    XCTAssertTrue([set containsObject: @3], @"");
}


- (void) testAddObjectsFromDictionary
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObjectsFromDictionary: @{
     @"key"   : @1,
     @"other" : @2
     }];
    
    
    XCTAssertEqual(set.count, 2u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 1u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");
    
    XCTAssertTrue([set containsObject: @1], @"");
    XCTAssertTrue([set containsObject: @2], @"");
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
         
         XCTAssertTrue(allObjects.count > 0, @"");
         [allObjects removeObject: object];
     }];
    
    XCTAssertEqual(allObjects.count, 0u, @"");
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
         
         XCTAssertFalse(stopped, @"");
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
    
    XCTAssertEqual(allObjects.count, 1u, @"");
    XCTAssertTrue([allObjects containsObject: @3], @"");
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
         
         XCTAssertFalse(stopped, @"");
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
    XCTAssertTrue([clone isKindOfClass: [FRBKeyedSet class]],
                 @"Got '%@' instead", NSStringFromClass([clone class]));
    
    XCTAssertEqual(clone.count, 3u, @"");
    XCTAssertEqual([clone countForKey:   @"key"], 2u, @"");
    XCTAssertEqual([clone countForKey: @"other"], 1u, @"");
    
    XCTAssertTrue([clone containsObject: @1 forKey:   @"key"], @"");
    XCTAssertTrue([clone containsObject: @2 forKey:   @"key"], @"");
    XCTAssertTrue([clone containsObject: @3 forKey: @"other"], @"");
}


- (void) testInitWithDictionary
{
    FRBKeyedSet *set = [[FRBKeyedSet alloc] initWithDictionary:
                        @{ @"key1" : @1, @"key2" : @2, @"key3" : @3 }];
    
    XCTAssertEqual(set.count, 3u, @"");
    XCTAssertEqual([set countForKey: @"key1"], 1u, @"");
    XCTAssertEqual([set countForKey: @"key2"], 1u, @"");
    XCTAssertEqual([set countForKey: @"key3"], 1u, @"");
    
    XCTAssertTrue([set containsObject: @1 forKey: @"key1"], @"");
    XCTAssertTrue([set containsObject: @2 forKey: @"key2"], @"");
    XCTAssertTrue([set containsObject: @3 forKey: @"key3"], @"");
}


- (void) testNSCopying
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    FRBKeyedSet *clone = [set copy];
    XCTAssertTrue([clone isKindOfClass: [FRBKeyedSet class]],
                 @"Got '%@' instead", NSStringFromClass([clone class]));
    
    XCTAssertEqual(clone.count, 3u, @"");
    XCTAssertEqual([clone countForKey:   @"key"], 2u, @"");
    XCTAssertEqual([clone countForKey: @"other"], 1u, @"");
    
    XCTAssertTrue([clone containsObject: @1 forKey:   @"key"], @"");
    XCTAssertTrue([clone containsObject: @2 forKey:   @"key"], @"");
    XCTAssertTrue([clone containsObject: @3 forKey: @"other"], @"");
}


- (void) testNSMutableCopying
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    FRBKeyedSet *clone = [set mutableCopy];
    XCTAssertTrue([clone isKindOfClass: [FRBKeyedSet class]],
                 @"Got '%@' instead", NSStringFromClass([clone class]));
    
    XCTAssertEqual(clone.count, 3u, @"");
    XCTAssertEqual([clone countForKey:   @"key"], 2u, @"");
    XCTAssertEqual([clone countForKey: @"other"], 1u, @"");
    
    XCTAssertTrue([clone containsObject: @1 forKey:   @"key"], @"");
    XCTAssertTrue([clone containsObject: @2 forKey:   @"key"], @"");
    XCTAssertTrue([clone containsObject: @3 forKey: @"other"], @"");
}


- (void) testNSCoding
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: set];
    
    FRBKeyedSet *decoded = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    XCTAssertTrue([decoded isKindOfClass: [FRBKeyedSet class]],
                 @"Got '%@' instead", NSStringFromClass([decoded class]));
    
    XCTAssertEqual(decoded.count, 3u, @"");
    XCTAssertEqual([decoded countForKey:   @"key"], 2u, @"");
    XCTAssertEqual([decoded countForKey: @"other"], 1u, @"");
    
    XCTAssertTrue([decoded containsObject: @1 forKey:   @"key"], @"");
    XCTAssertTrue([decoded containsObject: @2 forKey:   @"key"], @"");
    XCTAssertTrue([decoded containsObject: @3 forKey: @"other"], @"");
}


- (void) testUnionSelf
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set unionKeyedSet: set];
    
    XCTAssertEqual(set.count, 3u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 2u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");
    
    XCTAssertTrue([set containsObject: @1 forKey:   @"key"], @"");
    XCTAssertTrue([set containsObject: @2 forKey:   @"key"], @"");
    XCTAssertTrue([set containsObject: @3 forKey: @"other"], @"");
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
    
    XCTAssertEqual(set.count, 5u, @"");
    XCTAssertEqual([set countForKey:     @"key"], 3u, @"");
    XCTAssertEqual([set countForKey:   @"other"], 1u, @"");
    XCTAssertEqual([set countForKey: @"someKey"], 1u, @"");
    
    XCTAssertTrue([set containsObject: @1 forKey:     @"key"], @"");
    XCTAssertTrue([set containsObject: @2 forKey:     @"key"], @"");
    XCTAssertTrue([set containsObject: @4 forKey:     @"key"], @"");
    XCTAssertTrue([set containsObject: @3 forKey:   @"other"], @"");
    XCTAssertTrue([set containsObject: @5 forKey: @"someKey"], @"");
    
    
    XCTAssertEqual(other.count, 3u, @"");
    XCTAssertEqual([other countForKey:     @"key"], 2u, @"");
    XCTAssertEqual([other countForKey:   @"other"], 0u, @"");
    XCTAssertEqual([other countForKey: @"someKey"], 1u, @"");
}


- (void) testMinusSelf
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set minusKeyedSet: set];
    
    XCTAssertEqual(set.count, 0u, @"");
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
    
    XCTAssertEqual(set.count, 3u, @"");
    XCTAssertEqual([set countForKey:     @"key"], 1u, @"");
    XCTAssertEqual([set countForKey:   @"other"], 2u, @"");
    XCTAssertEqual([set countForKey: @"someKey"], 0u, @"");
    
    XCTAssertFalse([set containsObject: @1 forKey: @"key"], @"");
    
    XCTAssertTrue([set containsObject: @2 forKey:   @"key"], @"");
    XCTAssertTrue([set containsObject: @1 forKey: @"other"], @"");
    XCTAssertTrue([set containsObject: @3 forKey: @"other"], @"");
    
    
    XCTAssertEqual(other.count, 3u, @"");
    XCTAssertEqual([other countForKey:     @"key"], 2u, @"");
    XCTAssertEqual([other countForKey:   @"other"], 0u, @"");
    XCTAssertEqual([other countForKey: @"someKey"], 1u, @"");
}


- (void) testIntersectSelf
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    [set addObject: @1 forKey: @"key"];
    [set addObject: @2 forKey: @"key"];
    [set addObject: @3 forKey: @"other"];
    
    [set intersectKeyedSet: set];
    
    XCTAssertEqual(set.count, 3u, @"");
    XCTAssertEqual([set countForKey:   @"key"], 2u, @"");
    XCTAssertEqual([set countForKey: @"other"], 1u, @"");
    
    XCTAssertTrue([set containsObject: @1 forKey:   @"key"], @"");
    XCTAssertTrue([set containsObject: @2 forKey:   @"key"], @"");
    XCTAssertTrue([set containsObject: @3 forKey: @"other"], @"");
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
    
    XCTAssertEqual(set.count, 1u, @"");
    XCTAssertEqual([set countForKey:     @"key"], 1u, @"");
    
    XCTAssertTrue([set containsObject: @1 forKey: @"key"], @"");
    
    XCTAssertEqual(other.count, 3u, @"");
    XCTAssertEqual([other countForKey:     @"key"], 2u, @"");
    XCTAssertEqual([other countForKey:   @"other"], 0u, @"");
    XCTAssertEqual([other countForKey: @"someKey"], 1u, @"");
}


- (void) testAddObjectForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set addObject: nil forKey:  @1], @"");
    XCTAssertThrows([set addObject: @1  forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set addObject: nil forKey:  @1], @"");
    XCTAssertNoThrow([set addObject: @1  forKey: nil], @"");
}


- (void) testAddObjectsFromArrayForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set addObjectsFromArray: nil forKey:  @1], @"");
    XCTAssertThrows([set addObjectsFromArray: @[] forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set addObjectsFromArray: nil forKey:  @1], @"");
    XCTAssertNoThrow([set addObjectsFromArray: @[] forKey: nil], @"");
}


- (void) testAddObjectsFromSetForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set addObjectsFromSet: nil         forKey:  @1], @"");
    XCTAssertThrows([set addObjectsFromSet: [NSSet set] forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set addObjectsFromSet: nil         forKey:  @1], @"");
    XCTAssertNoThrow([set addObjectsFromSet: [NSSet set] forKey: nil], @"");
}


- (void) testAddObjectsFromDictionaryException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set addObjectsFromDictionary: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set addObjectsFromDictionary: nil], @"");
}


- (void) testCountForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set countForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set countForKey: nil],     @"");
    XCTAssertEqual ([set countForKey: nil], 0u, @"");
}


- (void) testContainsObjectForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set containsObject: nil forKey:  @1], @"");
    XCTAssertThrows([set containsObject:  @1 forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set containsObject: nil forKey:  @1], @"");
    XCTAssertNoThrow([set containsObject:  @1 forKey: nil], @"");
    
    XCTAssertEqual ([set containsObject: nil forKey: nil], NO, @"");
    XCTAssertEqual ([set containsObject:  @1 forKey:  @1], NO, @"");
}


- (void) testContainsObjectException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set containsObject: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set containsObject: nil],     @"");
    XCTAssertEqual ([set containsObject: nil], NO, @"");
}


- (void) testArrayOfObjectsForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set arrayOfObjectsForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set arrayOfObjectsForKey: nil], @"");
    XCTAssertNil    ([set arrayOfObjectsForKey: nil], @"");
}


- (void) testSetOfObjectsForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set setOfObjectsForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set setOfObjectsForKey: nil], @"");
    XCTAssertNil    ([set setOfObjectsForKey: nil], @"");
}


- (void) testAnyObjectForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set anyObjectForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set anyObjectForKey: nil], @"");
    XCTAssertNil    ([set anyObjectForKey: nil], @"");
}


- (void) testRemoveAllObjectsForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set removeAllObjectsForKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set removeAllObjectsForKey: nil], @"");
}


- (void) testRemoveObjectException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set removeObject: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set removeObject: nil], @"");
}


- (void) testRemoveObjectForKeyException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set removeObject: nil forKey:  @1], @"");
    XCTAssertThrows([set removeObject:  @1 forKey: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set removeObject: nil forKey:  @1], @"");
    XCTAssertNoThrow([set removeObject:  @1 forKey: nil], @"");
}


- (void) testRemoveObjectsFromArrayException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set removeObjectsFromArray: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set removeObjectsFromArray: nil], @"");
}


- (void) testRemoveObjectsFromSetException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set removeObjectsFromSet: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set removeObjectsFromSet: nil], @"");
}


- (void) testEnumerateObjectsUsingBlockException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set enumerateObjectsUsingBlock: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set enumerateObjectsUsingBlock: nil], @"");
}


- (void) testEnumerateObjectsForKeyUsingBlockException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set enumerateObjectsForKey: nil usingBlock:
                    ^(id object, FRBKeyedSetKey key, BOOL *stop){}], @"");
    
    XCTAssertThrows([set enumerateObjectsForKey:  @1 usingBlock: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set enumerateObjectsForKey: nil usingBlock:
                    ^(id object, FRBKeyedSetKey key, BOOL *stop){}], @"");
    
    XCTAssertNoThrow([set enumerateObjectsForKey:  @1 usingBlock: nil], @"");
}


- (void) testUnionKeyedSetException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set unionKeyedSet: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set unionKeyedSet: nil], @"");
}


- (void) testMinusKeyedSetException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set minusKeyedSet: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set minusKeyedSet: nil], @"");
}


- (void) testIntersectKeyedSetException
{
    FRBKeyedSet *set = [FRBKeyedSet new];
    
    XCTAssertThrows([set intersectKeyedSet: nil], @"");
    
    set.suppressNilArgumentExceptions = YES;
    
    XCTAssertNoThrow([set intersectKeyedSet: nil], @"");
}

@end
