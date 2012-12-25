//
//  FRBPointFunctions.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBPointFunctions.h"

#pragma mark -
#pragma mark constants

const FRBPoint FRBPointZero    = {0.0, 0.0};
const FRBPoint FRBPointInvalid = {NAN, NAN};


#pragma mark -
#pragma mark functions

FRBPoint FRBPointMake(const FRBFloat x, const FRBFloat y)
{
    return CGPointMake(x, y);
}


BOOL FRBPointIsValid(const FRBPoint p)
{
    return !(isnan(p.x) || isnan(p.y));
}


BOOL FRBPointIsZero(const FRBPoint p)
{
    return (p.x == 0.0) && (p.y == 0.0);
}


BOOL FRBPointIsEqualToPoint(const FRBPoint a, const FRBPoint b)
{
    return (a.x == b.x) && (a.y == b.y);
}


#pragma mark vector arithmetic

FRBPoint FRBPointAdd(const FRBPoint a, const FRBPoint b)
{
    return FRBPointMake(a.x + b.x, a.y + b.y);
}


FRBPoint FRBPointSub(const FRBPoint a, const FRBPoint b)
{
    return FRBPointMake(a.x - b.x, a.y - b.y);
}


FRBFloat FRBPointDot(const FRBPoint a, const FRBPoint b)
{
    return a.x * b.x + a.y * b.y;
}


FRBPoint FRBPointMul(const FRBPoint a, const FRBFloat s)
{
    return FRBPointMake(a.x * s, a.y * s);
}


FRBPoint FRBPointDiv(const FRBPoint a, const FRBFloat s)
{
    return FRBPointMake(a.x / s, a.y / s);
}


FRBFloat FRBPointLen(const FRBPoint a)
{
    return sqrtf(FRBPointDot(a, a));
}


FRBPoint FRBPointNormalize(const FRBPoint a)
{
    FRBFloat len = FRBPointLen(a);
    
    if (len > 0)
    {
        return FRBPointDiv(a, len);
    }
    else return FRBPointZero;
}
