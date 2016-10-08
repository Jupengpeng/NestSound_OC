//
//  AppDelegate.m
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//


#import "AppDelegate.h"
#import "AppDelegate+configureUIAppearance.h"
#import "NSLyricViewController.h"
#import "NSHomeViewController.h"
#import "NSDiscoverViewController.h"
#import "NSInspirationRecordViewController.h"
#import "NSUserPageViewController.h"
#import "NSUserProfileViewController.h"
#import "NSUserViewController.h"
#import "UMSocial.h"
#import "NSBaseTabBarViewController.h"
#import "NSMessageListViewController.h"
#import "NSFansViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Pingpp.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    NSBaseTabBarViewController *tabController = [[NSBaseTabBarViewController alloc] init];
    [self setupUIAppearance];
    self.window.rootViewController = tabController;
    
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
    
    //addObserver for UserHeadset
    self.session = [AVAudioSession sharedInstance];
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.session setActive:YES error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    
    AVAudioSessionRouteDescription * route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) {
        if([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]){
            self.isHeadset=YES;
        }else{
            self.isHeadset=NO;
        }
    }

    //JPush
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:JPushAPPKey channel:@"AppStore" apsForProduction:YES advertisingIdentifier:nil];
    
    [NSCheckUpgradeUtil checkUpgrade];
    
    [self.window makeKeyAndVisible];
    
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
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
//    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
// iOS 9 以上请用这个
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result) {

    }
    if (result == FALSE) {
        
    }
    return  result;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    return result;

}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHiddenTabBarTipViewNotification object:@(0)];
    NSBaseTabBarViewController *tabController = (NSBaseTabBarViewController *) [UIApplication sharedApplication].keyWindow.rootViewController;

    UINavigationController *nav = tabController.viewControllers[tabController.selectedIndex];
    NSMessageListViewController * messageListVC;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([userInfo[@"type"] isEqualToString:@"comment"]) {
        messageListVC = [[NSMessageListViewController alloc] initWithMessageType:CommentMessageType];
        messageListVC.messageListType = @"评论";
        [nav pushViewController:messageListVC animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"zan"]) {
        messageListVC = [[NSMessageListViewController alloc] initWithMessageType:UpvoteMessageType];
        messageListVC.messageListType = @"赞";
        [nav pushViewController:messageListVC animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"fov"]) {
        messageListVC = [[NSMessageListViewController alloc] initWithMessageType:CollectionMessageType];
        messageListVC.messageListType = @"收藏";
        [nav pushViewController:messageListVC animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"focus"]){
        NSFansViewController * myFansVC = [[NSFansViewController alloc] initWithUserID:JUserID _isFans:YES isWho:Myself];
        [nav pushViewController:myFansVC animated:YES];
    }
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
//推送失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark -userHeadSet
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            
            CHLog(@"Headphone/Line plugged in");
            
            self.isHeadset=YES;
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            CHLog(@"Headphone/Line was pulled. Stopping player....");
            //[self.session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            self.isHeadset=NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pausePlayer" object:nil];
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            CHLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}
// 接收到内存警告的时候调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // 停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [Pingpp handleOpenURL:url withCompletion:nil];
//}
//
// iOS 9 以上请用这个
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
//    return [Pingpp handleOpenURL:url withCompletion:nil];
//}

@end
