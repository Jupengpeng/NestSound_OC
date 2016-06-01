
//
//  IMHttpClient.m
//  iMei
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSHttpClient.h"
#import "NSModelFactory.h"
#import "NSToastManager.h"

@implementation NSHttpClient
static NSHttpClient *client;

#pragma mark - client
+ (instancetype)client {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [NSHttpClient manager];
    });
    return client;
}

#pragma mark + actionCistomUsrAgent
+ (NSString *)actionCustomUsrAgent {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *app_ver = [mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build_ver = [mainBundle.infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSString *channel = ([build_ver intValue] % 2) ? @"YinChaoTech" : @"appStore";
    
    NSString *userId = @"";
    //NSString *currentUserId = [DDUser user].userId;
    NSString *currentUserId = @"";
    if (currentUserId) {
        userId = [NSString stringWithFormat:@"UID/%d ",currentUserId.intValue];
    }
    
    NSString *deviceName = @"iPhone";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        deviceName = @"iPad";
    }
    return [NSString stringWithFormat:@"( NestSound; Client/%@%@ V/%@|%@ channel/%@ %@)"
            ,deviceName ,[UIDevice currentDevice].systemVersion , build_ver, app_ver, channel, userId];
}

#pragma mark -override initWithBaseURL
- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self  = [super initWithBaseURL:url]) {
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = 20;
        [self.requestSerializer setValue:[self.class actionCustomUsrAgent] forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

#pragma mark - responseObject
- (void)responseObject:(NSObject *)obj  withOperation:(NSURLSessionDataTask *)operation {

}

#pragma mark - requestWithURL ...
- (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                   
                                   
                                     paras:(NSDictionary *)parasDict
                                   success:(void(^)(NSURLSessionDataTask *operation,NSObject *parserObject))success
                                   failure:(void(^)(NSURLSessionDataTask *operation,NSError *requestErr))failure {
    
    NSMutableDictionary *transferParas = [parasDict mutableCopy];
    
    // Loading
    BOOL showLoading = ![[transferParas objectForKey:kNoLoading] boolValue];
    [transferParas removeObjectForKey:kNoLoading];
    if (showLoading) {
        
        // show hud
        [[NSToastManager manager] showprogress];
    }

    // refresh or LoadingMore
    BOOL isLoadingMore = [[transferParas objectForKey:kIsLoadingMore] boolValue];
    [transferParas removeObjectForKey:kIsLoadingMore];
    
    WS(wSelf);
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",[NSTool obtainHostURL],url];
    NSURLSessionDataTask *operation;
    
    NSString * uuu;
    __block NSString * u = uuu;
    if (1) {
        operation = [self GET: url
                   parameters:[self encryptWithDictionary:parasDict isEncrypt:YES]
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                          
                          //hide toast
                          if (showLoading) {
                              
                              [[NSToastManager manager] hideprogress];
                          }
#ifdef DEBUG
                          NSLog(@"RESPONSE JSON:%@", responseObject);
#endif
                          
                          if (!success) {
                              return ;
                          }
                          
                          if ([responseObject isKindOfClass:[NSDictionary class]]) {
                             
                           NSDictionary * dic =  [self encryptWithDictionary:responseObject isEncrypt:NO];
                             
                              NSLog(@"dic;%@",dic);
                              NSInteger i = [requestURL rangeOfString:@"data="].location;
                              
                              NSString * str = [requestURL substringWithRange:NSMakeRange(32, i-32)];

                              NSLog(@"str%@",str);
                             
                              NSBaseModel *model = [NSModelFactory modelWithURL:str
                                                                   responseJson:dic];
                              success(task,model);
                              
                              if (!model.success) {
                                  [[NSToastManager manager] showtoast:[responseObject objectForKey:@"message"]];
                              }
                          } else {
                              success(task,responseObject);
                          }
                          if (!wSelf) {
                              return ;
                          }
                          
                          [wSelf responseObject:responseObject withOperation:task];
                          
                      } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                          
                          if (showLoading) {
                              [[NSToastManager manager] hideprogress];
                          }
                          if (!failure) {
                              return ;
                          }
                          failure(task,error);
                      }];
        
    }else{
    
    
    operation = [self POST:url
                                      parameters:[self encryptWithDictionary:parasDict isEncrypt:YES]
                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                           
                                             //hide toast
                                             if (showLoading) {
                                                 
                                                 [[NSToastManager manager] hideprogress];
                                             }
#ifdef DEBUG
                                             NSLog(@"RESPONSE JSON:%@", responseObject);
#endif
                           
                                             if (!success) {
                                                 return ;
                                             }
                                             
                                             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                 NSBaseModel *model = [NSModelFactory modelWithURL:indexURL
                                                                    responseJson:[self encryptWithDictionary:responseObject isEncrypt:NO]];
                                                 success(task,model);
                                                 
                                                 if (!model.success) {
                                                     [[NSToastManager manager] showtoast:[responseObject objectForKey:@"message"]];
                                                 }
                                             } else {
                                                 success(task,responseObject);
                                             }
                                             if (!wSelf) {
                                                 return ;
                                             }
                           
                                             [wSelf responseObject:responseObject withOperation:task];
                           
                                         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                           
                                             if (showLoading) {
                                                 [[NSToastManager manager] hideprogress];
                                             }
                                             if (!failure) {
                                                 return ;
                                             }
                                             failure(task,error);
                                         }];
    }
    operation.urlTag = url;
    operation.isLoadingMore = isLoadingMore;
    
    return operation;
}


@end
