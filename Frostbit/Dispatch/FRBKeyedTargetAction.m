//
//  FRBKeyedTargetAction.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBKeyedTargetAction.h"
#import <objc/message.h>


#pragma mark -
#pragma mark FRBKeyedTargetAction private

@interface FRBKeyedTargetAction()
{
    NSMutableDictionary *_actions;
}

@end


#pragma mark -
#pragma mark FRBKeyedTargetAction implementation

@implementation FRBKeyedTargetAction

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _actions = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (void) addActions: (NSDictionary *) actions
{
    [actions enumerateKeysAndObjectsUsingBlock:
     ^(id key, NSString *selectorString, BOOL *stop)
     {
         FRB_AssertNotNil(key);
         FRB_AssertClass(selectorString, NSString);
         
         if (_target)
         {
             __attribute__((unused)) SEL selector = NSSelectorFromString(selectorString);
             FRB_AssertResponds(_target, selector);
         }
         
         _actions[key] = selectorString;
     }];
}


- (void) addAction: (SEL) selector forKey: (id<NSCopying>) key
{
    FRB_AssertNotNil(key);
    
    if (_target) FRB_AssertResponds(_target, selector);
    
    NSString *selectorString = NSStringFromSelector(selector);
    FRB_AssertClass(selectorString, NSString);
    
    _actions[key] = selectorString;
}


- (void) deleteActionForKey: (id<NSCopying>) key
{
    FRB_AssertNotNil(key);
    [_actions removeObjectForKey: key];
}


- (void) doActionForKey: (id<NSCopying>) key
{
    [self doActionForKey: key
                  sender: nil];
}


- (void) doActionForKey: (id<NSCopying>) key sender: (id) sender
{
    FRB_AssertNotNil(key);
    NSString *selectorString = _actions[key];
    
    if (selectorString != nil)
    {
        FRB_AssertClass(selectorString, NSString);
        SEL selector = NSSelectorFromString(selectorString);
        FRB_AssertResponds(_target, selector);
        
        if ([selectorString hasSuffix: @":"]) {
            void (*method)(id, SEL, id) = (void(*)(id, SEL, id))objc_msgSend;
            method(_target, selector, sender);
        }
        else {
            void (*method)(id, SEL) = (void(*)(id, SEL))objc_msgSend;
            method(_target, selector);
        }
    }
    else if (!_inhibitConsoleWarnings)
    {
        NSArray *symbols = [NSThread callStackSymbols];
        
        if (symbols.count > 4)
            symbols = [symbols subarrayWithRange: NSMakeRange(0, 4)];
        
        NSLog(@"%@: ignored attempt to perform action for undefined key: %@\nCall stack:\n%@\n\n",
              self, key, symbols);
    }
}

@end
