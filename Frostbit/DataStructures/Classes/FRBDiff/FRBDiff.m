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
    self = [super init];
    
    if (self != nil)
    {
        
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (BOOL) hasDifferences
{
    return NO;
}

@end
