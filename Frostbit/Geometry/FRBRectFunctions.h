//
//  FRBRectFunctions.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBGeometry.h"

#pragma mark -
#pragma mark typedefs

typedef CGRect FRBRect;


#pragma mark -
#pragma mark functions

FRBRect FRBRectMake(const FRBFloat x,     const FRBFloat y,
                    const FRBFloat width, const FRBFloat height) FRB_ATTR_CONST;
