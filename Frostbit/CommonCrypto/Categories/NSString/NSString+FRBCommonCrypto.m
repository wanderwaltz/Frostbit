//
//  NSString+FRBCommonCrypto.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 26.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "NSString+FRBCommonCrypto.h"


#pragma mark -
#pragma mark NSString+FRBCommonCrypto implementation

@implementation NSString (FRBCommonCrypto)

- (NSString *) md5
{
    return FRB_MD5([self dataUsingEncoding: NSUTF8StringEncoding]);
}


- (NSString *) sha1
{
    return FRB_SHA1([self dataUsingEncoding: NSUTF8StringEncoding]);
}


- (NSString *) base64
{
    return FRB_Base64_Encode([self dataUsingEncoding: NSUTF8StringEncoding]);
}


+ (NSString *) stringWithBase64: (NSString *) base64
{
    return [[NSString alloc] initWithData: FRB_Base64_Decode(base64)
                                 encoding: NSUTF8StringEncoding];
}


@end
