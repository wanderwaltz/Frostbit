//
//  FRBKeyedTargetAction.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBDispatch.h"


#pragma mark -
#pragma mark FRBKeyedTargetAction interface

/*! Provides a way to send messages to an object based on an arbitrary key.
 
 This class encapsulates a mapping between id<NSCopying> keys and selectors. A weak reference to a target object is kept. The target object must respond to every selector which is passed as an action to one of the FRBKeyedTargetAction methods.
 */
@interface FRBKeyedTargetAction : NSObject

/*! Target object. All of the action messages will be sent to the target, so make sure that the target actually responds to these selectors.
 */
@property (weak, nonatomic) id target;



/*! Inhibit console output when trying to perform an action for unknown key.
 
 By default, FRBKeyedTargetAction dumps a portion of the call stack to the console using NSLog when an unknown key is encountered. This may be helpful in debugging purposes, but in some cases may be undesirable. Set this property to YES if you'd like to turn off the console output.
 */
@property (assign, nonatomic) BOOL inhibitConsoleWarnings;



/*! Adds an action for a given key.
 
 If the target object is already set, checks that the target does respond to the selector provided (using NSAssert).
 
 @param selector Selector which will be performed on the target object when the -doActionForKey: or -doActionForKey:sender: methods are called with the corresponding key.
 
 @param key Key to associate the selector with.
 */
- (void) addAction: (SEL) selector forKey: (id<NSCopying>) key;



/*! Removes the action for a given key from the mapping.
 
 Does nothing if there is no action associated with the key.
 
 @param key Key associated with an action.
 */
- (void) deleteActionForKey: (id<NSCopying>) key;



/*! Finds a selector associated with the given key and performs it on a target object.
 
 This is equivalent to calling -doActionForKey:sender: with the same key and nil sender.
 
 @param key Key associated with an action.
 
 @see -doActionForKey:sender:
 */
- (void) doActionForKey: (id<NSCopying>) key;



/*! Finds a selector associated with the given key and performs it on a target object.
 
 @param key    Key associated with an action.
 @param sender An optional parameter which can denote the sender of the message, or be of any other use if needed. This object is passed as the only parameter to the corresponding action selector. Can be nil. If the corresponding action method does not have parameters, the sender is ignored.
 
 If action selector for the given key cannot be found, does nothing, but dumps a portion of the callstack to the console output for debugging purposes.
 
 @see inhibitConsoleWarnings
 */
- (void) doActionForKey: (id<NSCopying>) key sender: (id) sender;



/*! Adds multiple actions at once.
 
 Instead of selectors, selector strings should be provided as the values of the actions dictionary.
 
 @param actions A dictionary with selector strings to be added as actions for the dictionary keys.
 */
- (void) addActions: (NSDictionary *) actions;

@end
