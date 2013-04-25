//
//  FRBDiff.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 4/23/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBDiff.h"


#pragma mark -
#pragma mark FRBDiff implementation

@implementation FRBDiff

#pragma mark -
#pragma mark initialization methods

- (id) initWithOldRevision: (id) oldRevision
               newRevision: (id) newRevision
{
    [self throwExceptionIfNotDictionaryTraits: oldRevision];
    [self throwExceptionIfNotDictionaryTraits: newRevision];
    
    self = [super init];
    
    if (self != nil)
    {
        [self computeDictionaryDiffForOld: oldRevision
                                      new: newRevision];
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (BOOL) hasDifferences
{
    return (_addedKeys.count   > 0) ||
           (_removedKeys.count > 0) ||
           (_updatedKeys.count > 0);
}


#pragma mark -
#pragma mark private: compute diffs

- (void) computeDictionaryDiffForOld: (id<FRBDictionaryTraits>) oldRevision
                                 new: (id<FRBDictionaryTraits>) newRevision
{
    NSSet *oldKeys = [NSSet setWithArray: [oldRevision allKeys]];
    NSSet *newKeys = [NSSet setWithArray: [newRevision allKeys]];
    
    NSMutableSet *addedKeys = [newKeys mutableCopy];
    [addedKeys minusSet: oldKeys];
    
    NSMutableSet *removedKeys = [oldKeys mutableCopy];
    [removedKeys minusSet: newKeys];
    
    NSMutableSet *commonKeys = [oldKeys mutableCopy];
    [commonKeys intersectSet: newKeys];
    
    _addedKeys   = [addedKeys   copy];
    _removedKeys = [removedKeys copy];
    
    NSMutableSet *updatedKeys = [commonKeys mutableCopy];
    
    for (id key in commonKeys)
    {
        if ([[newRevision objectForKey: key] isEqual:
             [oldRevision objectForKey: key]])
        {
            [updatedKeys removeObject: key];
        }
    }
    
    _updatedKeys = [updatedKeys copy];
}


#pragma mark -
#pragma mark private: parameters validation

- (void) throwExceptionIfNotDictionaryTraits: (id) object
{
    if (![object conformsToProtocol: @protocol(FRBDictionaryTraits)])
    {
        @throw [NSException exceptionWithName: NSInvalidArgumentException
                                       reason:
                [NSString stringWithFormat:
                 @"*** initWithOldRevision:newRevision: "
                 @"%@ does not conform to FRBDictionaryTraits", object]
                                     userInfo: nil];
    }
}

@end
