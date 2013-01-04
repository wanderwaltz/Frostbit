//
//  FRBRectFunctions.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBRectFunctions.h"

#pragma mark -
#pragma mark functions

FRBRect FRBRectMake(const FRBFloat x,     const FRBFloat y,
                    const FRBFloat width, const FRBFloat height)
{
    return CGRectMake(x, y, width, height);
}


FRBRect FRBRectMakeWithSize(const FRBSize size)
{
    return CGRectMake(0.0, 0.0, size.width, size.height);
}