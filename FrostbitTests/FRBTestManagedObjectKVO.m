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


#pragma mark - Test observer

@interface FRBTestManagedObjectKVObserver : NSObject
@property (nonatomic, strong) NSString *receivedKeypath;
@property (nonatomic, strong) id receivedObject;
@end


@implementation FRBTestManagedObjectKVObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.receivedKeypath = keyPath;
    self.receivedObject = object;
}

@end


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
    
    XCTAssertEqualObjects(_managedObject.stringProperty, @"new value",
                         @"-setValue:forKey: should set the corresponding property value "
                         @"of the FRBManagedObject");
}


- (void) testValueForKeyStringProperty
{
    _managedObject.stringProperty = @"new value";
    
    XCTAssertEqualObjects([_managedObject valueForKey: @"stringProperty"], @"new value",
                         @"-valueForKey: should return the corresponding property value "
                         @"of the FRBManagedObject");
}


- (void) testSetValueForKeyIntegerProperty
{
    [_managedObject setValue: @1234 forKey: @"integerProperty"];
    
    XCTAssertEqual(_managedObject.integerProperty, 1234,
                   @"-setValue:forKey: should set the corresponding property value "
                   @"of the FRBManagedObject");
}


- (void) testValueForKeyIntegerProperty
{
    _managedObject.integerProperty = 1234;
    
    XCTAssertEqualObjects([_managedObject valueForKey: @"integerProperty"], @1234,
                         @"-valueForKey: should return the corresponding property value "
                         @"of the FRBManagedObject");
}


//- (void) testSetValueForKeyRangeProperty
//{
//    [_managedObject setValue: [NSValue valueWithRange: NSMakeRange(12, 34)]
//                      forKey: @"rangeProperty"];
//    
//    XCTAssertEqual(_managedObject.rangeProperty, NSMakeRange(12, 34),
//                   @"-setValue:forKey: should set the corresponding property value "
//                   @"of the FRBManagedObject");
//}


//- (void) testValueForKeyRangeProperty
//{
//    _managedObject.rangeProperty = NSMakeRange(12, 34);
//    
//    XCTAssertEqual([[_managedObject valueForKey: @"rangeProperty"] rangeValue],
//                   NSMakeRange(12, 34),
//                   @"-valueForKey: should return the corresponding property value "
//                   @"of the FRBManagedObject");
//}


- (void) testObserverMethodGetsCalledForStringProperty
{
    FRBTestManagedObjectKVObserver *observer = [FRBTestManagedObjectKVObserver new];
    
    [_managedObject addObserver: observer
                     forKeyPath: @"stringProperty"
                        options: NSKeyValueObservingOptionNew
                        context: NULL];
    
    _managedObject.stringProperty = @"new value";
    

    XCTAssertEqualObjects(observer.receivedObject, _managedObject);
    XCTAssertEqualObjects(observer.receivedKeypath, @"stringProperty");
                   
    [_managedObject removeObserver: observer forKeyPath: @"stringProperty"];
}


- (void) testObserverMethodGetsCalledForIntegerProperty
{
    FRBTestManagedObjectKVObserver *observer = [FRBTestManagedObjectKVObserver new];
    
    [_managedObject addObserver: observer
                     forKeyPath: @"integerProperty"
                        options: NSKeyValueObservingOptionNew
                        context: NULL];
    
    _managedObject.integerProperty = 1234;
    
    
    XCTAssertEqualObjects(observer.receivedObject, _managedObject);
    XCTAssertEqualObjects(observer.receivedKeypath, @"integerProperty");
    
    [_managedObject removeObserver: observer forKeyPath: @"integerProperty"];
}


- (void) testObserverMethodGetsCalledForRangeProperty
{
    FRBTestManagedObjectKVObserver *observer = [FRBTestManagedObjectKVObserver new];
    
    [_managedObject addObserver: observer
                     forKeyPath: @"rangeProperty"
                        options: NSKeyValueObservingOptionNew
                        context: NULL];
    
    _managedObject.rangeProperty = NSMakeRange(12, 34);
    
    
    XCTAssertEqualObjects(observer.receivedObject, _managedObject);
    XCTAssertEqualObjects(observer.receivedKeypath, @"rangeProperty");
    
    [_managedObject removeObserver: observer forKeyPath: @"rangeProperty"];
}


@end
