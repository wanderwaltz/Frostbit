//
//  FRBTestManagedObjectCustomGettersSetters.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FRBManagedObject.h"


#pragma mark -
#pragma mark FRBTestManagedObjectCustomGettersSettersHelper interface

@interface FRBTestManagedObjectCustomGettersSettersHelper : FRBManagedObject

@property (assign, nonatomic, getter = customGetterPropertyValue) NSInteger customGetterProperty;
@property (assign, nonatomic, setter = customSetterPropertySetValue:) NSInteger customSetterProperty;
@property (assign, nonatomic, getter = customAccessorsGetValue, setter = customAccessorsSetValue:) NSInteger customAccessorsProperty;

@end


#pragma mark -
#pragma mark FRBTestManagedObjectCustomGettersSetters interface

@interface FRBTestManagedObjectCustomGettersSetters : XCTestCase
@end
