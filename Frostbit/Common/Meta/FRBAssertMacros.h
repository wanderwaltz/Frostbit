//
//  FRBAssertMacros.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 26.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#ifndef Frostbit_FRBAssertMacros_h
#define Frostbit_FRBAssertMacros_h

/* Macros defined in this file are used to shorten assertions with possibly complex and informative messages.
 */


/* Asserts that the Object is kind of the Class provided. To shorten the statement, class name should be passed to the macro directly, for example FRB_AssertClass(@"Hello, World!", NSString);
 
 Note that this will fail for nil objects.
 */
#define FRB_AssertClass(Object, Class) \
    NSAssert([Object isKindOfClass: [Class class]], \
             @"Expected " @#Object " to be of class " @#Class @", got %@ instead", \
             [Object class])


// A variation of FRB_AssertClass, but will not fail for nil objects.
#define FRB_AssertClassOrNil(Object, Class) \
    NSAssert(((Object == nil) || [Object isKindOfClass: [Class class]]), \
             @"Expected " @#Object " to be of class " @#Class @", got %@ instead", \
            [Object class])



/* Asserts that the Class is a subclass of Superclass provided. To shorten the statement, class names should be passed to the macro directly, for example FRB_AssertIsSubclassOfClass(UILabel, UIView);
 */
#define FRB_AssertIsSubclassOfClass(Class, Superclass) \
    NSAssert([Class isSubclassOfClass: [Superclass class]], \
             @"Expected " @#Class " to be a subclass of " @#Superclass @", got %@ instead", \
             [Class class])



/* Asserts that the Object responds to the Selector provided. Selector should be passed as SEL or @selector, for example FRB_AssertResponds(@"Hello, World!", @selector(length));
 */
#define FRB_AssertResponds(Object, Selector) \
    NSAssert([Object respondsToSelector: Selector], \
             @"Expected " @#Object " (%@) to respond to %@", \
             Object, NSStringFromSelector(Selector))


// Always failing assertion with a self-describing name.
#define FRB_ShouldNeverHappen(Description, ...) \
    NSAssert(NO, Description, ##__VA_ARGS__)



// Asserts that the Object is not nil.
#define FRB_AssertNotNil(Object) \
    NSAssert(Object != nil, @"")


// Asserts that Object conforms to the Protocol provided.
#define FRB_AssertConformsTo(Object, Protocol) \
    NSAssert([Object conformsToProtocol: @protocol(Protocol)],\
             @"Expected " @#Object " (%@) to conform to protocol " @#Protocol, Object)


// Asserts that Object responds to Selector provided
#define FRB_AssertRespondsTo(Object, Selector)\
    NSAssert([Object respondsToSelector: Selector],\
             @"Expected " @#Object " (%@) to respond to " @#Selector, Object)


// Asserts that the inequality Left <= X < Right is true
#define FRB_AssertIntegerRange_LE_X_L(Left, X, Right)\
    NSAssert(((Left) <= (X)) && ((X) < (Right)), @"Expected %ld <= " @#X " < %ld, got %ld", (long)(Left), (long)(Right), (long)(X))

// Asserts that the inequality Left <= X <= Right is true
#define FRB_AssertIntegerRange_LE_X_LE(Left, X, Right)\
    NSAssert(((Left) <= (X)) && ((X) <= (Right)), @"Expected %ld <= " @#X " <= %ld, got %ld", (long)(Left), (long)(Right), (long)(X))

// Asserts that a certain X is > 0
#define FRB_AssertIntegerPositive(X)\
    NSAssert(((X) > 0), @"Expected " @#X @" > 0")


// Asserts that X >= Y
#define FRB_AssertIntegerGreaterOrEquals(X, Y) \
    NSAssert(((X) >= (Y)), @"Expected " @#X @"(%ld) >= " @#Y "(%ld)", (long)(X), (long)(Y))

#endif
