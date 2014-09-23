//
//  FRBTestManagedObjectCustomGettersSetters.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestManagedObjectCustomGettersSetters.h"


#pragma mark -
#pragma mark FRBTestManagedObjectCustomGettersSettersHelper implementation

@implementation FRBTestManagedObjectCustomGettersSettersHelper

@dynamic customAccessorsProperty;
@dynamic customGetterProperty;
@dynamic customSetterProperty;

@end


#pragma mark -
#pragma mark FRBTestManagedObjectCustomGettersSetters implementation

@implementation FRBTestManagedObjectCustomGettersSetters

- (void) testRespondsToGetters
{
    Class class = [FRBTestManagedObjectCustomGettersSettersHelper class];
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(customGetterPropertyValue)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(customSetterProperty)],      @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(customAccessorsGetValue)],   @"");
}


- (void) testRespondsToSetters
{
    Class class = [FRBTestManagedObjectCustomGettersSettersHelper class];
    
    XCTAssertTrue([class instancesRespondToSelector: @selector(setCustomGetterProperty:)],      @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(customSetterPropertySetValue:)], @"");
    XCTAssertTrue([class instancesRespondToSelector: @selector(customAccessorsSetValue:)],      @"");
}


- (void) testDotAccess
{
    FRBTestManagedObjectCustomGettersSettersHelper *instance =
    [FRBTestManagedObjectCustomGettersSettersHelper new];
    
    instance.customGetterProperty    = 123;
    instance.customSetterProperty    = 456;
    instance.customAccessorsProperty = 789;
    
    XCTAssertEqual(123, instance.customGetterProperty,    @"");
    XCTAssertEqual(456, instance.customSetterProperty,    @"");
    XCTAssertEqual(789, instance.customAccessorsProperty, @"");
}


- (void) testMethodAccess
{
    FRBTestManagedObjectCustomGettersSettersHelper *instance =
    [FRBTestManagedObjectCustomGettersSettersHelper new];
    
    [instance setCustomGetterProperty: 123];
    [instance customSetterPropertySetValue: 456];
    [instance customAccessorsSetValue: 789];
    
    XCTAssertEqual(123, [instance customGetterPropertyValue], @"");
    XCTAssertEqual(456, [instance customSetterProperty],      @"");
    XCTAssertEqual(789, [instance customAccessorsGetValue],   @"");
}


@end
