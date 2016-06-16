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
    UIButton * playBtn;

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
//    UIBlurEffect * efffct = [[UIBlurEffect alloc] init];
//    
//    UIVisualEffectView * effct = [[UIVisualEffectView alloc] initWithEffect:efffct];
    
    [self addSubview:backImage];
//    [self addSubview:effct];
    
    //titlepage
    titlePage = [[UIImageView alloc] init];
    
    [self addSubview:titlePage];
    
    //songlistype
    songListType = [[UILabel alloc] init];
    songListType.font = [UIFont systemFontOfSize:15];
    songListType.textColor = [UIColor blackColor];
    [self addSubview:songListType];
    
    //songListName
    songListName = [[UILabel alloc] init];
    songListName.font = [UIFont systemFontOfSize:15];
    songListName.textColor = [UIColor blackColor];
    [self addSubview:songListName];
    
    //playAllLab
    playAll = [[UILabel alloc] init];
    playAll.font = [UIFont systemFontOfSize:15];
    playAll.textColor = [UIColor blackColor];
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
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.adjustsImageWhenHighlighted = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        if (!wSelf) {
            return ;
        }
        
    }];
    playBtn.layer.masksToBounds = YES;
    [self addSubview:playBtn];

}


-(void)layoutSubviews
{
    
    [super layoutSubviews];
    //constains
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
        make.top.equalTo(songListType.mas_bottom);
        make.height.mas_equalTo(16);
    }];
    
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(songListName.mas_left);
        make.bottom.equalTo(titlePage.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [playAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playBtn.mas_centerY);
        make.left.equalTo(playBtn.mas_right).with.offset(10);
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
#warning placeHolderImage
    
    [titlePage setDDImageWithURLString:_singListType.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_accompany_highlighted"]];
    [backImage setDDImageWithURLString:_singListType.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_accompany_highlighted"]];
    songListName.text = _singListType.detail;
    songListType.text = _singListType.title;
    
}

@end
