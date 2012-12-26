//
//  NSData+FRBCommonCrypto.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 26.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBCommonCrypto.h"


#pragma mark -
#pragma mark NSData+FRBCommonCrypto interface

@interface NSData (FRBCommonCrypto)

- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) base64;

+ (NSData *) dataWithBase64: (NSString *) base64;

@end
