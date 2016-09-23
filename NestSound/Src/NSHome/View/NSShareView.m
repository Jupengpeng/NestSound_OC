//
//  NSShareView.m
//  NestSound
//
//  Created by 李龙飞 on 16/7/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSShareView.h"
#define kBtnFont [UIFont systemFontOfSize:15]

@interface NSShareView ()
@property (nonatomic, strong) NSDictionary *weixinDict;
@property (nonatomic, strong) NSDictionary *pengyouquanDict;
@property (nonatomic, strong) NSDictionary *weiboDict;
@property (nonatomic, strong) NSDictionary *QQDict;
@property (nonatomic, strong) NSDictionary *QzoneDict;
@property (nonatomic, strong) NSDictionary *fuzhiDic;
@property (nonatomic, strong) NSDictionary *lyricPoster;
@end

@implementation NSShareView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupShareViewWithType:type];
    }
    return self;
}
- (void)setupShareViewWithType:(NSString *)type {
    
    self.weixinDict                = @{@"icon": @"2.0_weChat", @"name": @"微信",@"type":UMShareToWechatSession};
    self.pengyouquanDict    = @{@"icon": @"2.0_friends", @"name": @"朋友圈",@"type":UMShareToWechatTimeline};
    self.weiboDict               = @{@"icon": @"2.0_sina", @"name": @"微博",@"type":UMShareToSina};
    self.QQDict                 = @{@"icon": @"2.0_qq", @"name": @"QQ",@"type":UMShareToQQ};
    self.QzoneDict           = @{@"icon": @"2.0_qZone", @"name": @"QQ空间",@"type":UMShareToQzone};
    self.fuzhiDic                =  @{@"icon":@"2.0_copy",@"name":@"复制链接",@"type":@"copy"};
    self.lyricPoster            = @{@"icon":@"2.0_lyricPoster",@"name":@"歌词海报",@"type":@"poster"};
    NSMutableArray *shareArr = [NSMutableArray arrayWithCapacity:1];
    
    if ([Share shareAvailableWeiXin]) {
        [shareArr addObject:_weixinDict];
        [shareArr addObject:_pengyouquanDict];
    }
    if ([Share shareAvailableSina]) {
        [shareArr addObject:_weiboDict];
    }
    if ([Share shareAvailableQQ]) {
        [shareArr addObject:_QQDict];
        [shareArr addObject:_QzoneDict];
    }
    if ([type isEqualToString:@"poster"]) {
        
    }else if ([type isEqualToString:@"yueshuo"]){
        [shareArr addObject:_fuzhiDic];
    }
    else {
        
        [shareArr addObject:_fuzhiDic];
        [shareArr addObject:_lyricPoster];
    }
    
    self.shareArr = [NSArray arrayWithArray:shareArr];
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 5; j++) {
            if (i*5+j < shareArr.count) {
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                shareBtn.frame = CGRectMake(j *((ScreenWidth-20)/5)+10, 85*i+10, (ScreenWidth-20)/5, 60);
                shareBtn.tag = 250 + i * 5 + j;
                shareBtn.titleLabel.font = kBtnFont;
                shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [shareBtn setImage:[UIImage imageNamed:shareArr[i*5+j][@"icon"]] forState:UIControlStateNormal];
//                if ([shareArr[i*5+j][@"icon"] isEqualToString:@"2.0_weChat"]) {
//                    shareBtn.tag = 111;
//                } else if ([shareArr[i*5+j][@"icon"] isEqualToString:@"2.0_friends"]) {
//                    shareBtn.tag = 222;
//                } else if ([shareArr[i*5+j][@"icon"] isEqualToString:@"2.0_sina"]) {
//                    shareBtn.tag = 333;
//                } else if ([shareArr[i*5+j][@"icon"] isEqualToString:@"2.0_qq"]) {
//                    shareBtn.tag = 444;
//                } else if ([shareArr[i*5+j][@"icon"] isEqualToString:@"2.0_qZone"]) {
//                    shareBtn.tag = 555;
//                } else if ([shareArr[i*5+j][@"icon"] isEqualToString:@"2.0_copy"]) {
//                    shareBtn.tag = 666;
//                } else if ([shareArr[i*5+j][@"icon"] isEqualToString:@"2.0_lyricPoster"]) {
//                    shareBtn.tag = 777;
//                }
                [self addSubview:shareBtn];
                
                UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(j *((ScreenWidth-20)/5)+10, 85*i+65, (ScreenWidth-20)/5, 20)];
                shareLabel.font = [UIFont systemFontOfSize:14];
                shareLabel.textAlignment = NSTextAlignmentCenter;
                shareLabel.textColor = [UIColor blackColor];
                shareLabel.text = shareArr[i*5+j][@"name"];
                [self addSubview:shareLabel];
            } else {
                break;
            }
        }
    }
}
- (void)setShareDic:(NSDictionary *)shareDic {
    
}

@end
