//
//  FRBTestManagedObjectKVO.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 14.04.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBTestManagedObjectKVO.h"
#import "OCMock.h"


#pragma mark -
#pragma mark FRBTestManagedObjectKVOHelper implementation

@implementation FRBTestManagedObjectKVOHelper

@dynamic stringProperty;

@end


#pragma mark -
#pragma mark FRBTestManagedObjectKVO implementation

@implementation FRBTestManagedObjectKVO

- (void) setUp
{
    [super setUp];
    _managedObject = [FRBTestManagedObjectKVOHelper new];
}


- (void) tearDown
{
    _managedObject = nil;
    [super tearDown];
}


- (void) testObserver
{

}

@end
