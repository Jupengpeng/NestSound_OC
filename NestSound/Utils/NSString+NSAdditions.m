//
//  NSString+NSAdditions.m
//  YueDong
//
//  Created by yandi on 15/11/4.
//  Copyright © 2015年 yinchao All rights reserved.
//

#import "NSString+NSAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSAdditions)

#pragma mark -md5
- (NSString *)md5{
    if (self == nil || self.length == 0) {
        return nil;
    }
    
    const char *value = self.UTF8String;
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *md5String = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [md5String appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return md5String;
}
@end
