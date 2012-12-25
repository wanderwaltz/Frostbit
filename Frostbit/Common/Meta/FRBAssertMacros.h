//
//  FRBAssertMacros.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 26.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#ifndef Frostbit_FRBAssertMacros_h
#define Frostbit_FRBAssertMacros_h

/*! Macros defined in this file are used to shorten assertions with
    possibly complex and informative messages.
 */

#define FRB_AssertClass(Object, Class) \
    NSAssert([Object isKindOfClass: [Class class]], \
             @"Expected " @#Object " to be of class " @#Class @", got %@ instead", \
             [Object class])


#define FRB_AssertIsSubclassOfClass(Class, Superclass) \
    NSAssert([Class isSubclassOfClass: [Superclass class]], \
             @"Expected " @#Class " to be a subclass of " @#Superclass @", got %@ instead", \
             [Class class])


#define FRB_AssertClassOrNil(Object, Class) \
    NSAssert(((Object == nil) || [Object isKindOfClass: [Class class]]), \
             @"Expected " @#Object " to be of class " @#Class @", got %@ instead", \
             [Object class])


#define FRB_AssertResponds(Object, Selector) \
    NSAssert([Object respondsToSelector: Selector], \
             @"Expected " @#Object " (%@) to respond to %@", \
             Object, NSStringFromSelector(Selector))


#define FRB_ShouldNeverHappen(Description, ...) \
    NSAssert(NO, Description, ##__VA_ARGS__)


#define FRB_AssertNotNil(Object) \
    NSAssert(Object != nil, @"")

#endif
