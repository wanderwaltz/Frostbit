//
//  FRBKeyedSet.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.04.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "FRBDataStructures.h"


#pragma mark -
#pragma mark Typedefs

typedef id<NSCopying> FRBKeyedSetKey;

typedef void (^FRBKeyedSetKeyObjectEnumerator)(id object, FRBKeyedSetKey key);


#pragma mark -
#pragma mark FRBKeyedSet interface

@interface FRBKeyedSet : NSObject

- (id) init; ///< Designated initializer

- (void) addObject: (id) object forKey: (FRBKeyedSetKey) key;

// TODO: - (void) addObjectsFromArray: (NSArray *) array forKey: (FRBKeyedSetKey) key;
// TODO: - (void) addObjectsFromSet: (NSSet *) set forKey: (FRBKeyedSetKey *) key;
// TODO: - (void) addObjectsFromDictionary: (NSDictionary *) dictionary;



- (NSUInteger) countForKey: (FRBKeyedSetKey) key;
- (NSUInteger) count;

- (NSArray *) arrayOfObjectsForKey: (FRBKeyedSetKey) key;
- (NSSet *)     setOfObjectsForKey: (FRBKeyedSetKey) key;
- (id)             anyObjectForKey: (FRBKeyedSetKey) key;

- (NSSet   *)   setOfAllObjects;
- (NSArray *) arrayOfAllObjects;

- (void) removeAllObjects;
- (void) removeAllObjectsForKey: (FRBKeyedSetKey) key;
- (void) removeObject: (id) object;

// TODO: - (void) removeObjectsFromArray: (NSArray *) array;
// TODO: - (void) removeObjectsFromSet: (NSSet *) set;

- (void) enumerateObjectsUsingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator;

- (void) enumerateObjectsForKey: (FRBKeyedSetKey) key
                     usingBlock: (FRBKeyedSetKeyObjectEnumerator) enumerator;

@end
