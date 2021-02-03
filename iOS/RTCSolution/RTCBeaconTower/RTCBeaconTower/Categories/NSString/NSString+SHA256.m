//
//  NSString+SHA256.m
//  RtcSample
//
//  Created by gaoyu on 2019/12/9.
//  Copyright © 2019 tiantian. All rights reserved.
//

#import "NSString+SHA256.h"

#import <CommonCrypto/CommonHMAC.h>


@implementation NSString (SHA256)

- (NSString *)SHA256
{
    const char *s = [self cStringUsingEncoding:NSUTF8StringEncoding];

    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];

    const unsigned *hashBytes = [out bytes];
    NSString *hash = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
    ntohl(hashBytes[0]), ntohl(hashBytes[1]), ntohl(hashBytes[2]),
    ntohl(hashBytes[3]), ntohl(hashBytes[4]), ntohl(hashBytes[5]),
    ntohl(hashBytes[6]), ntohl(hashBytes[7])];
    return hash;
}

@end
