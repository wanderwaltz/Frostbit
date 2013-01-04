//
//  FRBGeometryTypes.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 04.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#ifndef Frostbit_FRBGeometryTypes_h
#define Frostbit_FRBGeometryTypes_h

#import <CoreGraphics/CoreGraphics.h>
#import "FRBCommon.h"


#pragma mark -
#pragma mark typedefs

/*! In the current implementation this is only an alias for CGPoint,
 so Core Graphics framework is required. But this may change in
 the future, and because of that Frostbit-specific types should
 be used.
 */
typedef CGPoint FRBPoint;


/*! In the current implementation this is only an alias for CGSize,
 so Core Graphics framework is required. But this may change in
 the future, and because of that Frostbit-specific types should
 be used.
 */
typedef CGSize FRBSize;


/*! In the current implementation this is only an alias for CGRect,
 so Core Graphics framework is required. But this may change in
 the future, and because of that Frostbit-specific types should
 be used.
 */
typedef CGRect FRBRect;


#endif
