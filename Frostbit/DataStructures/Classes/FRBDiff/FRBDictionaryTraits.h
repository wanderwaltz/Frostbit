//
//  FRBDictionaryTraits.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 4/23/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark FRBDictionaryTraits protocol

@protocol FRBDictionaryTraits <NSObject>

- (id) objectForKey: (id<NSCopying>) key;
- (NSArray *) allKeys;

@end
