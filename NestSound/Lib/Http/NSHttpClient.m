
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
        self.requestSerializer.timeoutInterval = 90;
        [self.requestSerializer setValue:[self.class actionCustomUsrAgent] forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

#pragma mark - responseObject
- (void)responseObject:(NSObject *)obj  withOperation:(NSURLSessionDataTask *)operation {

}




#pragma mark - requestWithURL ...
- (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                    type:(BOOL)requestType
                                     paras:(NSDictionary *)parasDict
                                   success:(void(^)(NSURLSessionDataTask *operation,NSObject *parserObject))success
                                   failure:(void(^)(NSURLSessionDataTask *operation,NSError *requestErr))failure {
    
    NSMutableDictionary *transferParas = [parasDict mutableCopy];
    CHLog(@"paraDisct%@",parasDict);
    // Loading
    BOOL showLoading = ![[transferParas objectForKey:kNoLoading] boolValue];
    [transferParas removeObjectForKey:kNoLoading];
    if (showLoading) {
        
        // show hud
//        [[NSToastManager manager] showprogress];
    }

    BOOL isLoadingMore = [[transferParas objectForKey:kIsLoadingMore] boolValue];
    [transferParas removeObjectForKey:kIsLoadingMore];
    
    WS(wSelf);
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",[NSTool obtainHostURL],url];
    NSLog(@"requestURL ---  %@",requestURL);
    NSURLSessionDataTask *operation;
    
    if (requestType) {
        operation = [self GET: requestURL
                   parameters:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                          
                          //hide toast
                          if (showLoading) {
                              
                              //                              [[NSToastManager manager] hideprogress];
                          }
                          CHLog(@"RESPONSE JSON:%@", responseObject);
                          
                          //                          if (!success) {
                          //                              return ;
                          //                          }
                          
                          if ([responseObject isKindOfClass:[NSDictionary class]]) {
                              
                              NSDictionary * dic =  [self encryptWithDictionary:responseObject isEncrypt:NO];
                              
                              NSInteger i = [url rangeOfString:@"data="].location;
                              
                              NSString * str = [url substringWithRange:NSMakeRange(0, i)];
                              
                              NSBaseModel *model = [NSModelFactory modelWithURL:str
                                                                   responseJson:dic];
                              success(task,model);
                              
                              if (!model.success) {
                                  NSString *message = [responseObject objectForKey:@"message"];
                                  if (![message isEqualToString:@"操作成功"]) {
                                      [[NSToastManager manager] showtoast:message];
                                  }
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
        
        operation = [self POST:requestURL
                    parameters:[self encryptWithDictionary:@{@"data":parasDict} isEncrypt:YES]
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                           
                           //hide toast
                           if (showLoading) {
                               
                               [[NSToastManager manager] hideprogress];
                           }
                           CHLog(@"RESPONSE JSON:%@", responseObject);
                           if (!success) {
                               return ;
                           }
                           
                           if ([responseObject isKindOfClass:[NSDictionary class]]) {
                               NSBaseModel *model = [NSModelFactory modelWithURL:url
                                                                    responseJson:[self encryptWithDictionary:responseObject isEncrypt:NO]];
                               
                               success(task,model);
                               
                               long resultCode = [responseObject[@"code"] longValue];
                               
                               if (resultCode == 200) {
                                   
                                   model.success = YES;
                               }
                               
                               if (!model.success) {
                                   NSString *message = [responseObject objectForKey:@"message"];
                                   if (![message isEqualToString:@"操作成功"]) {
                                       [[NSToastManager manager] showtoast:message];
                                   }                               }
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


#pragma  mark -downLoadWithFIleURL
-(void)downLoadWithFileURL:(NSString *)fileURL completionHandler:(void(^)())completion
{
    NSURLSessionConfiguration*sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.downloadManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:sessionConfiguration];
    
    NSURLRequest*request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileURL]];
    NSProgress *kProgress = nil;
    NSURLSessionDownloadTask *downloadTask = [self.downloadManager downloadTaskWithRequest:request progress:&kProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response){
        
        NSString * filePath = [LocalAccompanyPath stringByAppendingPathComponent:response.suggestedFilename];
        NSURL * url = [NSURL fileURLWithPath:filePath];
        
        return url;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        CHLog(@"File downloaded to: %@,%@", filePath, error);
        [kProgress removeObserver:self forKeyPath:@"fractionComplete"];
        
    }];
    [self.downloadManager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        self.progress = (CGFloat)kProgress.completedUnitCount/kProgress.totalUnitCount;
        if ([self.delegate respondsToSelector:@selector(passProgressValue:)]) {
            [self.delegate passProgressValue:[NSHttpClient client]];
        }
        if (kProgress.completedUnitCount/kProgress.totalUnitCount == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
        CHLog(@"总大小：%lld,当前大小:%lld",kProgress.totalUnitCount,kProgress.completedUnitCount);
    }];
    [kProgress addObserver:self
                forKeyPath:@"fractionComplete"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
    [downloadTask resume];
}
- (void)cancelDownload {
    
    [self.downloadManager invalidateSessionCancelingTasks:YES];
}
- (void)cancelRequest {
//    [self invalidateSessionCancelingTasks:YES];
//    [[NSHttpClient client].operationQueue cancelAllOperations];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    [manager.operationQueue cancelAllOperations];
    
    
}
- (void)requestCallBackWithTask:(id)currentTask target:(id)target withBackCall:(NSString*)call
{
    SEL selector = NSSelectorFromString(call);
    ((void (*)(id, SEL,id))[target methodForSelector:selector])(target, selector,currentTask);
}
@end
