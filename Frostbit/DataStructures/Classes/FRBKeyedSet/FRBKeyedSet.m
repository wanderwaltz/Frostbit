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
#pragma mark adding objects

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


- (void) addObjectsFromArray: (NSArray *) array
                      forKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    for (id object in array)
    {
        [self addObject: object
                 forKey: key];
    }
}


- (void) addObjectsFromSet: (NSSet *) set
                    forKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    for (id object in set)
    {
        [self addObject: object
                 forKey: key];
    }
}


- (void) addObjectsFromDictionary: (NSDictionary *) dictionary
{
    [dictionary enumerateKeysAndObjectsUsingBlock:
     ^(id key, id object, BOOL *stop) {
         
         [self addObject: object
                  forKey: key];
         
     }];
}




#pragma mark -
#pragma mark counting objects

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




#pragma mark -
#pragma mark getting objects

- (BOOL) containsObject: (id) object
                 forKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(key);
    FRB_AssertNotNil(object);
    
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return [set containsObject: object];
}


- (BOOL) containsObject: (id) object
{
    FRB_AssertNotNil(object);
    
    for (NSMutableSet *set in self.keyedSets.allValues)
    {
        FRB_AssertClass(set, NSMutableSet);
        if ([set containsObject: object]) return YES;
    }
    
    return NO;
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
    
    for (NSMutableSet *set in self.keyedSets.allValues)
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




#pragma mark -
#pragma mark object removal

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
    
    for (NSMutableSet *set in self.keyedSets.allValues)
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


- (void) removeObject: (id) object
               forKey: (FRBKeyedSetKey) key
{
    FRB_AssertNotNil(object);
    FRB_AssertNotNil(key);
    
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    NSUInteger oldCount = set.count;
    [set removeObject: object];
    
    if (set.count < oldCount) _totalCount--;
}


- (void) removeObjectsFromArray: (NSArray *) array
{
    for (id object in array)
    {
        [self removeObject: object];
    }
}


- (void) removeObjectsFromSet: (NSSet *) set
{
    for (id object in set)
    {
        [self removeObject: object];
    }
}




#pragma mark -
#pragma mark enumeration

- (void) enumerateObjectsUsingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator
{
    if (enumerator != nil)
    {
        [self.keyedSets enumerateKeysAndObjectsUsingBlock:
         ^(FRBKeyedSetKey key, NSMutableSet *set, BOOL *stop)
         {
             __block BOOL shouldStop = NO;
             
             FRB_AssertClass(set, NSMutableSet);
             [set enumerateObjectsUsingBlock:
              ^(id object, BOOL *stop)
              {
                  enumerator(object, key, &shouldStop);
            
                  if (shouldStop) *stop = YES;
              }];
             
             if (shouldStop) *stop = YES;
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
             enumerator(object, key, stop);
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
        self.keyedSets[key] = set;
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
