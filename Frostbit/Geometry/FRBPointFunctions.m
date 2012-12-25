//
//  FRBPointFunctions.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBPointFunctions.h"

#pragma mark -
#pragma mark functions

FRBPoint FRBPointMake(const FRBFloat x, const FRBFloat y)
{
    return CGPointMake(x, y);
}