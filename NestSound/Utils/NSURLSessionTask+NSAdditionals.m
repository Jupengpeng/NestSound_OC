//
//  AFHTTPRequestOperation+additionals.m
//  FramePackage
//
//  Created by yandi on 15/10/14.
//  Copyright © 2015年 yinchao. All rights reserved.
//

#import "NSURLSessionTask+NSAdditionals.h"

@implementation NSURLSessionTask (NSAdditionals)
static char *operationUrlTag;
static char *operationLoadingMoreTag;

- (void)setUrlTag:(NSString *)urlTag {
    
    objc_setAssociatedObject(self, &operationUrlTag, urlTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)urlTag {
    
    return objc_getAssociatedObject(self, &operationUrlTag);
}

- (void)setIsLoadingMore:(BOOL)isLoadingMore {
    
    objc_setAssociatedObject(self, &operationLoadingMoreTag, @(isLoadingMore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLoadingMore {
    
    return [objc_getAssociatedObject(self, &operationLoadingMoreTag) boolValue];
}
@end
