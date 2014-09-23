//
//  FRBTestManagedObjectBasic.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FRBManagedObject.h"


#pragma mark -
#pragma mark Helper class interface

@interface FRBTestManagedObjectBasicHelper : FRBManagedObject

@property (strong, nonatomic) NSString  *stringProperty;

@property (assign, nonatomic) char          charProperty;
@property (assign, nonatomic) int            intProperty;
@property (assign, nonatomic) short        shortProperty;
@property (assign, nonatomic) long          longProperty;
@property (assign, nonatomic) long long longLongProperty;

@property (assign, nonatomic) unsigned char          unsignedCharProperty;
@property (assign, nonatomic) unsigned int            unsignedIntProperty;
@property (assign, nonatomic) unsigned short        unsignedShortProperty;
@property (assign, nonatomic) unsigned long          unsignedLongProperty;
@property (assign, nonatomic) unsigned long long unsignedLongLongProperty;

@property (assign, nonatomic) BOOL    boolProperty;
@property (assign, nonatomic) bool stdBoolProperty;

@property (assign, nonatomic) float   floatProperty;
@property (assign, nonatomic) double doubleProperty;

@property (assign, nonatomic) NSRange rangeProperty;

@end


#pragma mark -
#pragma mark FRBTestManagedObjectBasic interface

/*! This test suite tests the basic functionality of FRBManagedObject. A helper subclass with a number of @dynamic properties is considered and the dynamic implementations of these properties are tested: whether the accessors are properly added to the class, whether setting property values work, whether getting property values work, whether the values are properly stored (i.e. checking the set and get results for equality).
 */
@interface FRBTestManagedObjectBasic : XCTestCase
@end
