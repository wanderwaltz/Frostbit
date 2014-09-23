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
    
    XCTAssertEqual(point.x, 0.0f);
    XCTAssertEqual(point.y, 0.0f);
    
    point = FRBPointMake(1.0, 0.0);
    
    XCTAssertEqual(point.x, 1.0f);
    XCTAssertEqual(point.y, 0.0f);
    
    point = FRBPointMake(0.0, 1.0);
    
    XCTAssertEqual(point.x, 0.0f);
    XCTAssertEqual(point.y, 1.0f);
    
    point = FRBPointMake(2.0, 3.0);
    
    XCTAssertEqual(point.x, 2.0f);
    XCTAssertEqual(point.y, 3.0f);
    
    point = FRBPointMake(0.0, NAN);
    
    XCTAssertEqual(point.x, 0.0f);
//    XCTAssertEqual(point.y,  NAN);
    
    point = FRBPointMake(NAN, 0.0);
    
//    XCTAssertEqual(point.x,  NAN);
    XCTAssertEqual(point.y, 0.0f);
}


//- (void) testConstants
//{
//    FRBPoint zero = FRBPointZero;
//    
//    XCTAssertEqual(zero.x, 0.0f);
//    XCTAssertEqual(zero.y, 0.0f);
//    
//    FRBPoint invalid = FRBPointInvalid;
//    
//    XCTAssertEqual(invalid.x, NAN);
//    XCTAssertEqual(invalid.y, NAN);
//}


- (void) testEquality
{
    FRBPoint a = FRBPointMake(0.0, 1.0);
    FRBPoint b = FRBPointMake(1.0, 0.0);
    FRBPoint c = FRBPointMake(1.0, 1.0);
    FRBPoint d = FRBPointMake(2.0, 3.0);
    
    XCTAssertTrue(FRBPointIsEqualToPoint(a, a));
    XCTAssertTrue(FRBPointIsEqualToPoint(b, b));
    XCTAssertTrue(FRBPointIsEqualToPoint(c, c));
    XCTAssertTrue(FRBPointIsEqualToPoint(d, d));
    
    XCTAssertTrue (FRBPointIsEqualToPoint(FRBPointZero,    FRBPointZero));
    XCTAssertFalse(FRBPointIsEqualToPoint(FRBPointInvalid, FRBPointInvalid));
    
    XCTAssertFalse(FRBPointIsEqualToPoint(a, b));
    XCTAssertFalse(FRBPointIsEqualToPoint(a, c));
    XCTAssertFalse(FRBPointIsEqualToPoint(a, d));
    
    XCTAssertFalse(FRBPointIsEqualToPoint(b, a));
    XCTAssertFalse(FRBPointIsEqualToPoint(b, c));
    XCTAssertFalse(FRBPointIsEqualToPoint(b, d));
    
    XCTAssertFalse(FRBPointIsEqualToPoint(c, a));
    XCTAssertFalse(FRBPointIsEqualToPoint(c, b));
    XCTAssertFalse(FRBPointIsEqualToPoint(c, d));
    
    XCTAssertFalse(FRBPointIsEqualToPoint(d, a));
    XCTAssertFalse(FRBPointIsEqualToPoint(d, b));
    XCTAssertFalse(FRBPointIsEqualToPoint(d, c));
    
    XCTAssertTrue (FRBPointIsZero(FRBPointZero));
    XCTAssertFalse(FRBPointIsZero(FRBPointInvalid));
    XCTAssertFalse(FRBPointIsZero(a));
    XCTAssertFalse(FRBPointIsZero(b));
    XCTAssertFalse(FRBPointIsZero(c));
    XCTAssertFalse(FRBPointIsZero(d));
    
    XCTAssertFalse(FRBPointIsValid(FRBPointInvalid));
    XCTAssertTrue (FRBPointIsValid(FRBPointZero));
    XCTAssertTrue (FRBPointIsValid(a));
    XCTAssertTrue (FRBPointIsValid(b));
    XCTAssertTrue (FRBPointIsValid(c));
    XCTAssertTrue (FRBPointIsValid(d));
}


#pragma mark -
#pragma mark basic tests - shortcut versions

#if FRB_GEOMETRY_USE_POINT_SHORTCUTS

- (void) testFRBPointMake_Shortcut
{
    FRBPoint point = xy(0.0, 0.0);
    
    XCTAssertEqual(point.x, 0.0f);
    XCTAssertEqual(point.y, 0.0f);
    
    point = xy(1.0, 0.0);
    
    XCTAssertEqual(point.x, 1.0f);
    XCTAssertEqual(point.y, 0.0f);
    
    point = xy(0.0, 1.0);
    
    XCTAssertEqual(point.x, 0.0f);
    XCTAssertEqual(point.y, 1.0f);
    
    point = xy(2.0, 3.0);
    
    XCTAssertEqual(point.x, 2.0f);
    XCTAssertEqual(point.y, 3.0f);
    
    point = xy(0.0, NAN);
    
    XCTAssertEqual(point.x, 0.0f);
//    XCTAssertEqual(point.y,  NAN);
    
    point = xy(NAN, 0.0);
    
//    XCTAssertEqual(point.x,  NAN);
    XCTAssertEqual(point.y, 0.0f);
}


//- (void) testConstants_Shortcut
//{
//    FRBPoint zero = xyZero;
//    
//    XCTAssertEqual(zero.x, 0.0f);
//    XCTAssertEqual(zero.y, 0.0f);
//    
//    FRBPoint invalid = xyInvalid;
//    
//    XCTAssertEqual(invalid.x, NAN);
//    XCTAssertEqual(invalid.y, NAN);
//}


- (void) testEquality_Shortcut
{
    FRBPoint a = xy(0.0, 1.0);
    FRBPoint b = xy(1.0, 0.0);
    FRBPoint c = xy(1.0, 1.0);
    FRBPoint d = xy(2.0, 3.0);
    
    XCTAssertTrue(xyEquals(a, a));
    XCTAssertTrue(xyEquals(b, b));
    XCTAssertTrue(xyEquals(c, c));
    XCTAssertTrue(xyEquals(d, d));
    
    XCTAssertTrue (xyEquals(xyZero,    xyZero));
    XCTAssertFalse(xyEquals(xyInvalid, xyInvalid));
    
    XCTAssertFalse(xyEquals(a, b));
    XCTAssertFalse(xyEquals(a, c));
    XCTAssertFalse(xyEquals(a, d));
    
    XCTAssertFalse(xyEquals(b, a));
    XCTAssertFalse(xyEquals(b, c));
    XCTAssertFalse(xyEquals(b, d));
    
    XCTAssertFalse(xyEquals(c, a));
    XCTAssertFalse(xyEquals(c, b));
    XCTAssertFalse(xyEquals(c, d));
    
    XCTAssertFalse(xyEquals(d, a));
    XCTAssertFalse(xyEquals(d, b));
    XCTAssertFalse(xyEquals(d, c));
    
    
    XCTAssertTrue (xyIsZero(FRBPointZero));
    XCTAssertFalse(xyIsZero(FRBPointInvalid));
    XCTAssertFalse(xyIsZero(a));
    XCTAssertFalse(xyIsZero(b));
    XCTAssertFalse(xyIsZero(c));
    XCTAssertFalse(xyIsZero(d));
    
    XCTAssertFalse(xyIsValid(FRBPointInvalid));
    XCTAssertTrue (xyIsValid(FRBPointZero));
    XCTAssertTrue (xyIsValid(a));
    XCTAssertTrue (xyIsValid(b));
    XCTAssertTrue (xyIsValid(c));
    XCTAssertTrue (xyIsValid(d));
}

#endif

@end
