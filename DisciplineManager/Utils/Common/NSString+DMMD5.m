//
//  NSString+LMDMD5.m
//  Doctor
//
//  Created by fujl on 2017/1/18.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import "NSString+DMMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (DMMD5)

- (NSString *)md5{
    const char* original_str=[self UTF8String];
    unsigned char digist[16]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:32];
    for(int  i =0; i<16;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

@end
