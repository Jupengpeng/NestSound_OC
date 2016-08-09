//
//  NSCheckUpgradeUtil.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCheckUpgradeUtil.h"
#define APP_ID @"1056101413"
@implementation NSCheckUpgradeUtil
//检查更新
+(void)checkUpgrade{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APP_ID];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger resultCount = [[responseObject objectForKey:@"resultCount"] integerValue];
        if(resultCount != 0){
            NSString *appstoreVersion = [[responseObject objectForKey:@"results"][0] objectForKey:@"version"];
            if(appstoreVersion != nil){
                NSString *localVersion = [self getCurrentAppVersion];
                NSLog(@"latest app version %@ ; localVersion:%@",appstoreVersion,localVersion);
                NSInteger local = [[localVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
                NSInteger appstore = [[appstoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
                if(local < appstore){
                    [UIAlertView showWithTitle:@"版本更新提示" message:@"发现新版本,是否确定要更新?" cancelBtnTitle:@"取消" click:^(NSString *clickBtnTitle) {
                        NSString *appurl = [[responseObject objectForKey:@"results"][0] objectForKey:@"trackViewUrl"];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appurl]];
                    } otherBtnTitles:@"更新", nil];
//                    [UIAlertView displayAlertWithTitle:@"版本更新提示" message:@"发现新版本,是否确定要更新？" leftButtonTitle:@"取消" leftButtonAction:nil rightButtonTitle:@"更新" rightButtonAction:^(){
//                        NSString *appurl = [[responseObject objectForKey:@"results"][0] objectForKey:@"trackViewUrl"];
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appurl]];
//                    }];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ----%@",error.userInfo);
    }];
}

+ (NSString *)getCurrentAppVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return version;
}
@end
