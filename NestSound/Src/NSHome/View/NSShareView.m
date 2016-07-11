//
//  NSShareView.m
//  NestSound
//
//  Created by 李龙飞 on 16/7/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSShareView.h"
#define kBtnFont [UIFont systemFontOfSize:15]
@implementation NSShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupShareView];
    }
    return self;
}
- (void)setupShareView {
    NSMutableArray *titarray = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"微博",@"QQ",@"QQ空间",@"复制链接", nil];
    NSMutableArray *picarray = [NSMutableArray arrayWithObjects:@"2.0_weChat",@"2.0_friends",@"2.0_sina",@"2.0_qq",@"2.0_qZone",@"2.0_copy", nil];
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 5; j++) {
            if (i*5+j < picarray.count) {
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                shareBtn.frame = CGRectMake(j *((ScreenWidth-20)/5)+10, 80*i+10, (ScreenWidth-20)/5, 80);
                shareBtn.tag = 10 + i + j;
                shareBtn.titleLabel.font = kBtnFont;
                shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//                shareBtn.titleLabel.contentMode = UIViewContentModeCenter;
                [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [shareBtn setImage:[UIImage imageNamed:picarray[i*5+j]] forState:UIControlStateNormal];
                [shareBtn setTitle:titarray[i*5+j] forState:UIControlStateNormal];
                shareBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -shareBtn.imageView.frame.size.width-5 , -shareBtn.imageView.frame.size.width-5, 0);
                shareBtn.imageEdgeInsets=UIEdgeInsetsMake(-shareBtn.titleLabel.frame.size.height, 5, 0, 0);
                [shareBtn addTarget:self action:@selector(handleShareBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:shareBtn];
                
            } else {
                break;
            }
        }
    }
}
- (void)setShareDic:(NSDictionary *)shareDic {
    
}
- (void)handleShareBtn:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"微信"]) {
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.shareDataDic[@"desc"] image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
        
    }
    
    if ([sender.currentTitle isEqualToString:@"朋友圈"]) {
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareDataDic[@"desc"] image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
    }
    
    if ([sender.currentTitle isEqualToString:@"微博"]) {
//        [UMSocialData defaultData].extConfig.sinaData.urlResource = urlResource;
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:self.shareDataDic[@"desc"] image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
    }
    if ([sender.currentTitle isEqualToString:@"QQ"]) {
//        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:self.shareDataDic[@"desc"] image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
    }
    if ([sender.currentTitle isEqualToString:@"QQ空间"]) {
        
//        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:self.shareDataDic[@"desc"] image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
    }
}
@end
