//
//  NSLyricCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricCell.h"
#import "NSMyLricListModel.h"
@interface NSLyricCell ()
{
    UIImageView * titlePage;
    UILabel * lyricNameLabel;
    UILabel * authorLabel;

}

@end

@implementation NSLyricCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureUIAppearance];
    }
    return self;
}


#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //titlePage
    titlePage = [[UIImageView alloc] init];
    [self.contentView addSubview:titlePage];
    
    lyricNameLabel = [[UILabel alloc] init];
    lyricNameLabel.font = [UIFont systemFontOfSize:16];
    lyricNameLabel.textColor = [UIColor hexColorFloat:@"181818"];
    [self.contentView addSubview:lyricNameLabel];
    
    authorLabel = [[UILabel alloc] init];
    authorLabel.font = [UIFont systemFontOfSize:10];
    authorLabel.textColor = [UIColor hexColorFloat:@"666666"];
    [self.contentView addSubview:authorLabel];
    
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.backgroundColor = [UIColor hexColorFloat:@"f0f0f0"];
    
    
    
}


#pragma mark layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    //constraints
    [titlePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(69);
    }];
    
    [lyricNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlePage.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-20);
        
    }];
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lyricNameLabel.mas_left);
        make.top.equalTo(lyricNameLabel.mas_bottom).with.offset(7);
        make.right.equalTo(lyricNameLabel.mas_right);
    }];
    
    
}


#pragma mark -setter & getter
-(void)setMyLyricModel:(NSMyLyricModel *)myLyricModel
{
    _myLyricModel = myLyricModel;
    [titlePage setDDImageWithURLString:self.myLyricModel.titleImageUrl          placeHolderImage:[UIImage imageNamed:@"2.0_accompany_highlighted"]];
    lyricNameLabel.text = _myLyricModel.title;
    authorLabel.text = _myLyricModel.author;

}

@end
