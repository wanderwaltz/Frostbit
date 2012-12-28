//
//  UIViewController+FRBNavigationStack.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBUIKit.h"


#pragma mark -
#pragma mark UIViewController+FRBNavigationStack interface

@interface UIViewController (FRBNavigationStack)

- (UINavigationController *) embedInNavigationController;

@end
