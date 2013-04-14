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
@dynamic integerProperty;

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


- (void) testSetValueForKeyStringProperty
{
    [_managedObject setValue: @"new value" forKey: @"stringProperty"];
    
    STAssertEqualObjects(_managedObject.stringProperty, @"new value",
                         @"-setValue:forKey: should set the corresponding property value "
                         @"of the FRBManagedObject");
}


- (void) testValueForKeyStringProperty
{
    _managedObject.stringProperty = @"new value";
    
    STAssertEqualObjects([_managedObject valueForKey: @"stringProperty"], @"new value",
                         @"-valueForKey: should return the corresponding property value "
                         @"of the FRBManagedObject");
}


- (void) testSetValueForKeyIntegerProperty
{
    [_managedObject setValue: @1234 forKey: @"integerProperty"];
    
    STAssertEquals(_managedObject.integerProperty, 1234,
                   @"-setValue:forKey: should set the corresponding property value "
                   @"of the FRBManagedObject");
}


- (void) testValueForKeyIntegerProperty
{
    _managedObject.integerProperty = 1234;
    
    STAssertEqualObjects([_managedObject valueForKey: @"integerProperty"], @1234,
                         @"-valueForKey: should return the corresponding property value "
                         @"of the FRBManagedObject");
}


- (void) testSetValueForKeyRangeProperty
{
    [_managedObject setValue: [NSValue valueWithRange: NSMakeRange(12, 34)]
                      forKey: @"rangeProperty"];
    
    STAssertEquals(_managedObject.rangeProperty, NSMakeRange(12, 34),
                   @"-setValue:forKey: should set the corresponding property value "
                   @"of the FRBManagedObject");
}


- (void) testValueForKeyRangeProperty
{
    _managedObject.rangeProperty = NSMakeRange(12, 34);
    
    STAssertEquals([[_managedObject valueForKey: @"rangeProperty"] rangeValue],
                   NSMakeRange(12, 34),
                   @"-valueForKey: should return the corresponding property value "
                   @"of the FRBManagedObject");
}


- (void) testObserverMethodGetsCalledForStringProperty
{
    id observer = [OCMockObject mockForClass: [NSObject class]];
    
    [_managedObject addObserver: observer
                     forKeyPath: @"stringProperty"
                        options: NSKeyValueObservingOptionNew
                        context: NULL];
    
    [[observer expect] observeValueForKeyPath: @"stringProperty"
                                     ofObject: _managedObject
                                       change: OCMOCK_ANY
                                      context: [OCMArg anyPointer]];
    
    _managedObject.stringProperty = @"new value";
    

    STAssertNoThrow([observer verify],
                    @"KVO observer method should be called on observer object "
                    @"when changing the stringProperty value.");
    
    [_managedObject removeObserver: observer forKeyPath: @"stringProperty"];
}


- (void) testObserverMethodGetsCalledForIntegerProperty
{
    id observer = [OCMockObject mockForClass: [NSObject class]];
    
    [_managedObject addObserver: observer
                     forKeyPath: @"integerProperty"
                        options: NSKeyValueObservingOptionNew
                        context: NULL];
    
    [[observer expect] observeValueForKeyPath: @"integerProperty"
                                     ofObject: _managedObject
                                       change: OCMOCK_ANY
                                      context: [OCMArg anyPointer]];
    
    _managedObject.integerProperty = 1234;
    
    
    STAssertNoThrow([observer verify],
                    @"KVO observer method should be called on observer object "
                    @"when changing the stringProperty value.");
    
    [_managedObject removeObserver: observer forKeyPath: @"integerProperty"];
}


- (void) testObserverMethodGetsCalledForRangeProperty
{
    id observer = [OCMockObject mockForClass: [NSObject class]];
    
    [_managedObject addObserver: observer
                     forKeyPath: @"rangeProperty"
                        options: NSKeyValueObservingOptionNew
                        context: NULL];
    
    [[observer expect] observeValueForKeyPath: @"rangeProperty"
                                     ofObject: _managedObject
                                       change: OCMOCK_ANY
                                      context: [OCMArg anyPointer]];
    
    _managedObject.rangeProperty = NSMakeRange(12, 34);
    
    
    STAssertNoThrow([observer verify],
                    @"KVO observer method should be called on observer object "
                    @"when changing the stringProperty value.");
    
    [_managedObject removeObserver: observer forKeyPath: @"rangeProperty"];
}


@end
