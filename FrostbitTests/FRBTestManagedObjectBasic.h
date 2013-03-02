//
//  FRBTestManagedObjectBasic.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "FRBManagedObject.h"


#pragma mark -
#pragma mark Helper class interface

@interface FRBTestManagedObjectBasicHelper : FRBManagedObject

@property (strong, nonatomic) NSString  *stringProperty;
@property (assign, nonatomic) NSInteger integerProperty;
@property (assign, nonatomic) BOOL         boolProperty;
@property (assign, nonatomic) double     doubleProperty;
@property (assign, nonatomic) CGPoint     pointProperty;
@property (assign, nonatomic) CGRect       rectProperty;
@property (assign, nonatomic) NSRange     rangeProperty;

@end


#pragma mark -
#pragma mark FRBTestManagedObjectBasic interface

/*! This test suite tests the basic functionality of FRBManagedObject. A helper subclass with a number of @dynamic properties is considered and the dynamic implementations of these properties are tested: whether the accessors are properly added to the class, whether setting property values work, whether getting property values work, whether the values are properly stored (i.e. checking the set and get results for equality).
 */
@interface FRBTestManagedObjectBasic : SenTestCase
@end
