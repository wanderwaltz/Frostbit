//
//  FRBManagedObject.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark FRBManagedObject interface

/*! A class for simplifying implementation of model objects backed by NSDictionary for easier serialization. Subclasses of this class may declare @dynamic properties and FRBManagedObject will provide implementations for these properties which store the values in an NSDictionary.
 */
@interface FRBManagedObject : NSObject

/*! This dictionary is used as the internal storage for all of the FRBManagedObject properties. Direct access to this dictionary is restricted to a read-only and could be utilized for serializing the FRBManagedObjects using NSJSONSerialization or something similar.
 */
@property (readonly, nonatomic) NSDictionary *managedObjectRawData;

@end
