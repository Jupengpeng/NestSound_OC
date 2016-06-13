//
//  IMHttpClient.h
//  iMei
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef enum {
    GetRequest = 1,
    PostRuest = 0
}requestType;

@interface NSHttpClient : AFHTTPSessionManager;



+ (instancetype)client;
+ (NSString *)actionCustomUsrAgent;
- (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                    type:(BOOL)requestType
                                   paras:(NSDictionary *)parasDict
                                 success:(void(^)(NSURLSessionDataTask *operation,NSObject *parserObject))success
                                 failure:(void(^)(NSURLSessionDataTask *operation,NSError *requestErr))failure;

-(void)downLoadWithFileURL:(NSString *)fileURL;
@end
