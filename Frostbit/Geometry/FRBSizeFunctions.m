//
//  FRBSizeFunctions.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBSizeFunctions.h"

#pragma mark -
#pragma mark functions

FRBSize FRBSizeMake(const FRBFloat width, const FRBFloat height)
{
    return CGSizeMake(width, height);
}