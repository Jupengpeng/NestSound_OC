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
    
    self.descriptionLabel.text = @"《我在那一角落患过伤风》，这是一首有很奇怪名字的歌，出自一张叫做《只能谈情，不能说爱》的特殊唱片。之所以说《只能谈情，不能说爱》是一张特殊唱片，是因为它是一本同名小说的配乐概念唱片——这是一个新名词。这本小说这样写道：曾经恋爱过的人都明白，最爱的，总是得不到的。得与失，得当然喜；得而复失、患得患失、乍得还失，更悲！曾经恋爱过的都明白，童话式的天长地久只属于童话，不属于现实，难得，所以可贵，所以童话！现实中的爱情，最爱的，却总是得不到的。伤风，能够用药治好，中药太慢，西药太伤身体，所以，我总是选择自然好。我的伤风断断续续，蔓延开来，咳嗽，头痛。然而，反反复复，讳疾忌医。我害怕中药太苦，从来不喝。害怕西药伤身，尽量少吃。终于，还是有那么一天，我发现我的伤风好了，以前痛苦挣扎，以为就这样一辈子沉重地背着伤风病。一瞬间，却发现早已痊愈。爱情，也不过如此。";
   
    #warning mark 这个必须放在赋值后面
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
    [_backgroundImageView setDDImageWithURLString:_myInspirationModel.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_accompany_highlighted"]];
    self.descriptionLabel.text = self.myInspirationModel.spireContent;
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat: @"YYYY"];
    _yearLabel.text = [dateFormater stringFromDate:_myInspirationModel.createDate];
    [dateFormater setDateFormat:@"MM"];
    _monthLabel.text = [dateFormater stringFromDate:_myInspirationModel.createDate];
    [dateFormater setDateFormat:@"dd"];
    _dayLabel.text = [dateFormater stringFromDate:_myInspirationModel.createDate];
}


@end
