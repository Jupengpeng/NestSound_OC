//
//  HudView.m
//  NestSound
//
//  Created by yintao on 16/7/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "HudView.h"
#import "MBProgressHUD.h"

@implementation HudView
+ (void)showView:(UIView*)view string:(NSString*)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    
    // Move to bottm center.
    //hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    hud.centerY=view.height/6*5;
    [hud hideAnimated:YES afterDelay:1.f];

}
@end
