//
//  FRBTestManagedObjectKVO.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 14.04.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FRBManagedObject.h"

#pragma mark -
#pragma mark FRBTestManagedObjectKVOHelper interface

@interface FRBTestManagedObjectKVOHelper : FRBManagedObject

@property (strong, nonatomic) NSString *stringProperty;
@property (assign, nonatomic) NSInteger integerProperty;
@property (assign, nonatomic) NSRange   rangeProperty;

@end


#pragma mark -
#pragma mark FRBTestManagedObjectKVO interface

@interface FRBTestManagedObjectKVO : XCTestCase
{
    FRBTestManagedObjectKVOHelper *_managedObject;
}

@end
