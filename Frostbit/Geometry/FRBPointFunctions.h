//
//  FRBPointFunctions.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 25.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBGeometry.h"

#pragma mark -
#pragma mark typedefs

/*! In the current implementation this is only an alias for CGPoint,
    so UIKit framework is required. But this may change in the future,
    and because of that Frostbit-specific types should be used.
 */
typedef CGPoint FRBPoint;


#pragma mark -
#pragma mark functions

/*! Analog of CGPointMake function to initialize a FRBPoint with the
    given coordinate values.
 */
FRBPoint FRBPointMake(const FRBFloat x, const FRBFloat y) FRB_ATTR_CONST;