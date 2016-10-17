//
//  NSPreserveWorkInfoCell.m
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#define  GetSongName(name)   [NSString stringWithFormat:@"作品名：%@",name]
#define  GetLyricsName(name)   [NSString stringWithFormat:@"作词：%@",name]
#define  GetMusicName(name)   [NSString stringWithFormat:@"作曲：%@",name]
#define  GetAccompanyName(name)   [NSString stringWithFormat:@"伴奏：%@",name]
#define  GetcreaTime(name)   [NSString stringWithFormat:@"创作时间：%@",name]
#define  GetPreserveDate(name) [NSString stringWithFormat:@"保全时间：%@",name]
#define  GetPreserveCode(name) [NSString stringWithFormat:@"保全编号：%@",name]

#import "NSPreserveWorkInfoCell.h"
#import "UIImageView+WebCache.h"
#import "NSPreserveApplyModel.h"
#import "NSPreserveDetailListModel.h"
#import "NSTool.h"
@interface NSPreserveWorkInfoCell ()
{
    NSString *_sortId;
    NSPreserveProductInfoModel *_productInfoModel;
}
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

      
        self.songName = [[UILabel alloc] initWithFrame:CGRectZero];
        self.songName.textColor = [UIColor hexColorFloat:@"323232"];
        self.songName.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.songName];

        
        self.lyricsTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.lyricsTitle.textColor = [UIColor hexColorFloat:@"323232"];
        self.lyricsTitle.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.lyricsTitle];

        
        self.musicTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.musicTitle.textColor = [UIColor hexColorFloat:@"323232"];
        self.musicTitle.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.musicTitle];

        
        self.accompanyTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.accompanyTitle.textColor = [UIColor hexColorFloat:@"878787"];
        self.accompanyTitle.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.accompanyTitle];

        
        self.createTime = [[UILabel alloc] initWithFrame:CGRectZero];
        self.createTime.textColor = [UIColor hexColorFloat:@"878787"];
        self.createTime.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.createTime];

        
        self.preserveDate = [[UILabel alloc] init];
        self.preserveDate.textColor = [UIColor hexColorFloat:@"878787"];
        self.preserveDate.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.preserveDate];

        
        self.preserveCode = [[UILabel alloc] init];
        self.preserveCode.textColor = [UIColor hexColorFloat:@"878787"];
        self.preserveCode.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.preserveCode];

    }
    return self;
}

- (void)setProductInfoModel:(NSPreserveProductInfoModel *)productInfoModel{
    
    _productInfoModel = productInfoModel;
    
    
    switch ([productInfoModel.type intValue]) {
        case 1:
        {
            self.lyricsTitle.hidden = YES;
        }
            break;
        case 2:
        {
            self.musicTitle.hidden = YES;
            self.accompanyTitle.hidden = YES;
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [self.workCover sd_setImageWithURL:[NSURL URLWithString:productInfoModel.image] placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.songName.text = GetSongName(productInfoModel.title);
    self.lyricsTitle.text = GetLyricsName(productInfoModel.lyricAuthor);
    self.musicTitle.text = GetMusicName(productInfoModel.songAuthor);
    self.accompanyTitle.text = GetAccompanyName(productInfoModel.accompaniment);
    self.createTime.text = GetcreaTime([date datetoMonthStringWithDate:[productInfoModel.createTime doubleValue] format:@"YYYY.MM.dd HH:mm"]);
}

- (void)setupDataWithProductModel:(NSProductModel *)productModel{
    
    switch (productModel.type) {
        case 1:
        {
            self.lyricsTitle.hidden = YES;
        }
            break;
        case 2:
        {
            self.musicTitle.hidden = YES;
            self.accompanyTitle.hidden = YES;
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [self.workCover sd_setImageWithURL:[NSURL URLWithString:productModel.productImg] placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.songName.text = GetSongName(productModel.productTitle);
    self.lyricsTitle.text = GetLyricsName(productModel.lyricAuthor);
    self.musicTitle.text = GetMusicName(productModel.songAuthor);
    self.accompanyTitle.text = GetAccompanyName(productModel.accompaniment);
    self.createTime.text = GetcreaTime([date datetoLongLongStringWithDate:productModel.createTime]);
    self.preserveDate.text = GetPreserveDate([date datetoLongLongStringWithDate:productModel.preserveTime]);
    self.preserveCode.text = GetPreserveCode(productModel.preserveNo);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.workCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(35);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    [self.songName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.workCover.mas_right).offset(10.0f);
        make.top.equalTo(self.mas_top).offset(40.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.mas_equalTo(14.0f);
    }];


    
    [self.lyricsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.workCover.mas_right).offset(10.0f);
        make.top.equalTo(self.songName.mas_bottom).offset(7.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    
    UILabel *musicLastLabel = self.lyricsTitle;
    if (self.lyricsTitle.hidden) {
        musicLastLabel = self.songName;
    }
    
    //歌曲名
    [self.musicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.workCover.mas_right).offset(10.0f);
        make.top.equalTo(musicLastLabel.mas_bottom).offset(7.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    
    //伴奏
    [self.accompanyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.workCover.mas_right).offset(10.0f);
        make.top.equalTo(self.musicTitle.mas_bottom).offset(7.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    UILabel *createLastLabel = self.accompanyTitle;
    if (self.accompanyTitle.hidden) {
        createLastLabel = self.lyricsTitle;
    }
    
    //创作时间
    [self.createTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.workCover.mas_right).offset(10.0f);
        make.top.equalTo(createLastLabel.mas_bottom).offset(7.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.mas_equalTo(14.0f);
    }];
    [self.preserveDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10.0f);
        make.top.equalTo(self.workCover.mas_bottom).offset(7.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.mas_equalTo(14.0f);
    }];
    [self.preserveCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10.0f);
        make.top.equalTo(self.preserveDate.mas_bottom).offset(7.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.mas_equalTo(14.0f);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
