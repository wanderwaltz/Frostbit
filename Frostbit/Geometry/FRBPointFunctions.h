//
//  FRBPointFunctions.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBGeometry.h"

#pragma mark -
#pragma mark configuration macros

/*! Point shortcuts are enabled by default, but these can be 
    switched off by defining FRM_GEOMETRY_USE_POINT_SHORTCUTS 
    as zero.
 */
#ifndef FRB_GEOMETRY_USE_POINT_SHORTCUTS
    #define FRB_GEOMETRY_USE_POINT_SHORTCUTS 1
#endif


#pragma mark -
#pragma mark shortcuts

/*! These shortcut macros are defined to simplify working with
    the Frostbit/Geometry point functions. If these macros are
    conflicting with some which are already defined in your project,
    these can be switched off (see configuration section of this file)
 */
#if FRB_GEOMETRY_USE_POINT_SHORTCUTS

    #define xy(x,y) FRBPointMake((x),(y))

    #define xyAdd(a,b) FRBPointAdd((a),(b))
    #define xySub(a,b) FRBPointSub((a),(b))
    #define xyDot(a,b) FRBPointDot((a),(b))
    #define xyMul(a,s) FRBPointMul((a),(s))
    #define xyDiv(a,s) FRBPointDiv((a),(s))

    #define xyLen(a) FRBPointLen((a))

    #define xyNorm(a) FRBPointNormalize((a))

    #define xyEquals(a,b) FRBPointIsEqualToPoint((a),(b))

    #define xyIsValid(a) FRBPointIsValid((a))
    #define xyIsZero(a)  FRBPointIsZero((a))

    #define xyInvalid FRBPointInvalid
    #define xyZero    FRBPointZero

#endif

#pragma mark -
#pragma mark constants

extern const FRBPoint FRBPointZero;
extern const FRBPoint FRBPointInvalid;


#pragma mark -
#pragma mark functions

/*! Analog of CGPointMake function to initialize a FRBPoint with the
    given coordinate values.
 */
FRBPoint FRBPointMake(const FRBFloat x, const FRBFloat y) FRB_ATTR_CONST;

BOOL FRBPointIsValid(const FRBPoint p) FRB_ATTR_CONST;
BOOL FRBPointIsZero(const FRBPoint p) FRB_ATTR_CONST;

BOOL FRBPointIsEqualToPoint(const FRBPoint a, const FRBPoint b) FRB_ATTR_CONST;


#pragma mark vector arithmetic

FRBPoint FRBPointAdd(const FRBPoint a, const FRBPoint b) FRB_ATTR_CONST;
FRBPoint FRBPointSub(const FRBPoint a, const FRBPoint b) FRB_ATTR_CONST;

FRBPoint FRBPointMul(const FRBPoint a, const FRBFloat s) FRB_ATTR_CONST;
FRBPoint FRBPointDiv(const FRBPoint a, const FRBFloat s) FRB_ATTR_CONST;

FRBFloat FRBPointDot(const FRBPoint a, const FRBPoint b) FRB_ATTR_CONST;
FRBFloat FRBPointLen(const CGPoint a) FRB_ATTR_CONST;

FRBPoint FRBPointNormalize(const CGPoint a) FRB_ATTR_CONST;