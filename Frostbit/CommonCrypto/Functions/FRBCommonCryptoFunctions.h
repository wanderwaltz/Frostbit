//
//  FRBCommonCryptoFunctions.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 26.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBCommonCrypto.h"

#pragma mark -
#pragma mark functions

#pragma mark base64

NSData   *FRB_Base64_Decode(NSString *base64);
NSString *FRB_Base64_Encode(NSData   *data);


#pragma mark sha1

NSString *FRB_SHA1(NSData *data);


#pragma mark md5

NSString *FRB_MD5(NSData *data);
