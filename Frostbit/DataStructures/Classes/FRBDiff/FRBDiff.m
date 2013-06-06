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
    return (_addedKeyPaths.count   > 0) ||
           (_removedKeyPaths.count > 0) ||
           (_updatedKeyPaths.count > 0);
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
    
    NSMutableSet *updatedKeys = [commonKeys mutableCopy];
    
    @autoreleasepool
    {
        for (id key in commonKeys)
        {
            id oldValue = [oldRevision objectForKey: key];
            id newValue = [newRevision objectForKey: key];
            
            if ([oldValue conformsToProtocol: @protocol(FRBDictionaryTraits)] &&
                [newValue conformsToProtocol: @protocol(FRBDictionaryTraits)])
            {
                FRBDiff *nestedDiff = [[FRBDiff alloc] initWithOldRevision: oldValue
                                                               newRevision: newValue];
                
                if (nestedDiff.hasDifferences)
                {
                    for (id keyPath in nestedDiff.addedKeyPaths)
                    {
                        [addedKeys addObject:
                         [NSString stringWithFormat: @"%@.%@", key, keyPath]];
                    }
                    
                    for (id keyPath in nestedDiff.removedKeyPaths)
                    {
                        [removedKeys addObject:
                         [NSString stringWithFormat: @"%@.%@", key, keyPath]];
                    }
                    
                    for (id keyPath in nestedDiff.updatedKeyPaths)
                    {
                        [updatedKeys addObject:
                         [NSString stringWithFormat: @"%@.%@", key, keyPath]];
                    }
                }
                else
                {
                    [updatedKeys removeObject: key];
                }
            }
            else
            {
                
            } if ([[newRevision objectForKey: key] isEqual:
                   [oldRevision objectForKey: key]])
            {
                [updatedKeys removeObject: key];
            }
        }
    };
    
    _addedKeyPaths   = [addedKeys   copy];
    _removedKeyPaths = [removedKeys copy];
    _updatedKeyPaths = [updatedKeys copy];
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
