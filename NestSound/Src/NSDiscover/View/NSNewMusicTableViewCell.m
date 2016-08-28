//
//  NSNewMusicTableViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSNewMusicTableViewCell.h"
#import "NSDiscoverBandListModel.h"
#import "NSMyMusicModel.h"
@interface NSNewMusicTableViewCell ()

//模拟组头
@property (nonatomic, strong) UIView *header;

//背景View
@property (nonatomic, strong) UIView *background;

//封面
@property (nonatomic, strong) UIImageView *coverIcon;

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
        
        self.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
        
        [self setupUI];
    }
    
    return self;
}

- (void)addDateLabel {
    
    //日期
    self.dateLabel = [[UILabel alloc] init];
    
    _dateLabel.textColor = [UIColor hexColorFloat:@"a0a0a0"];
    
    _dateLabel.font = [UIFont systemFontOfSize:10];
    
    _dateLabel.textAlignment = NSTextAlignmentRight;
    
    [self.background addSubview:self.dateLabel];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(self.background.mas_top).offset(10);
        
        make.centerY.equalTo(self.musicName.mas_centerY);
        
        make.right.equalTo(self.background.mas_right).offset(-10);
        
    }];
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
        
    }];
    
    
    //模拟组头
    self.header = [[UIView alloc] init];
    
    self.header.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self addSubview:self.header];
    
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        
        make.top.equalTo(self.mas_top);
        
        make.height.mas_equalTo(10);
    }];
    
    //背景View
    self.background = [[UIView alloc] init];
    
    self.background.backgroundColor = [UIColor hexColorFloat:@"f0f0f0"];
    
    [self.contentView addSubview:self.background];
    
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.numLabel.mas_right).offset(15);
        
        make.right.equalTo(self.mas_right).offset(-15);
        
        make.top.equalTo(self.header.mas_bottom);
        
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    //封面
    self.coverIcon = [[UIImageView alloc] init];
    [_coverIcon setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _coverIcon.contentMode =  UIViewContentModeScaleAspectFill;
    _coverIcon.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _coverIcon.clipsToBounds  = YES;
    [self.background addSubview:self.coverIcon];
    
    [self.coverIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.background.mas_left);
        
        make.top.bottom.equalTo(self.background);
        
        make.width.mas_equalTo(70);
        
    }];
    //是否公开
    self.secretImgView = [UIImageView new];
    
    _secretImgView.hidden = YES;
    
    _secretImgView.image = [UIImage imageNamed:@"2.0_password_icon"];
    
    [self.background addSubview:self.secretImgView];
    
    [self.secretImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.background.mas_top).offset(10);
        
        make.right.equalTo(self.background.mas_right).offset(-10);
        
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    //歌名
    self.musicName = [[UILabel alloc] init];
    
    if ([UIScreen mainScreen].bounds.size.height < 667) {
        
        self.musicName.font = [UIFont systemFontOfSize:12];
        
    } else {
        
        self.musicName.font = [UIFont systemFontOfSize:14];
    }
    
    
    
    [self.background addSubview:self.musicName];
    
    [self.musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.coverIcon.mas_right).offset(10);
        
        make.top.equalTo(self.background.mas_top).offset(8);
        
    }];
    
    //作者名
    self.authorName = [[UILabel alloc] init];
    
    
    
    self.authorName.font = [UIFont systemFontOfSize:10];
    
    self.authorName.textColor = [UIColor hexColorFloat:@"727272"];
    
    [self.background addSubview:self.authorName];
    
    [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.coverIcon.mas_right).offset(10);
        
        make.top.equalTo(self.musicName.mas_bottom).offset(5);
        
    }];
    
    //听过
    self.heardIcon = [[UIImageView alloc] init];
    
    self.heardIcon.image = [UIImage imageNamed:@"2.0_hear"];
    
    [self.background addSubview:self.heardIcon];
    
    [self.heardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.coverIcon.mas_right).offset(10);
        
        make.bottom.equalTo(self.background.mas_bottom).offset(-8);
        
    }];
    
    self.heardLabel = [[UILabel alloc] init];
    
    
    
    self.heardLabel.font = [UIFont systemFontOfSize:10];
    
    self.heardLabel.textColor = [UIColor hexColorFloat:@"999999"];
    
    [self.background addSubview:self.heardLabel];
    
    [self.heardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.heardIcon.mas_right).offset(5);
        
        make.centerY.equalTo(self.heardIcon.mas_centerY);
        
    }];
    
    //收藏
    self.collectionIcon = [[UIImageView alloc] init];
    
    self.collectionIcon.image = [UIImage imageNamed:@"2.0_collection"];
    
    [self.background addSubview:self.collectionIcon];
    
    [self.collectionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.heardIcon.mas_right).offset(60);
        
        make.centerY.equalTo(self.heardIcon.mas_centerY);
        
    }];
    
    self.collectionLabel = [[UILabel alloc] init];
    
    self.collectionLabel.font = [UIFont systemFontOfSize:10];
    
    self.collectionLabel.textColor = [UIColor hexColorFloat:@"999999"];
    
    [self.background addSubview:self.collectionLabel];
    
    [self.collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.collectionIcon.mas_right).offset(5);
        
        make.centerY.equalTo(self.collectionIcon.mas_centerY);
        
    }];
    
    //点赞
    self.upVoteIcon = [[UIImageView alloc] init];
    
    self.upVoteIcon.image = [UIImage imageNamed:@"2.0_upVote"];
    
    [self.background addSubview:self.upVoteIcon];
    
    [self.upVoteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.collectionIcon.mas_right).offset(60);
        
        make.centerY.equalTo(self.collectionIcon.mas_centerY);
        
    }];
    
    self.upVoteLabel = [[UILabel alloc] init];
    
    self.upVoteLabel.font = [UIFont systemFontOfSize:10];
    
    self.upVoteLabel.textColor = [UIColor hexColorFloat:@"999999"];
    
    [self.background addSubview:self.upVoteLabel];
    
    [self.upVoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.upVoteIcon.mas_right).offset(5);
        
        make.centerY.equalTo(self.upVoteIcon.mas_centerY);
        
    }];
    
}


#pragma mark -setter & getter
-(void)setMusicModel:(NSBandMusic *)musicModel
{
    _musicModel = musicModel;
    
    self.dateLabel.text =  [date  datetoStringWithDate:_musicModel.createDate];
    [self.coverIcon setDDImageWithURLString:_musicModel.titleImageUrl placeHolderImage:[UIImage imageNamed:@"UMS_alipay_icon"]];
    self.musicName.text = _musicModel.workName;
    self.authorName.text = _musicModel.author;
    if (_musicModel.lookNum > 9999) {
        double count = (double)_musicModel.lookNum/10000.0;
        CHLog(@"%f",count);
        self.heardLabel.text = [NSString stringWithFormat:@"%.1f万",count];
    }else{
        self.heardLabel.text = [NSString stringWithFormat:@"%ld",_musicModel.lookNum];
    }

    self.collectionLabel.text = [NSString stringWithFormat:@"%ld",_musicModel.fovNum];
    
    self.upVoteLabel.text = [NSString stringWithFormat:@"%ld",_musicModel.zanNum];
    self.itemId = _musicModel.itemId;
}

-(void)setMyMusicModel:(NSMyMusicModel *)myMusicModel
{
    _myMusicModel = myMusicModel;
   
    if (myMusicModel.isShow) {
        self.secretImgView.hidden = NO;
    } else {
        self.secretImgView.hidden = YES;
    }
    self.dateLabel.text =  [date  datetoStringWithDate:_musicModel.createDate];
    [self.coverIcon setDDImageWithURLString:_myMusicModel.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    self.musicName.text = _myMusicModel.title;
//    self.authorName.text = _myMusicModel.author;
    if (_myMusicModel.lookNum > 9999) {
        double count = (double)_myMusicModel.lookNum/10000.0;
        CHLog(@"%f",count);
        self.heardLabel.text = [NSString stringWithFormat:@"%.1f万",count];
    }else{
        self.heardLabel.text = [NSString stringWithFormat:@"%ld",_myMusicModel.lookNum];
    }
    self.collectionLabel.text = [NSString stringWithFormat:@"%ld",_myMusicModel.fovNum];
    self.authorName.text = _myMusicModel.author;
    self.musicName.text = _myMusicModel.title;
    self.upVoteLabel.text = [NSString stringWithFormat:@"%ld",_myMusicModel.upvoteNum];
    self.itemId = _myMusicModel.itemId;
}

@end







