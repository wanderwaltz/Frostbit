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

@dynamic  stringProperty;
@dynamic integerProperty;
@dynamic    boolProperty;
@dynamic  doubleProperty;
@dynamic   pointProperty;
@dynamic    rectProperty;
@dynamic   rangeProperty;

@end


#pragma mark -
#pragma mark FRBTestManagedObjectBasic implementation

@implementation FRBTestManagedObjectBasic

- (void) testRespondsToGetters
{
    Class class = [FRBTestManagedObjectBasicHelper class];
    
    STAssertTrue([class instancesRespondToSelector: @selector( stringProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(integerProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(   boolProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector( doubleProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(  pointProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(   rectProperty)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(  rangeProperty)], @"");
}


- (void) testRespondsToSetters
{
    Class class = [FRBTestManagedObjectBasicHelper class];
    
    STAssertTrue([class instancesRespondToSelector: @selector( setStringProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(setIntegerProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(   setBoolProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector( setDoubleProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(  setPointProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(   setRectProperty:)], @"");
    STAssertTrue([class instancesRespondToSelector: @selector(  setRangeProperty:)], @"");
}


- (void) testStringPropertyNotNil
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    NSString *value = @"Test String Value";
    
    instance.stringProperty = value;
    
    STAssertEqualObjects(value, instance.stringProperty, @"");
}


- (void) testStringPropertyNil
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    instance.stringProperty = nil;
    
    STAssertEquals(nil, instance.stringProperty, @"");
}


- (void) testIntegerProperty
{
    FRBTestManagedObjectBasicHelper *instance =
    [FRBTestManagedObjectBasicHelper new];
    
    NSInteger value = 123;
    
    instance.integerProperty = value;
    
    STAssertEquals(value, (NSInteger)instance.integerProperty, @"");
}

@end
