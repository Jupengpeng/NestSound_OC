//
//  NSNewMusicTableViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSNewMusicTableViewCell.h"

@interface NSNewMusicTableViewCell ()

//播放按钮
@property (nonatomic, strong) UIButton *playBtn;

//歌曲名
@property (nonatomic, strong) UILabel *musicName;

//作者名
@property (nonatomic, strong) UILabel *authorName;

//日期
@property (nonatomic, strong) UILabel *dateLabel;

//多少人听过
@property (nonatomic, strong) UIImageView *heardIcon;

@property (nonatomic, strong) UILabel *heardLabel;

//多少收藏
@property (nonatomic, strong) UIImageView *collectionIcon;

@property (nonatomic, strong) UILabel *collectionLabel;

//多少点赞
@property (nonatomic, strong) UIImageView *upVoteIcon;

@property (nonatomic, strong) UILabel *upVoteLabel;

@end

@implementation NSNewMusicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    
    self.numLabel = [[UILabel alloc] init];
    
//    self.numLabel.minimumFontSize = 12;
    
//    self.numLabel.adjustsFontSizeToFitWidth = YES;
    
    self.numLabel.font = [UIFont systemFontOfSize:12];
    
    self.numLabel.textColor = [UIColor blackColor];
    
    [self.contentView addSubview:self.numLabel];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        
        make.left.equalTo(self.mas_left).offset(15);
        
        make.width.mas_equalTo(25);
        
    }];
    
    UIView *backgroundView = [[UIView alloc] init];
    
    backgroundView.backgroundColor = [UIColor hexColorFloat:@"f0f0f0"];
    
    [self.contentView addSubview:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.numLabel.mas_right).offset(5);
        
        make.right.equalTo(self.mas_right).offset(-15);
        
        make.top.bottom.equalTo(self);
        
    }];
    
    //头像和播放
#warning mark 可能不需要播放 button会换成image
    
    self.playBtn = [[UIButton alloc] init];
    
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"img_01"] forState:UIControlStateNormal];
    
    [backgroundView addSubview:self.playBtn];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(backgroundView.mas_left);
        
        make.top.bottom.equalTo(backgroundView);
        
        make.width.mas_equalTo(70);
        
    }];
    
    //日期
    self.dateLabel = [[UILabel alloc] init];
    
    self.dateLabel.textColor = [UIColor hexColorFloat:@"a0a0a0"];
    
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    
    self.dateLabel.text = @"2016-05-8";
    
    [backgroundView addSubview:self.dateLabel];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(backgroundView.mas_top).offset(10);
        
        make.right.equalTo(backgroundView.mas_right).offset(-10);
        
    }];
    
    //歌名
    self.musicName = [[UILabel alloc] init];
    
    self.musicName.font = [UIFont systemFontOfSize:14];
    
    self.musicName.text = @"悟空悟空悟空悟空悟";
    
    [backgroundView addSubview:self.musicName];
    
    [self.musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        
        make.right.equalTo(self.dateLabel.mas_left);
        
        make.centerY.equalTo(self.dateLabel.mas_centerY);
        
    }];
    
    //作者名
    self.authorName = [[UILabel alloc] init];
    
    self.authorName.text = @"戴荃";
    
    self.authorName.font = [UIFont systemFontOfSize:10];
    
    self.authorName.textColor = [UIColor hexColorFloat:@"727272"];
    
    [backgroundView addSubview:self.authorName];
    
    [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        
        make.top.equalTo(self.musicName.mas_bottom).offset(5);
        
    }];
    
    //听过
    self.heardIcon = [[UIImageView alloc] init];
    
    self.heardIcon.image = [UIImage imageNamed:@"2.0_hear"];
    
    [backgroundView addSubview:self.heardIcon];
    
    [self.heardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-5);
        
    }];
    
    self.heardLabel = [[UILabel alloc] init];
    
    self.heardLabel.text = @"1200";
    
    self.heardLabel.font = [UIFont systemFontOfSize:10];
    
    self.heardLabel.textColor = [UIColor hexColorFloat:@"999999"];
    
    [backgroundView addSubview:self.heardLabel];
    
    [self.heardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.heardIcon.mas_right).offset(5);
        
        make.centerY.equalTo(self.heardIcon.mas_centerY);
        
    }];
    
    //收藏
    self.collectionIcon = [[UIImageView alloc] init];
    
    self.collectionIcon.image = [UIImage imageNamed:@"2.0_collection"];
    
    [backgroundView addSubview:self.collectionIcon];
    
    [self.collectionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.heardIcon.mas_right).offset(50);
        
        make.centerY.equalTo(self.heardIcon.mas_centerY);
        
    }];
    
    self.collectionLabel = [[UILabel alloc] init];
    
    self.collectionLabel.text = @"2300";
    
    self.collectionLabel.font = [UIFont systemFontOfSize:10];
    
    self.collectionLabel.textColor = [UIColor hexColorFloat:@"999999"];
    
    [backgroundView addSubview:self.collectionLabel];
    
    [self.collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.collectionIcon.mas_right).offset(5);
        
        make.centerY.equalTo(self.collectionIcon.mas_centerY);
        
    }];

    //点赞
    self.upVoteIcon = [[UIImageView alloc] init];
    
    self.upVoteIcon.image = [UIImage imageNamed:@"2.0_upVote"];
    
    [backgroundView addSubview:self.upVoteIcon];
    
    [self.upVoteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.collectionIcon.mas_right).offset(50);
        
        make.centerY.equalTo(self.collectionIcon.mas_centerY);
        
    }];
    
    self.upVoteLabel = [[UILabel alloc] init];
    
    self.upVoteLabel.text = @"2300";
    
    self.upVoteLabel.font = [UIFont systemFontOfSize:10];
    
    self.upVoteLabel.textColor = [UIColor hexColorFloat:@"999999"];
    
    [backgroundView addSubview:self.upVoteLabel];
    
    [self.upVoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.upVoteIcon.mas_right).offset(5);
        
        make.centerY.equalTo(self.upVoteIcon.mas_centerY);
        
    }];

}


@end







