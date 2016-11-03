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
#import <Bugly/Bugly.h>
@interface AppDelegate ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *FirstLaunchView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *page;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *ImgArray;
@end

@implementation AppDelegate

- (NSArray *)ImgArray {
    if (!_ImgArray) {
        self.ImgArray = @[@"first_introduce", @"second_introduce", @"third_introduce", @"fourth_introduce"];
    }
    return _ImgArray;
}

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
    BuglyConfig *config = [[BuglyConfig alloc] init];
//    config.debugMode = YES;
    config.channel =  [[UIDevice currentDevice] name];
    [Bugly startWithAppId:@"7eb2056e59" config:config];
//    [Bugly startWithAppId:@"7eb2056e59"];
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
    
    //用户引导页
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"FirstLoad"] == nil) {
        [userDefaults setBool:NO forKey:@"FirstLoad"];
        [self layoutLaunchView];
    }
    
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
- (void)layoutLaunchView {
    //布局首次登陆视图
    self.FirstLaunchView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _FirstLaunchView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.FirstLaunchView];
    //布局滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize = CGSizeMake(ScreenWidth * self.ImgArray.count, ScreenHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.FirstLaunchView addSubview:_scrollView];
    //布局图片
    for (int i = 0; i < self.ImgArray.count; i++) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight)];
        _imageView.image = [UIImage imageNamed:self.ImgArray[i]];
        [self.scrollView addSubview:_imageView];
        if (i == self.ImgArray.count-1) {
            //布局进入按钮
            _imageView.userInteractionEnabled = YES;
            UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            enterBtn.frame = CGRectMake((ScreenWidth - 120), 30, 100, 35);
            [enterBtn setBackgroundImage:[UIImage imageNamed:@"enter_btn"] forState:UIControlStateNormal];
//            enterBtn.layer.cornerRadius = 5;
//            enterBtn.layer.borderWidth = 0.5;
//            enterBtn.layer.borderColor = [[UIColor hexColorFloat:@"ffd705"] CGColor];
//            [enterBtn setTitle:@"进入应用" forState:UIControlStateNormal];
//            [enterBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [enterBtn addTarget:self action:@selector(handleEnter:) forControlEvents:UIControlEventTouchUpInside];
            [_imageView addSubview:enterBtn];
        }
    }
    //布局分页索引
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake((ScreenWidth - 80) / 2, ScreenHeight - 60, 80, 40)];
    _page.numberOfPages = self.ImgArray.count;
    
    _page.currentPageIndicatorTintColor = [UIColor colorWithRed:161.0/255 green:149.0/255 blue:132.0/255 alpha:1.0];
    _page.pageIndicatorTintColor = [UIColor whiteColor];
//    [_page addTarget:self action:@selector(handlePage) forControlEvents:UIControlEventValueChanged];
    [self.FirstLaunchView addSubview:_page];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.page.currentPage = scrollView.contentOffset.x / ScreenWidth;
}
- (void)handleEnter:(UIButton *)sender {
    //翻页动画
    //    [UIView transitionFromView:self. toView:self.window duration:1 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished) {
    //        [self.FirstLaunchView removeFromSuperview];
    //改变指针指向
    //        UIView *tempView = [self.animationView retain];
    //        self.animationView = self.greenView;
    //        self.greenView = tempView;
    //    }];
//        [UIView beginAnimations:@"curlUp" context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//指定动画曲线类型，该枚举是默认的，线性的是匀速的
//        [UIView setAnimationDuration:1];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.FirstLaunchView cache:NO];
//        [UIView setAnimationDidStopSelector:@selector(handleDidStop)];
//        [UIView commitAnimations];
    
//    [self.FirstLaunchView removeFromSuperview];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:1.5];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[UIApplication sharedApplication].keyWindow cache:YES];
//    [UIView commitAnimations];
//    缩放动画
//        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.FirstLaunchView.transform = CGAffineTransformScale(self.imageView.transform, 0.1, 0.1);
//        } completion:^(BOOL finished) {
            [self.FirstLaunchView removeFromSuperview];
//        }];
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
    if ([url.absoluteString containsString:@"pay"]) {
        return [Pingpp handleOpenURL:url withCompletion:nil];
        
    }else if([url.absoluteString containsString:@"response_from_qq"]){
        return [QQApiInterface handleOpenURL:url delegate:nil];
    }else
    {
        BOOL result = [UMSocialSnsService handleOpenURL:url];
        return result;
    }
    
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.absoluteString containsString:@"pay"]) {
        return [Pingpp handleOpenURL:url withCompletion:nil];
        
    }else
    {
        BOOL result = [UMSocialSnsService handleOpenURL:url];
        return result;
    }
    

}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    [self setupRemoteNotificationWith:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    [self setupRemoteNotificationWith:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

}

- (void)setupRemoteNotificationWith:(NSDictionary *)userInfo{
    
    if (!([UIApplication sharedApplication].applicationState == UIApplicationStateActive)) {
        [self processCommentJumpActionWithUserInfo:userInfo];
        
    }else{
//        NSString *title = @"通知";
//        NSString *message = @"您的作品收到新的评论";
//        NSString *cancelButtonTitle = @"知道了";
//        NSString *otherButtonTitle = @"前往";
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//        
//        // Create the actions.
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            
//        }];
//        
//        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self processCommentJumpActionWithUserInfo:userInfo];
//        }];
//        
//        // Add the actions.
//        [alertController addAction:cancelAction];
//        [alertController addAction:otherAction];
//        
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHiddenTabBarTipViewNotification object:@(0)];
//        NSBaseTabBarViewController *tabController = (NSBaseTabBarViewController *) [UIApplication sharedApplication].keyWindow.rootViewController;
//        UINavigationController *nav = tabController.viewControllers[tabController.selectedIndex];
//        [nav presentViewController:alertController animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage" object:nil];
        return;
    }
}

- (void)processCommentJumpActionWithUserInfo:(NSDictionary *)userInfo{
    
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
