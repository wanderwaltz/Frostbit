//
//  FRBTestGeometryPointFunctions.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 26.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBTestGeometryPointFunctions.h"


#pragma mark -
#pragma mark FRBTestGeometryPointFunctions implementation

@implementation FRBTestGeometryPointFunctions

#pragma mark -
#pragma mark basic tests

- (void) testFRBPointMake
{
    FRBPoint point = FRBPointMake(0.0, 0.0);
    
    STAssertEquals(point.x, 0.0f, nil);
    STAssertEquals(point.y, 0.0f, nil);
    
    point = FRBPointMake(1.0, 0.0);
    
    STAssertEquals(point.x, 1.0f, nil);
    STAssertEquals(point.y, 0.0f, nil);
    
    point = FRBPointMake(0.0, 1.0);
    
    STAssertEquals(point.x, 0.0f, nil);
    STAssertEquals(point.y, 1.0f, nil);
    
    point = FRBPointMake(2.0, 3.0);
    
    STAssertEquals(point.x, 2.0f, nil);
    STAssertEquals(point.y, 3.0f, nil);
    
    point = FRBPointMake(0.0, NAN);
    
    STAssertEquals(point.x, 0.0f, nil);
    STAssertEquals(point.y,  NAN, nil);
    
    point = FRBPointMake(NAN, 0.0);
    
    STAssertEquals(point.x,  NAN, nil);
    STAssertEquals(point.y, 0.0f, nil);
}


- (void) testConstants
{
    FRBPoint zero = FRBPointZero;
    
    STAssertEquals(zero.x, 0.0f, nil);
    STAssertEquals(zero.y, 0.0f, nil);
    
    FRBPoint invalid = FRBPointInvalid;
    
    STAssertEquals(invalid.x, NAN, nil);
    STAssertEquals(invalid.y, NAN, nil);
}


- (void) testEquality
{
    FRBPoint a = FRBPointMake(0.0, 1.0);
    FRBPoint b = FRBPointMake(1.0, 0.0);
    FRBPoint c = FRBPointMake(1.0, 1.0);
    FRBPoint d = FRBPointMake(2.0, 3.0);
    
    STAssertTrue(FRBPointIsEqualToPoint(a, a), nil);
    STAssertTrue(FRBPointIsEqualToPoint(b, b), nil);
    STAssertTrue(FRBPointIsEqualToPoint(c, c), nil);
    STAssertTrue(FRBPointIsEqualToPoint(d, d), nil);
    
    STAssertTrue (FRBPointIsEqualToPoint(FRBPointZero,    FRBPointZero),    nil);
    STAssertFalse(FRBPointIsEqualToPoint(FRBPointInvalid, FRBPointInvalid), nil);
    
    STAssertFalse(FRBPointIsEqualToPoint(a, b), nil);
    STAssertFalse(FRBPointIsEqualToPoint(a, c), nil);
    STAssertFalse(FRBPointIsEqualToPoint(a, d), nil);
    
    STAssertFalse(FRBPointIsEqualToPoint(b, a), nil);
    STAssertFalse(FRBPointIsEqualToPoint(b, c), nil);
    STAssertFalse(FRBPointIsEqualToPoint(b, d), nil);
    
    STAssertFalse(FRBPointIsEqualToPoint(c, a), nil);
    STAssertFalse(FRBPointIsEqualToPoint(c, b), nil);
    STAssertFalse(FRBPointIsEqualToPoint(c, d), nil);
    
    STAssertFalse(FRBPointIsEqualToPoint(d, a), nil);
    STAssertFalse(FRBPointIsEqualToPoint(d, b), nil);
    STAssertFalse(FRBPointIsEqualToPoint(d, c), nil);
    
    STAssertTrue (FRBPointIsZero(FRBPointZero),    nil);
    STAssertFalse(FRBPointIsZero(FRBPointInvalid), nil);
    STAssertFalse(FRBPointIsZero(a), nil);
    STAssertFalse(FRBPointIsZero(b), nil);
    STAssertFalse(FRBPointIsZero(c), nil);
    STAssertFalse(FRBPointIsZero(d), nil);
    
    STAssertFalse(FRBPointIsValid(FRBPointInvalid), nil);
    STAssertTrue (FRBPointIsValid(FRBPointZero),    nil);
    STAssertTrue (FRBPointIsValid(a), nil);
    STAssertTrue (FRBPointIsValid(b), nil);
    STAssertTrue (FRBPointIsValid(c), nil);
    STAssertTrue (FRBPointIsValid(d), nil);
}


#pragma mark -
#pragma mark basic tests - shortcut versions

#if FRB_GEOMETRY_USE_POINT_SHORTCUTS

- (void) testFRBPointMake_Shortcut
{
    FRBPoint point = xy(0.0, 0.0);
    
    STAssertEquals(point.x, 0.0f, nil);
    STAssertEquals(point.y, 0.0f, nil);
    
    point = xy(1.0, 0.0);
    
    STAssertEquals(point.x, 1.0f, nil);
    STAssertEquals(point.y, 0.0f, nil);
    
    point = xy(0.0, 1.0);
    
    STAssertEquals(point.x, 0.0f, nil);
    STAssertEquals(point.y, 1.0f, nil);
    
    point = xy(2.0, 3.0);
    
    STAssertEquals(point.x, 2.0f, nil);
    STAssertEquals(point.y, 3.0f, nil);
    
    point = xy(0.0, NAN);
    
    STAssertEquals(point.x, 0.0f, nil);
    STAssertEquals(point.y,  NAN, nil);
    
    point = xy(NAN, 0.0);
    
    STAssertEquals(point.x,  NAN, nil);
    STAssertEquals(point.y, 0.0f, nil);
}


- (void) testConstants_Shortcut
{
    FRBPoint zero = xyZero;
    
    STAssertEquals(zero.x, 0.0f, nil);
    STAssertEquals(zero.y, 0.0f, nil);
    
    FRBPoint invalid = xyInvalid;
    
    STAssertEquals(invalid.x, NAN, nil);
    STAssertEquals(invalid.y, NAN, nil);
}


- (void) testEquality_Shortcut
{
    FRBPoint a = xy(0.0, 1.0);
    FRBPoint b = xy(1.0, 0.0);
    FRBPoint c = xy(1.0, 1.0);
    FRBPoint d = xy(2.0, 3.0);
    
    STAssertTrue(xyEquals(a, a), nil);
    STAssertTrue(xyEquals(b, b), nil);
    STAssertTrue(xyEquals(c, c), nil);
    STAssertTrue(xyEquals(d, d), nil);
    
    STAssertTrue (xyEquals(xyZero,    xyZero),    nil);
    STAssertFalse(xyEquals(xyInvalid, xyInvalid), nil);
    
    STAssertFalse(xyEquals(a, b), nil);
    STAssertFalse(xyEquals(a, c), nil);
    STAssertFalse(xyEquals(a, d), nil);
    
    STAssertFalse(xyEquals(b, a), nil);
    STAssertFalse(xyEquals(b, c), nil);
    STAssertFalse(xyEquals(b, d), nil);
    
    STAssertFalse(xyEquals(c, a), nil);
    STAssertFalse(xyEquals(c, b), nil);
    STAssertFalse(xyEquals(c, d), nil);
    
    STAssertFalse(xyEquals(d, a), nil);
    STAssertFalse(xyEquals(d, b), nil);
    STAssertFalse(xyEquals(d, c), nil);
    
    
    STAssertTrue (xyIsZero(FRBPointZero),    nil);
    STAssertFalse(xyIsZero(FRBPointInvalid), nil);
    STAssertFalse(xyIsZero(a), nil);
    STAssertFalse(xyIsZero(b), nil);
    STAssertFalse(xyIsZero(c), nil);
    STAssertFalse(xyIsZero(d), nil);
    
    STAssertFalse(xyIsValid(FRBPointInvalid), nil);
    STAssertTrue (xyIsValid(FRBPointZero),    nil);
    STAssertTrue (xyIsValid(a), nil);
    STAssertTrue (xyIsValid(b), nil);
    STAssertTrue (xyIsValid(c), nil);
    STAssertTrue (xyIsValid(d), nil);
}

#endif

@end
