//
//  FRBSizeFunctions.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBGeometry.h"

#pragma mark -
#pragma mark functions

/*! Analog of CGSizeMake function to initialize a FRBSize with the
    given origin coordinates and width/height
 */
FRBSize FRBSizeMake(const FRBFloat width, const FRBFloat height) FRB_ATTR_CONST;