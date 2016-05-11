//
//  XiangQuToastManager.m
//  XiangQu
//
//  Created by yandi on 14/10/29.
//  Copyright (c) 2014年 yinchao. All rights reserved.
//

#import "MBProgressHUD.h"
#import "NSToastManager.h"

#define minshowtime   .5
#define progesswidth  5.
#define rotationspeed 2
#define customcenter  CGPointMake(22.5, 22.5)

@interface NSToastManager () {
    
    MBProgressHUD *toastHud;
    MBProgressHUD *progressHud;
}
@end

@implementation NSToastManager
static NSToastManager *toastManager;

#pragma mark -manager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toastManager = [[NSToastManager alloc] init];
        [toastManager actionRenderUIComponents];
    });
    return toastManager;
}

#pragma mark -keyWindow
+ (UIWindow *)keyWindow {
    AppDelegate *delegate = [NSTool appDelegate];
    UIWindow *keywindow = delegate.window;
    
    return keywindow;
}

#pragma mark -actionRenderUIComponents
- (void)actionRenderUIComponents {
    UIWindow *keywindow = [NSToastManager keyWindow];
    
    toastHud = [[MBProgressHUD alloc] initWithWindow:keywindow];
    toastHud.userInteractionEnabled = NO;
    toastHud.mode = MBProgressHUDModeText;
    toastHud.minShowTime = minshowtime*2;
    [keywindow addSubview:toastHud];
    
    progressHud = [[MBProgressHUD alloc] initWithWindow:keywindow];
    progressHud.animationType = MBProgressHUDAnimationFade;
    progressHud.mode = MBProgressHUDModeCustomView;
    progressHud.bounds = CGRectMake(0, 0, 80, 80);
    progressHud.userInteractionEnabled = NO;
    progressHud.minShowTime = minshowtime;
    progressHud.square = YES;
    [keywindow addSubview:progressHud];
}

#pragma mark -toast
- (void)showtoast:(NSString *)toastStr {
    
    if (![NSTool isStringEmpty:toastStr]) {
        if (toastStr.length > 15) {
            toastHud.labelText = @"";
            toastHud.detailsLabelText = toastStr;
        } else {
            toastHud.labelText = toastStr;
            toastHud.detailsLabelText = @"";
        }
        [[NSToastManager keyWindow] bringSubviewToFront:toastHud];
        [toastHud show:YES];
        [toastHud hide:YES];
    }
}

#pragma mark -progress
- (void)hideprogress {
    
    [progressHud hide:YES];
}

- (void)showprogress {
    
    [[NSToastManager keyWindow] bringSubviewToFront:progressHud];
    [progressHud show:YES];
}
@end
