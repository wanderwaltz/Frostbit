//
//  FRBDiff.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 4/23/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRBDictionaryTraits.h"

#pragma mark -
#pragma mark FRBDiff interface

@interface FRBDiff : NSObject

@property (readonly, nonatomic) NSSet   *addedKeys;
@property (readonly, nonatomic) NSSet *removedKeys;
@property (readonly, nonatomic) NSSet *updatedKeys;

- (BOOL) hasDifferences;

- (id) initWithOldRevision: (id) oldRevision
               newRevision: (id) newRevision;

@end
