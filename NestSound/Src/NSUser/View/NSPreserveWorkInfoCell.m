//
//  NSPreserveWorkInfoCell.m
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#define  GetSongName(name)   [NSString stringWithFormat:@"歌曲名：%@",name]
#define  GetLyricsName(name)   [NSString stringWithFormat:@"作词：%@",name]
#define  GetMusicName(name)   [NSString stringWithFormat:@"作曲：%@",name]
#define  GetAccompanyName(name)   [NSString stringWithFormat:@"伴奏：%@",name]
#define  GetcreaTime(name)   [NSString stringWithFormat:@"创作时间：%@",name]
#define  GetPreserveDate(name) [NSString stringWithFormat:@"保全时间：%@",name]
#define  GetPreserveCode(name) [NSString stringWithFormat:@"保全编号：%@",name]

#import "NSPreserveWorkInfoCell.h"
#import "UIImageView+WebCache.h"
@interface NSPreserveWorkInfoCell ()

@property (nonatomic,strong) UIImageView *workCover;

@property (nonatomic,strong) UILabel *songName;
@property (nonatomic,strong) UILabel *lyricsTitle;
@property (nonatomic,strong) UILabel *musicTitle;
@property (nonatomic,strong) UILabel *accompanyTitle;
@property (nonatomic,strong) UILabel *createTime;

@end
@implementation NSPreserveWorkInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 13)];
        titleLabel.textColor = [UIColor hexColorFloat:@"afafaf"];
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.text = @"作品信息";
        [self addSubview:titleLabel];
        
        
        self.workCover = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.workCover.clipsToBounds = YES;
        self.workCover.contentMode = UIViewContentModeScaleAspectFill;
        self.workCover.layer.cornerRadius = 4.0f;
        [self addSubview:self.workCover];
        [self.workCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(35);
            make.height.mas_equalTo(100);
            make.width.mas_equalTo(100);
        }];
      
        self.songName = [[UILabel alloc] initWithFrame:CGRectZero];
        self.songName.textColor = [UIColor hexColorFloat:@"323232"];
        self.songName.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.songName];
        [self.songName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.workCover.mas_right).offset(10.0f);
            make.top.equalTo(self.mas_top).offset(40.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.mas_equalTo(14.0f);
        }];
        
        self.lyricsTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.lyricsTitle.textColor = [UIColor hexColorFloat:@"323232"];
        self.lyricsTitle.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.lyricsTitle];
        [self.lyricsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.workCover.mas_right).offset(10.0f);
            make.top.equalTo(self.songName.mas_bottom).offset(7.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.mas_equalTo(12.0f);
        }];
        
        self.musicTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.musicTitle.textColor = [UIColor hexColorFloat:@"323232"];
        self.musicTitle.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.musicTitle];
        [self.musicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.workCover.mas_right).offset(10.0f);
            make.top.equalTo(self.lyricsTitle.mas_bottom).offset(7.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.mas_equalTo(12.0f);
        }];
        
        self.accompanyTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.accompanyTitle.textColor = [UIColor hexColorFloat:@"878787"];
        self.accompanyTitle.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.accompanyTitle];
        [self.accompanyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.workCover.mas_right).offset(10.0f);
            make.top.equalTo(self.musicTitle.mas_bottom).offset(7.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.mas_equalTo(12.0f);
        }];
        
        self.createTime = [[UILabel alloc] initWithFrame:CGRectZero];
        self.createTime.textColor = [UIColor hexColorFloat:@"878787"];
        self.createTime.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.createTime];
        [self.createTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.workCover.mas_right).offset(10.0f);
            make.top.equalTo(self.accompanyTitle.mas_bottom).offset(7.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.mas_equalTo(14.0f);
        }];
        
        self.preserveDate = [[UILabel alloc] init];
        self.preserveDate.textColor = [UIColor hexColorFloat:@"878787"];
        self.preserveDate.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.preserveDate];
        [self.preserveDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.top.equalTo(self.workCover.mas_bottom).offset(7.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.mas_equalTo(14.0f);
        }];
        
        self.preserveCode = [[UILabel alloc] init];
        self.preserveCode.textColor = [UIColor hexColorFloat:@"878787"];
        self.preserveCode.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.preserveCode];
        [self.preserveCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.top.equalTo(self.preserveDate.mas_bottom).offset(7.0f);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.mas_equalTo(14.0f);
        }];
    }
    return self;
}

- (void)setupData{

    [self.workCover sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.songName.text = GetSongName(@"南方姑娘");
    self.lyricsTitle.text = GetLyricsName(@"赵雷");
    self.musicTitle.text = GetMusicName(@"赵雷");
    self.accompanyTitle.text = GetAccompanyName(@"音巢音乐-家乡民谣");
    self.createTime.text = GetcreaTime(@"2016.09.13 15:35");
    self.preserveDate.text = GetPreserveDate(@"2016.09.13 15:35");
    self.preserveCode.text = GetPreserveCode(@"21JB5TMBA23PSM0");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
