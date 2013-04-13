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

@property (strong, atomic) NSMutableDictionary *keyedSets;

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
        _suppressNilArgumentExceptions = NO;
        
        _totalCount = 0;
        _keyedSets  = nil; // Will be created lazily
    }
    return self;
}


- (id) initWithKeyedSet: (FRBKeyedSet *) keyedSet
{
    self = [self init];
    
    if (self != nil)
    {
        NSMutableDictionary *keyedSets = [keyedSet.keyedSets mutableCopy];
        
        // We also need to copy the sets, so these are not shared
        // between self and the other keyed set
        NSArray *allKeys = keyedSets.allKeys;
        
        for (FRBKeyedSetKey key in allKeys)
        {
            NSMutableSet *set = keyedSets[key];
            FRB_AssertClass(set, NSMutableSet);
            
            keyedSets[key] = [set mutableCopy];
        }
        
        self.keyedSets = keyedSets;
    }
    return self;
}


- (id) initWithDictionary: (NSDictionary *) dictionary
{
    self = [self init];
    
    if (self != nil)
    {
        [self addObjectsFromDictionary: dictionary];
    }
    return self;
}


#pragma mark -
#pragma mark adding objects

- (void) addObject: (id) object
            forKey: (FRBKeyedSetKey) key
{
    if (object == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** addObjectForKey: object cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** addObjectForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
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
    if (array == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** addObjectsFromArrayForKey: array cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** addObjectsFromArrayForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
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
    if (set == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** addObjectsFromArrayForKey: set cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }

    
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** addObjectsFromSetForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(key);
    for (id object in set)
    {
        [self addObject: object
                 forKey: key];
    }
}


- (void) addObjectsFromDictionary: (NSDictionary *) dictionary
{
    if (dictionary == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** addObjectsFromDictionary: dictionary cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(dictionary);
    [dictionary enumerateKeysAndObjectsUsingBlock:
     ^(id key, id object, BOOL *stop) {
         
         FRB_AssertNotNil(key);
         FRB_AssertNotNil(object);
         
         [self addObject: object
                  forKey: key];
         
     }];
}




#pragma mark -
#pragma mark counting objects

- (NSUInteger) countForKey: (FRBKeyedSetKey) key
{
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** countForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return 0;
    }
    
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
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** containsObjectForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return NO;
    }
    
    if (object == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** containsObjectForKey: object cannot be nil"
                                   userInfo: nil] raise];
        }
        else return NO;
    }
    
    FRB_AssertNotNil(key);
    FRB_AssertNotNil(object);
    
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return [set containsObject: object];
}


- (BOOL) containsObject: (id) object
{
    if (object == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** containsObject: object cannot be nil"
                                   userInfo: nil] raise];
        }
        else return NO;
    }
    
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
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** arrayOfObjectsForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return nil;
    }
    
    FRB_AssertNotNil(key);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return set.allObjects;
}


- (NSSet *) setOfObjectsForKey: (FRBKeyedSetKey) key
{
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** setOfObjectsForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return nil;
    }
    
    FRB_AssertNotNil(key);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    return [set copy];
}


- (id) anyObjectForKey: (FRBKeyedSetKey) key
{
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** anyObjectForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return nil;
    }

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
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** removeAllObjectsForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }

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
    if (object == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** removeObject: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
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
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** removeObjectForKey: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    if (object == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** removeObjectForKey: object cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(object);
    FRB_AssertNotNil(key);
    
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    NSUInteger oldCount = set.count;
    [set removeObject: object];
    
    if (set.count < oldCount)
    {
        FRB_AssertIntegerPositive(_totalCount);
        _totalCount--;
    }
}


- (void) removeObjectsFromArray: (NSArray *) array
{
    if (array == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** removeObjectsFromArray: array cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(array);
    for (id object in array)
    {
        [self removeObject: object];
    }
}


- (void) removeObjectsFromSet: (NSSet *) set
{
    if (set == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** removeObjectsFromSet: set cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(set);
    for (id object in set)
    {
        [self removeObject: object];
    }
}



#pragma mark -
#pragma mark enumeration

- (void) enumerateObjectsUsingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator
{
    if (enumerator == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** enumerateObjectsUsingBlock: block cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
        
    FRB_AssertNotNil(enumerator);
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


- (void) enumerateObjectsForKey: (FRBKeyedSetKey) key
                     usingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator
{
    if (key == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** enumerateObjectsForKeyUsingBlock: key cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    
    if (enumerator == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** enumerateObjectsForKeyUsingBlock: block cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(key);
    FRB_AssertNotNil(enumerator);
    NSMutableSet *set = [self setForKey: key
                       createIfNotFound: NO];
    FRB_AssertClassOrNil(set, NSMutableSet);
    
    [set enumerateObjectsUsingBlock:
     ^(id object, BOOL *stop) {
         enumerator(object, key, stop);
     }];
}



#pragma mark -
#pragma mark keyed set operations

- (void) unionKeyedSet: (FRBKeyedSet *) keyedSet
{
    if (keyedSet == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** unionKeyedSet: keyedSet cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(keyedSet);
    NSMutableSet *unionKeys = [NSMutableSet setWithArray: self.keyedSets.allKeys];
    [unionKeys addObjectsFromArray: keyedSet.keyedSets.allKeys];
    
    for (FRBKeyedSetKey key in unionKeys)
    {
        NSMutableSet *set = [self setForKey: key
                           createIfNotFound: YES];
        FRB_AssertClass(set, NSMutableSet);
        
        NSMutableSet *otherSet = [keyedSet setForKey: key
                                    createIfNotFound: NO];
        FRB_AssertClassOrNil(otherSet, NSMutableSet);
        
        
        if (otherSet != nil)
        {
            NSUInteger oldCount = set.count;
            [set unionSet: otherSet];
            
            if (set.count > oldCount)
            {
                _totalCount += set.count-oldCount;
            }
        }
    }
}


- (void) minusKeyedSet: (FRBKeyedSet *) keyedSet
{
    if (keyedSet == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** minusKeyedSet: keyedSet cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(keyedSet);
    for (FRBKeyedSetKey key in keyedSet.keyedSets.allKeys)
    {
        NSMutableSet *set = [self setForKey: key
                           createIfNotFound: NO];
        FRB_AssertClassOrNil(set, NSMutableSet);
        
        if (set != nil)
        {
            NSMutableSet *otherSet = [keyedSet setForKey: key
                                        createIfNotFound: NO];
            FRB_AssertClass(otherSet, NSMutableSet);
            
            NSUInteger oldCount = set.count;
            [set minusSet: otherSet];
            
            if (set.count < oldCount)
            {
                FRB_AssertIntegerGreaterOrEquals(_totalCount, oldCount-set.count);
                _totalCount -= oldCount-set.count;
            }
        }
    }
}


- (void) intersectKeyedSet: (FRBKeyedSet *) keyedSet
{
    if (keyedSet == nil)
    {
        if (!_suppressNilArgumentExceptions)
        {
            [[NSException exceptionWithName: NSInvalidArgumentException
                                     reason: @"*** intersectKeyedSet: keyedSet cannot be nil"
                                   userInfo: nil] raise];
        }
        else return;
    }
    
    FRB_AssertNotNil(keyedSet);
    NSMutableSet *unionKeys = [NSMutableSet setWithArray: self.keyedSets.allKeys];
    [unionKeys addObjectsFromArray: keyedSet.keyedSets.allKeys];
    
    for (FRBKeyedSetKey key in unionKeys)
    {
        NSMutableSet *set = [self setForKey: key
                           createIfNotFound: NO];
        FRB_AssertClassOrNil(set, NSMutableSet);
        
        if (set != nil)
        {
            NSMutableSet *otherSet = [keyedSet setForKey: key
                                        createIfNotFound: NO];
            FRB_AssertClassOrNil(otherSet, NSMutableSet);
            
            
            if (otherSet != nil)
            {
                NSUInteger oldCount = set.count;
                [set intersectSet: otherSet];
                
                if (set.count < oldCount)
                {
                    FRB_AssertIntegerGreaterOrEquals(_totalCount, oldCount-set.count);
                    _totalCount -= oldCount-set.count;
                }
            }
            else
            {
                FRB_AssertIntegerGreaterOrEquals(_totalCount, set.count);
                _totalCount -= set.count;
                [set removeAllObjects];
            }
        }
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
    @synchronized(self)
    {
        if (_keyedSets == nil)
        {
            _keyedSets  = [NSMutableDictionary dictionary];
            _totalCount = 0;
        }
        
        return _keyedSets;
    }
}


- (void) setKeyedSets: (NSMutableDictionary *) keyedSets
{
    @synchronized(self)
    {
        _keyedSets  = keyedSets;
        _totalCount = 0;
        
        for (NSMutableSet *set in keyedSets.allValues)
        {
            FRB_AssertClass(set, NSMutableSet);
            _totalCount += set.count;
        }
    }
}



#pragma mark -
#pragma mark NSCopying

- (id) copyWithZone: (NSZone *) zone
{
    // We have a cloning initializer to do what's needed
    return [[[self class] alloc] initWithKeyedSet: self];
}



#pragma mark -
#pragma mark NSMutableCopying

- (id) mutableCopyWithZone: (NSZone *) zone
{
    // FRBKeyedSet is always mutable, so -mutableCopyWithZone:
    // does exactly the same as the usual -copyWithZone:
    return [self copyWithZone: zone];
}



#pragma mark -
#pragma mark NSCoding

static NSString * const kCodingKeyKeyedSets = @"com.frostbit.classes.FRBKeyedSet.NSCoding.keyedSets";

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super init];
    
    if (self != nil)
    {
        NSDictionary *keyedSetsImmutable = [aDecoder decodeObjectForKey: kCodingKeyKeyedSets];
        FRB_AssertClassOrNil(keyedSetsImmutable, NSDictionary);
        
        if (keyedSetsImmutable != nil)
        {
            NSMutableDictionary *keyedSets = [keyedSetsImmutable mutableCopy];
            
            NSArray *allKeys = keyedSets.allKeys;
            
            for (FRBKeyedSetKey key in allKeys)
            {
                NSMutableSet *set = keyedSets[key];
                FRB_AssertClass(set, NSSet);
                
                keyedSets[key] = [set mutableCopy];
            }
            
            self.keyedSets = keyedSets;
        }
    }
    return self;
}


- (void) encodeWithCoder: (NSCoder *) aCoder
{
    // No need to encode the total count since it will be evaluated from
    // the dictionary contents
    [aCoder encodeObject: self.keyedSets forKey: kCodingKeyKeyedSets];
}

@end
