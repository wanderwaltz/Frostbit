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

@property (readonly, nonatomic) NSSet   *addedKeyPaths;
@property (readonly, nonatomic) NSSet *removedKeyPaths;
@property (readonly, nonatomic) NSSet *updatedKeyPaths;

- (BOOL) hasDifferences;

- (id) initWithOldRevision: (id) oldRevision
               newRevision: (id) newRevision;

@end
