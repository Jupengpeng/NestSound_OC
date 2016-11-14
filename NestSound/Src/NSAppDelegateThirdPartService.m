//
//  NSAppDelegateThirdPartService.m
//  NestSound
//
//  Created by yinchao on 2016/11/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAppDelegateThirdPartService.h"
#import "NSLyricViewController.h"
#import "UMSocial.h"
#import <AVFoundation/AVFoundation.h>
#import "Pingpp.h"
#import <Bugly/Bugly.h>
@interface NSAppDelegateThirdPartService ()<UIScrollViewDelegate>
@end

@implementation NSAppDelegateThirdPartService

+ (void)load {
    
    //UMshare
    [UMSocialData setAppKey:umAppKey];
    
    [UMSocialWechatHandler setWXAppId:wxAppId appSecret:wxAppSecret url:nil];
    [UMSocialQQHandler setQQWithAppId:qqAppId appKey:qqAppKey url:@"http://www.yinchao.cn"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:wbAppId  secret:wbAppKey RedirectURL:wbSecretURL];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline,UMShareToSina]];
    
    
    //UmengAnalytics
    UMConfigInstance.appKey = umAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled: YES];
    
    //Bugly
    BuglyConfig *config = [[BuglyConfig alloc] init];
    //    config.debugMode = YES;
    config.channel =  [[UIDevice currentDevice] name];
    [Bugly startWithAppId:@"7eb2056e59" config:config];
    //    [Bugly startWithAppId:@"7eb2056e59"];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier taskId;
    
    taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        
        CHLog(@"后台任务超时被退出");
        [app endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }];
    
    if(taskId == UIBackgroundTaskInvalid)
        
    {
        CHLog(@"开启后台任务失败");
    }
    
    CHLog(@"remining seconde %f",[app backgroundTimeRemaining]);
    
    [NSCheckUpgradeUtil checkUpgrade];
    
    
}

@end
