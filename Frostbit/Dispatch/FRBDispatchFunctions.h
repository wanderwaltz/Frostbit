//
//  FRBDispatchFunctions.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBDispatch.h"

#pragma mark -
#pragma mark functions

/*! Implements switch-like construction by iterating
    the list of arguments similar to this:
 
    if ([arg isEqualToString: arg1]) block1();
    else
    if ([arg isEqualToString: arg2]) block2();
    else ...
 
    returns YES if a match was found, and NO otherwise.
 
    Each string argument must be followed by a dispatch_block_t
    argument which would be executed if a match is found.
 
    @note If a match is found, the processing block is 
          executed synchronously in the current queue
 */
BOOL FRB_switch_strings(NSString *arg, ...);



/*! Implements switch-like construction by iterating
    the list of arguments similar to this:
 
    if ([arg isKindOfClass: arg1]) block1();
    else
    if ([arg isKindOfClass: arg2]) block2();
    else ...
 
    returns YES if a match was found, and NO otherwise.
 
    Each class argument must be followed by a dispatch_block_t
    argument which would be executed if a match is found.
 
    @note If a match is found, the processing block is 
          executed synchronously in the current queue
 */
BOOL FRB_switch_class_kindof(id arg, ...);