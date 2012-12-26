//
//  NSData+FRBCommonCrypto.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 26.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "NSData+FRBCommonCrypto.h"


#pragma mark -
#pragma mark NSData+FRBCommonCrypto implementation

@implementation NSData (FRBCommonCrypto)

- (NSString *) md5
{
    return FRB_MD5(self);
}


- (NSString *) sha1
{
    return FRB_SHA1(self);
}


- (NSString *) base64
{
    return FRB_Base64_Encode(self);
}


+ (NSData *) dataWithBase64: (NSString *) base64
{
    return FRB_Base64_Decode(base64);
}


@end
