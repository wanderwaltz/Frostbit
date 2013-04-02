//
//  FRBKeyedSet.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.04.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBKeyedSet.h"


#pragma mark -
#pragma mark FRBKeyedSet private

@interface FRBKeyedSet()
{
@private
    NSMutableDictionary *_keyedSets;
    NSUInteger _totalCount;
}

@property (readonly, nonatomic) NSMutableDictionary *keyedSets;
@property (assign,   nonatomic) NSUInteger totalCount;

@end


#pragma mark -
#pragma mark FRBKeyedSet implementation

@implementation FRBKeyedSet

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _totalCount = 0;
        _keyedSets  = nil; // Will be created lazily
    }
    return self;
}



#pragma mark -
#pragma mark methods

- (void) addObject: (id) object
            forKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    FRB_AssertNotNil(object);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: YES];
    FRB_AssertClass(set, NSMutableSet);
    
    NSUInteger oldCount = set.count;
    [set addObject: object];
    
    if (set.count > oldCount) _totalCount++;
}


- (NSUInteger) countForKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return set.count;
}


- (NSUInteger) count
{
    return _totalCount;
}


- (NSArray *) arrayOfObjectsForKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return set.allObjects;
}


- (NSSet *) setOfObjectsForKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return [set copy];
}


- (id) anyObjectForKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return set.anyObject;
}


- (NSSet *) setOfAllObjects
{
    NSMutableSet *unionSet = [NSMutableSet set];
    
    for (NSMutableSet *set in self.keyedSets)
    {
        FRB_AssertClass(set, NSMutableSet);
        [unionSet unionSet: set];
    }
    
    return [unionSet copy];
}


- (NSArray *) arrayOfAllObjects
{
    return self.setOfAllObjects.allObjects;
}


- (void) removeAllObjects
{
    _totalCount = 0;
    [self.keyedSets removeAllObjects];
}


- (void) removeAllObjectsForKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    NSUInteger count = set.count;
    FRB_AssertIntegerRange_LE_X_LE(0, count, _totalCount);
    
    _totalCount -= count;
    [self.keyedSets removeObjectForKey: key];
}


- (void) removeObject: (id) object
{
    FRB_AssertNotNil(object);
    
    for (NSMutableSet *set in self.keyedSets)
    {
        FRB_AssertClass(set, NSMutableSet);
        if ([set containsObject: object])
        {
            FRB_AssertIntegerPositive(_totalCount);
            [set removeObject: object];
            _totalCount --;
        }
    }
}


- (void) enumerateObjectsUsingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator
{
    if (enumerator != nil)
    {
        [self.keyedSets enumerateKeysAndObjectsUsingBlock:
         ^(FRBKeyedSetKey key, NSMutableSet *set, BOOL *stop) {
             FRB_AssertClass(set, NSMutableSet);
             [set enumerateObjectsUsingBlock:
              ^(id object, BOOL *stop) {
                  enumerator(object, key);
              }];
         }];
    }
}


- (void) enumerateObjectsForKey: (FRBKeyedSetKey) key
                     usingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator
{
    FRB_AssertNotNil(key);
    if (enumerator != nil)
    {
        NSMutableSet *set = [self setForKey: key
                           createIfNotFound: NO];
        FRB_AssertClassOrNil(set, NSMutableSet);
        
        [set enumerateObjectsUsingBlock:
         ^(id object, BOOL *stop) {
             enumerator(object, key);
         }];
    }
}


#pragma mark -
#pragma mark private

- (NSMutableSet *) setForKey: (FRBKeyedSetKey) key
            createIfNotFound: (BOOL) shouldCreate
{
    FRB_AssertNotNil(key);
    NSMutableSet *set = self.keyedSets[key];
    
    if ((set == nil) && shouldCreate)
    {
        set = [NSMutableSet set];
    }
    
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return set;
}


#pragma mark -
#pragma mark private properties

- (NSMutableDictionary *) keyedSets
{
    if (_keyedSets == nil)
    {
        _keyedSets = [NSMutableDictionary dictionary];
    }
    
    return _keyedSets;
}

@end
