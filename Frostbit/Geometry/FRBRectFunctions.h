//
//  FRBRectFunctions.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBGeometry.h"

#pragma mark -
#pragma mark functions

/*! Analog of CGRectMake function to initialize a FRBRect with the
    given origin coordinates and width/height
 */
FRBRect FRBRectMake(const FRBFloat x,     const FRBFloat y,
                    const FRBFloat width, const FRBFloat height) FRB_ATTR_CONST;



/*! Creates a FRBRect with the given size and origin of FRBPointZero.
 
 @param size Size of the rect to make.
 */
FRBRect FRBRectMakeWithSize(const FRBSize size) FRB_ATTR_CONST;
