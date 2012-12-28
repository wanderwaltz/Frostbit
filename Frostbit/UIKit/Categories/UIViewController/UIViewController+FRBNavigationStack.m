//
//  UIViewController+FRBNavigationStack.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "UIViewController+FRBNavigationStack.h"


#pragma mark -
#pragma mark UIViewController+FRBNavigationStack implementation

@implementation UIViewController (FRBNavigationStack)

- (UINavigationController *) embedInNavigationController
{
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController: self];
    
    return navigationController;
}

@end
