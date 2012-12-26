//
//  NSString+FRBCommonCrypto.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 26.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBCommonCrypto.h"


#pragma mark -
#pragma mark NSString+FRBCommonCrypto interface

@interface NSString (FRBCommonCrypto)

- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) base64;

+ (NSString *) stringWithBase64: (NSString *) base64;

@end
