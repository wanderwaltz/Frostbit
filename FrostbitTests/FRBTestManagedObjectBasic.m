//
//  FRBTestManagedObjectBasic.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestManagedObjectBasic.h"


#pragma mark -
#pragma mark Helper class implementation

@implementation FRBTestManagedObjectBasicHelper

@dynamic stringProperty;

@dynamic     charProperty;
@dynamic      intProperty;
@dynamic    shortProperty;
@dynamic     longProperty;
@dynamic longLongProperty;

@dynamic     unsignedCharProperty;
@dynamic      unsignedIntProperty;
@dynamic    unsignedShortProperty;
@dynamic     unsignedLongProperty;
@dynamic unsignedLongLongProperty;

@dynamic    boolProperty;
@dynamic stdBoolProperty;

@dynamic  floatProperty;
@dynamic doubleProperty;

@dynamic rangeProperty;

@end


#pragma mark -
#pragma mark FRBTestManagedObjectBasic implementation

@implementation FRBTestManagedObjectBasic

- (void) testRespondsToGetters
{
    Class class = [FRBTestManagedObjectBasicHelper class];
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(stringProperty)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(    charProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(     intProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(   shortProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(    longProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(longLongProperty)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(    unsignedCharProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(     unsignedIntProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(   unsignedShortProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(    unsignedLongProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(unsignedLongLongProperty)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(   boolProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(stdBoolProperty)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector( floatProperty)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(doubleProperty)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(rangeProperty)], @"");
}


- (void) testRespondsToSetters
{
    Class class = [FRBTestManagedObjectBasicHelper class];
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(setStringProperty:)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(    setCharProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(     setIntProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(   setShortProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(    setLongProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(setLongLongProperty:)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(    setUnsignedCharProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(     setUnsignedIntProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(   setUnsignedShortProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(    setUnsignedLongProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(setUnsignedLongLongProperty:)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(   setBoolProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(setStdBoolProperty:)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector( setFloatProperty:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(setDoubleProperty:)], @"");
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(setRangeProperty:)], @"");
}


- (void) testStringPropertyNotNil
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    NSString *value = @"Test String Value";
    
    instance.stringProperty = value;
    
    XCTAssertTrue([instance.stringProperty isKindOfClass: [NSString class]], @"");
    XCTAssertEqualObjects(value, instance.stringProperty, @"");
}


- (void) testStringPropertyNil
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.stringProperty = nil;
    
    XCTAssertTrue(nil == instance.stringProperty, @"");
}


- (void) testCharProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.charProperty = CHAR_MAX;
    
    XCTAssertEqual((char)CHAR_MAX, instance.charProperty, @"");
    
    instance.charProperty = (int)CHAR_MAX+1;
    
    XCTAssertEqual((char)CHAR_MIN, instance.charProperty, @"");
}


- (void) testShortProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.shortProperty = SHRT_MAX;
    
    XCTAssertEqual((short)SHRT_MAX, instance.shortProperty, @"");
    
    instance.shortProperty = (long)SHRT_MAX+1;
    
    XCTAssertEqual((short)SHRT_MIN, instance.shortProperty, @"");
}

- (void) testIntProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.intProperty = INT_MAX;
    
    XCTAssertEqual((int)INT_MAX, instance.intProperty, @"");
    
    instance.intProperty = (long)INT_MAX+1;
    
    XCTAssertEqual((int)INT_MIN, instance.intProperty, @"");
}


- (void) testLongProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.longProperty = LONG_MAX;
    
    XCTAssertEqual((long)LONG_MAX, instance.longProperty, @"");
    
    instance.longProperty = (long long)LONG_MAX+1;
    
    XCTAssertEqual((long)LONG_MIN, instance.longProperty, @"");
}


- (void) testLongLongProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.longLongProperty = LONG_LONG_MAX;
    
    XCTAssertEqual((long long)LONG_LONG_MAX, instance.longLongProperty, @"");
    
    instance.longLongProperty = (unsigned long long)LONG_LONG_MAX+1;
    
    XCTAssertEqual((long long)LONG_LONG_MIN, instance.longLongProperty, @"");
}


- (void) testFloatProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    float value = 654.321;
    
    instance.floatProperty = value;
    
    XCTAssertEqual(value, instance.floatProperty, @"");
}


- (void) testDoubleProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    double value = 123.456;

    instance.doubleProperty = value;
    
    XCTAssertEqual(value, instance.doubleProperty, @"");
}


- (void) testBoolProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.boolProperty = YES;
    XCTAssertEqual(YES, (BOOL)instance.boolProperty, @"");
    
    instance.boolProperty = NO;
    XCTAssertEqual(NO, (BOOL)instance.boolProperty, @"");
}


- (void) testStdBoolProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.stdBoolProperty = true;
    XCTAssertEqual((bool)true, instance.stdBoolProperty, @"");
    
    instance.stdBoolProperty = false;
    XCTAssertEqual((bool)false, instance.stdBoolProperty, @"");
}


//- (void) testRangeProperty
//{
//    FRBTestManagedObjectBasicHelper *instance =
//    [FRBTestManagedObjectBasicHelper new];
//    
//    NSRange value = NSMakeRange(123, 456);
//    
//    instance.rangeProperty = value;
//    XCTAssertEqual(value, instance.rangeProperty, @"");
//}

@end
