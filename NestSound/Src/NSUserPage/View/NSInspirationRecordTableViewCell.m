//
//  NSInspirationRecordTableViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInspirationRecordTableViewCell.h"
#import "NSMyMusicModel.h"
@interface NSInspirationRecordTableViewCell () {
    
    UILabel *_dayLabel;
    
    UILabel *_monthLabel;
    
    UILabel *_yearLabel;
    
    UIImageView *_audioImageView;
    
}

@end

@implementation NSInspirationRecordTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    self.backgroundImageView = [[UIImageView alloc] init];
    
    [_backgroundImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    _backgroundImageView.contentMode =  UIViewContentModeScaleAspectFill;
    
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _backgroundImageView.clipsToBounds  = YES;
//    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;;
    
    self.backgroundImageView.image = [UIImage imageWithRenderColor:[UIColor orangeColor] renderSize:CGSizeMake(1, 0.5)];
    
    [self.contentView addSubview:self.backgroundImageView];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        
        make.right.equalTo(self.mas_right).offset(-15);
        
        make.top.equalTo(self.mas_top).offset(10);
        
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
    _dayLabel = [[UILabel alloc] init];
    
    _dayLabel.font = [UIFont systemFontOfSize:22];
    
    _dayLabel.text = @"19";
    
    [self.contentView addSubview:_dayLabel];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(20);
        
        make.left.equalTo(self.mas_left).offset(30);
        
        make.height.mas_equalTo(22);
        
    }];
    
    
    _monthLabel = [[UILabel alloc] init];
    
    _monthLabel.font = [UIFont systemFontOfSize:10];
    
    _monthLabel.text = @"五月";
    
    [self.contentView addSubview:_monthLabel];
    
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(20);
        
        make.left.equalTo(_dayLabel.mas_right).offset(3);
        
        make.height.mas_equalTo(10);
        
    }];
    
    
    _yearLabel = [[UILabel alloc] init];
    
    _yearLabel.font = [UIFont systemFontOfSize:10];
    
    _yearLabel.text = @"2016";
    
    [self.contentView addSubview:_yearLabel];
    
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_monthLabel.mas_bottom).offset(2);
        
        make.left.equalTo(_dayLabel.mas_right).offset(3);
        
        make.height.mas_equalTo(10);
        
    }];
    
    
    self.descriptionLabel = [[UILabel alloc] init];
    
    self.descriptionLabel.font = [UIFont systemFontOfSize:12];
    
    self.descriptionLabel.numberOfLines = 3;
    
    self.descriptionLabel.text = @"《我在那一角落患过伤风》";
   
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.descriptionLabel.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.descriptionLabel.text length])];
    
    self.descriptionLabel.attributedText = attributedString;
    
    
    
    [self.contentView addSubview:self.descriptionLabel];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(30);
        
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
        make.right.equalTo(self.mas_right).offset(-30);
        
    }];
    
    
    _audioImageView = [[UIImageView alloc] init];
    
    _audioImageView.image = [UIImage imageNamed:@"2.0_audio"];
    
    [self.contentView addSubview:_audioImageView];
    
    [_audioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_yearLabel.mas_right).offset(10);
        
        make.top.equalTo(self.mas_top).offset(20);
        
    }];
    
    
    
    self.frequencyImageView = [[UIImageView alloc] init];
    
    self.frequencyImageView.image = [UIImage imageNamed:@"2.0_frequency_white"];
    
    [self.contentView addSubview:self.frequencyImageView];
    
    [self.frequencyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        
        make.right.equalTo(self.mas_right).offset(-15);
        
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
    }];
    
}

-(void)setMyInspirationModel:(NSMyMusicModel *)myInspirationModel
{
    _myInspirationModel = myInspirationModel;
    NSArray * arr = [NSArray arrayWithArray:[_myInspirationModel.titleImageUrls componentsSeparatedByString:@","]];
    if (arr.count) {
        [_backgroundImageView setDDImageWithURLString:arr[0] placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
//        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:arr[0]]];
//        UIImage * image = [[UIImage alloc] initWithData:imageData];
//        _backgroundImageView.image = [image scaleFillToSize:CGSizeMake(ScreenWidth-30, 140)];
    }else{
        _backgroundImageView.image = [UIImage imageNamed:@"2.0_placeHolder_long"];
    }
    
//    if (!self.myInspirationModel.spireContent) {
//        self.descriptionLabel.text = @"";
//    }else{
        self.descriptionLabel.text = self.myInspirationModel.spireContent;
//    }
    
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc] init];
    double timeStamp = _myInspirationModel.createDate / 1000;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    [dateFormater setDateFormat: @"YYYY"];
    _yearLabel.text = [dateFormater stringFromDate:date];
    [dateFormater setDateFormat:@"MM"];
    _monthLabel.text = [dateFormater stringFromDate:date];
    [dateFormater setDateFormat:@"dd"];
    _dayLabel.text = [dateFormater stringFromDate:date];
    if (_myInspirationModel.audio.length == 0) {
        _audioImageView.hidden = YES;
        self.frequencyImageView.hidden = YES;
    }else{
        _audioImageView.hidden = NO;
        self.frequencyImageView.hidden = NO;
    }
}


@end
