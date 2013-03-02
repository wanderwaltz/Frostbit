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
    
    STAssertTrue([class instancesRespondToSelector: @selector(stringProperty)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector(    charProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(     intProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(   shortProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(    longProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(longLongProperty)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector(    unsignedCharProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(     unsignedIntProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(   unsignedShortProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(    unsignedLongProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(unsignedLongLongProperty)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector(   boolProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(stdBoolProperty)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector( floatProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(doubleProperty)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector(rangeProperty)], @"");
}


- (void) testRespondsToSetters
{
    Class class = [FRBTestManagedObjectBasicHelper class];
    
    STAssertTrue([class instancesRespondToSelector: @selector(setStringProperty:)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector(    setCharProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(     setIntProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(   setShortProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(    setLongProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(setLongLongProperty:)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector(    setUnsignedCharProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(     setUnsignedIntProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(   setUnsignedShortProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(    setUnsignedLongProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(setUnsignedLongLongProperty:)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector(   setBoolProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(setStdBoolProperty:)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector( setFloatProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(setDoubleProperty:)], @"");
    
    STAssertTrue([class instancesRespondToSelector: @selector(setRangeProperty:)], @"");
}


- (void) testStringPropertyNotNil
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    NSString *value = @"Test String Value";
    
    instance.stringProperty = value;
    
    STAssertTrue([instance.stringProperty isKindOfClass: [NSString class]], @"");
    STAssertEqualObjects(value, instance.stringProperty, @"");
}


- (void) testStringPropertyNil
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.stringProperty = nil;
    
    STAssertTrue(nil == instance.stringProperty, @"");
}


- (void) testCharProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.charProperty = CHAR_MAX;
    
    STAssertEquals((char)CHAR_MAX, instance.charProperty, @"");
    
    instance.charProperty = (int)CHAR_MAX+1;
    
    STAssertEquals((char)CHAR_MIN, instance.charProperty, @"");
}


- (void) testShortProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.shortProperty = SHRT_MAX;
    
    STAssertEquals((short)SHRT_MAX, instance.shortProperty, @"");
    
    instance.shortProperty = (long)SHRT_MAX+1;
    
    STAssertEquals((short)SHRT_MIN, instance.shortProperty, @"");
}

- (void) testIntProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.intProperty = INT_MAX;
    
    STAssertEquals((int)INT_MAX, instance.intProperty, @"");
    
    instance.intProperty = (long)INT_MAX+1;
    
    STAssertEquals((int)INT_MIN, instance.intProperty, @"");
}


- (void) testLongProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.longProperty = LONG_MAX;
    
    STAssertEquals((long)LONG_MAX, instance.longProperty, @"");
    
    instance.longProperty = (long long)LONG_MAX+1;
    
    STAssertEquals((long)LONG_MIN, instance.longProperty, @"");
}


- (void) testLongLongProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.longLongProperty = LONG_LONG_MAX;
    
    STAssertEquals((long long)LONG_LONG_MAX, instance.longLongProperty, @"");
    
    instance.longLongProperty = (unsigned long long)LONG_LONG_MAX+1;
    
    STAssertEquals((long long)LONG_LONG_MIN, instance.longLongProperty, @"");
}


- (void) testFloatProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    float value = 654.321;
    
    instance.floatProperty = value;
    
    STAssertEquals(value, instance.floatProperty, @"");
}


- (void) testDoubleProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    double value = 123.456;

    instance.doubleProperty = value;
    
    STAssertEquals(value, instance.doubleProperty, @"");
}


- (void) testBoolProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.boolProperty = YES;
    STAssertEquals(YES, (BOOL)instance.boolProperty, @"");
    
    instance.boolProperty = NO;
    STAssertEquals(NO, (BOOL)instance.boolProperty, @"");
}


- (void) testStdBoolProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.stdBoolProperty = true;
    STAssertEquals((bool)true, instance.stdBoolProperty, @"");
    
    instance.stdBoolProperty = false;
    STAssertEquals((bool)false, instance.stdBoolProperty, @"");
}


- (void) testRangeProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    NSRange value = NSMakeRange(123, 456);
    
    instance.rangeProperty = value;
    STAssertEquals(value, instance.rangeProperty, @"");
}

@end
