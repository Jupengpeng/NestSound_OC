//
//  NSSongListHeaderView.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongListHeaderView.h"
#import "NSSingListModel.h"
@interface NSSongListHeaderView ()
{

    UIImageView * backImage;
    UIImageView * titlePage;
    UILabel * songListType;
    UILabel * songListName;
    UILabel * playAll;
    UILabel * songCount;
    UIVisualEffectView * effct;

}
@end

@implementation NSSongListHeaderView


-(instancetype)init
{
    if (self = [super init]) {
        [self configureUIAperance];

    }
    
        return self;

}


#pragma mark configureUIAperance
-(void)configureUIAperance
{
    self.backgroundColor = [UIColor whiteColor];
    //backimage
    backImage = [[UIImageView alloc] init];
//    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
     effct = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effct.alpha = 0.9;
    [backImage addSubview:effct];
    
    [self addSubview:backImage];
    
    //titlepage
    titlePage = [[UIImageView alloc] init];
    
    [self addSubview:titlePage];
    
    //songlistype
    songListType = [[UILabel alloc] init];
    songListType.font = [UIFont systemFontOfSize:15];
    songListType.textColor = [UIColor whiteColor];
    [self addSubview:songListType];
    
    //songListName
    songListName = [[UILabel alloc] init];
    songListName.font = [UIFont systemFontOfSize:15];
    songListName.numberOfLines = 0;
    songListName.textColor = [UIColor whiteColor];
    [self addSubview:songListName];
    
    //playAllLab
    playAll = [[UILabel alloc] init];
    playAll.font = [UIFont systemFontOfSize:15];
    playAll.textColor = [UIColor whiteColor];
    playAll.text = @"播放全部";
//    LocalizedStr(@"promot_play_all");
    
    [self addSubview:playAll];
    
    //songCount
    songCount = [[UILabel alloc] init];
    songCount.font = [UIFont systemFontOfSize:12];
    songCount.textColor = [UIColor blackColor];
    [self addSubview:songCount];
    
    WS(wSelf);
    
    //playbtn
    self.playAllBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.adjustsImageWhenHighlighted = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"2.0_gedan_stopBtn"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        if (!wSelf) {
            return ;
        }
        
    }];
    self.playAllBtn.layer.masksToBounds = YES;
    [self addSubview:self.playAllBtn];

}


-(void)layoutSubviews
{
    
    [super layoutSubviews];
    //constains
    //backImage
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    //effect
    [effct mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(backImage);
    }];
    
    [titlePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.height.mas_equalTo(150);
        make.width.mas_equalTo(150);
        
    }];
    
    [songListType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(7);
        make.left.equalTo(titlePage.mas_right).with.offset(14);
        make.height.mas_equalTo(16);
        
    }];
    
    
    [songListName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(songListType.mas_left);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(songListType.mas_bottom).offset(10);
//        make.height.mas_equalTo(16);
    }];
    
    [self.playAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(songListName.mas_left);
        make.bottom.equalTo(titlePage.mas_bottom).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [playAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playAllBtn.mas_centerY);
        make.left.equalTo(self.playAllBtn.mas_right).with.offset(20);
        make.width.mas_equalTo(65);
            }];
    
    [songCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playAll.mas_centerY);
        make.left.equalTo(playAll.mas_right).with.offset(10);
        make.height.mas_equalTo(12);
    }];
    
}

#pragma mark - setter && getter
-(void)setSingListType:(singListModel *)singListType
{
    _singListType = singListType;    
    [titlePage setDDImageWithURLString:_singListType.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    [backImage setDDImageWithURLString:_singListType.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    songListName.text = _singListType.detail;
    songListType.text = [NSString stringWithFormat:@"[%@]",_singListType.title];
    
}

@end
