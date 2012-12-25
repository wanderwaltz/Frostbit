//
//  FRBDispatchFunctions.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBDispatchFunctions.h"

#pragma mark -
#pragma mark functions

BOOL FRB_switch_strings(NSString *arg, ...)
{
    va_list args;
    va_start(args, arg);
    
    NSString *value = va_arg(args, NSString *);
    
    BOOL found = NO;
    
    while (value != nil)
    {
        dispatch_block_t block = va_arg(args, dispatch_block_t);
        
        if ([arg isEqualToString: value])
        {
            block();
            found = YES;
            break;
        }
        
        value = va_arg(args, NSString *);
    }
    
    va_end(args);
    
    return found;
}


BOOL FRB_switch_class_kindof(id arg, ...)
{
    va_list args;
    va_start(args, arg);
    
    Class class = va_arg(args, Class);
    
    BOOL found = NO;
    
    while (class != nil)
    {
        dispatch_block_t block = va_arg(args, dispatch_block_t);
        
        if ([arg isKindOfClass: class])
        {
            block();
            found = YES;
            break;
        }
        
        class = va_arg(args, Class);
    }
    
    va_end(args);
    
    return found;
}
