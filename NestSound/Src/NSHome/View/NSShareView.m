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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupShareView];
    }
    return self;
}
- (void)setupShareView {
    self.weixinDict                = @{@"icon": @"2.0_weChat", @"name": @"微信"};
    self.pengyouquanDict    = @{@"icon": @"2.0_friends", @"name": @"朋友圈"};
    self.weiboDict               = @{@"icon": @"2.0_sina", @"name": @"微博"};
    self.QQDict                 = @{@"icon": @"2.0_qq", @"name": @"QQ"};
    self.QzoneDict           = @{@"icon": @"2.0_qZone", @"name": @"QQ空间"};
    self.fuzhiDic                =  @{@"icon":@"2.0_copy",@"name":@"复制链接"};
    self.lyricPoster            = @{@"icon":@"2.0_lyricPoster",@"name":@"歌词海报"};
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
    [shareArr addObject:_fuzhiDic];
//    [shareArr addObject:_lyricPoster];
    
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
                [self addSubview:shareBtn];
                
                UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(j *((ScreenWidth-20)/5)+10, 85*i+65, (ScreenWidth-20)/5, 20)];
                shareLabel.font = [UIFont systemFontOfSize:15];
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
