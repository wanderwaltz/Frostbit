//
//  FRBKeyedSet.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.04.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "FRBDataStructures.h"

// TODO: add NSCopying
// TODO: add NSCoding
// TODO: add other FRBKeyedSet interaction (union, minus etc.)
// TODO: add other initializers
// TODO: add fast enumeration (for ... in)
// TODO: add documentation

#pragma mark -
#pragma mark Typedefs

typedef id<NSCopying> FRBKeyedSetKey;
typedef void (^FRBKeyedSetKeyObjectEnumerator)(id object, FRBKeyedSetKey key, BOOL *stop);


#pragma mark -
#pragma mark FRBKeyedSet interface

@interface FRBKeyedSet : NSObject

- (id) init; ///< Designated initializer; creates an empty keyed set


#pragma mark adding objects

- (void) addObject: (id) object forKey: (FRBKeyedSetKey) key;

- (void) addObjectsFromArray: (NSArray *) array forKey: (FRBKeyedSetKey) key;

- (void) addObjectsFromSet: (NSSet *) set forKey: (FRBKeyedSetKey) key;

- (void) addObjectsFromDictionary: (NSDictionary *) dictionary;


#pragma mark counting objects

- (NSUInteger) countForKey: (FRBKeyedSetKey) key;
- (NSUInteger) count;


#pragma mark getting objects

- (BOOL) containsObject: (id) object;
- (BOOL) containsObject: (id) object forKey: (FRBKeyedSetKey) key;

- (NSArray *) arrayOfObjectsForKey: (FRBKeyedSetKey) key;
- (NSSet *)     setOfObjectsForKey: (FRBKeyedSetKey) key;
- (id)             anyObjectForKey: (FRBKeyedSetKey) key;

- (NSSet   *)   setOfAllObjects;
- (NSArray *) arrayOfAllObjects;


#pragma mark object removal

- (void) removeAllObjects;
- (void) removeAllObjectsForKey: (FRBKeyedSetKey) key;
- (void) removeObject: (id) object;
- (void) removeObject: (id) object forKey: (FRBKeyedSetKey) key;

- (void) removeObjectsFromArray: (NSArray *) array;
- (void) removeObjectsFromSet: (NSSet *) set;


#pragma mark enumeration

- (void) enumerateObjectsUsingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator;

- (void) enumerateObjectsForKey: (FRBKeyedSetKey) key
                     usingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator;

@end
