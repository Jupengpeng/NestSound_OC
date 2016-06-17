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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

 
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    NSBaseTabBarViewController *tabController = [[NSBaseTabBarViewController alloc] init];
    
    [UMSocialData setAppKey:umAppKey];
    [UMSocialWechatHandler setWXAppId:wxAppId appSecret:wxAppSecret url:nil];
    [UMSocialQQHandler setQQWithAppId:qqAppId appKey:qqAppKey url:nil];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:wbAppId  secret:wbAppKey RedirectURL:wbSecretURL];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline,UMShareToSina]];
//    [self setupUIAppearance];

    self.window.rootViewController = tabController;
    
    [self.window makeKeyAndVisible];

    //UMshare
    [UMSocialData setAppKey:umAppKey];
    [UMSocialWechatHandler setWXAppId:wxAppId appSecret:wxAppSecret url:nil];
    [UMSocialQQHandler setQQWithAppId:qqAppId appKey:qqAppKey url:nil];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:wbAppId  secret:wbAppKey RedirectURL:wbSecretURL];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline,UMShareToSina]];
    
   
    
    //UmengAnalytics
    UMConfigInstance.appKey = umAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick setLogEnabled: YES];
    
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
    }
    return  result;
}

@end
