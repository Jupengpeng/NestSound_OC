//
//  NSSystemMessageCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSystemMessageCell.h"
#import "NSSystemMessageListModel.h"
@interface NSSystemMessageCell ()
{
    UIImageView * headView;
    UILabel * titleLabel;
    UILabel * dateLabel;
    UILabel * contentLabel;
    UIView * bkView;
    UIImageView * detail;
    UIImageView * titleImage;
    UILabel * bkViewTitleLable;
}
@end


@implementation NSSystemMessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUIAppearance];
    }
    return self;
}

#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    //headView
    headView = [[UIImageView alloc] init];
    headView.layer.cornerRadius = 18;
    headView.layer.masksToBounds = YES;
    [headView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    headView.contentMode =  UIViewContentModeScaleAspectFill;
    headView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    headView.clipsToBounds  = YES;
    [self.contentView addSubview:headView];
    [headView setDDImageWithURLString:nil placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    
    //titleLabel
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor hexColorFloat:@"181818"];
    [self.contentView addSubview:titleLabel];
    
    //dateLabel
    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textColor = [UIColor hexColorFloat:@"999999"];
    [self.contentView addSubview:dateLabel];
    
    //detail
    detail = [[UIImageView alloc] init];
    detail.image = [UIImage imageNamed:@"2.0_addPicture"];
    [self.contentView addSubview:detail];
    
    //contentLabel
    contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor hexColorFloat:@"181818"];
    [self.contentView addSubview:contentLabel];
    
    //bkView
    bkView = [[UIView alloc] init];
    bkView.layer.cornerRadius = 10;
    bkView.backgroundColor = [UIColor hexColorFloat:@"f0f0f0"];
    bkView.layer.masksToBounds = YES;
    [self.contentView addSubview:bkView];
    
    //titleImage
    titleImage = [[UIImageView alloc] init];
    [bkView addSubview:titleImage];
    
    //bkViewTitle
    bkViewTitleLable = [[UILabel alloc] init];
    bkViewTitleLable.font = [UIFont systemFontOfSize:14];
    bkViewTitleLable.textColor = [UIColor hexColorFloat:@"181818"];
    [bkView addSubview:bkViewTitleLable];
    
    
}

#pragma mark -layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //constraints
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(36);
    }];
    
    //titleLabel
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
    }];
    
    //dateLabel
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
        make.right.equalTo(titleLabel.mas_right);
        
    }];
    
    //detail
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
    //contentLabel
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(dateLabel.mas_right);
    }];
    
    //bkview
    [bkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.top.equalTo(headView.mas_bottom).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-15);
    }];
    
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bkView.mas_left);
        make.top.equalTo(bkView.mas_top);
        make.bottom.equalTo(bkView.mas_bottom);
        make.width.mas_equalTo(150);
    }];
    
    [bkViewTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImage.mas_right).with.offset(10);
        make.top.equalTo(bkView.mas_top).with.offset(15);
        make.right.equalTo(bkView.mas_right).with.offset(-10);
        make.bottom.equalTo(bkView.mas_bottom).with.offset(-10);
    }];
    
    
}


#pragma mark -setter & getter
-(void)setSystemMessageModel:(SystemMessageModel *)systemMessageModel
{

    _systemMessageModel = systemMessageModel;
//    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:_systemMessageModel.createDate];
    dateLabel.text = [date datetoStringWithDate:_systemMessageModel.createDate];

    [titleImage setDDImageWithURLString:_systemMessageModel.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_addPicture"]];

    if (_isTu) {
        bkViewTitleLable.text = _systemMessageModel.content;
    }else{
        contentLabel.text = _systemMessageModel.content;
    }
}
-(void)setIsTu:(BOOL)isTu
{
    _isTu = isTu;
    if (_isTu) {
        bkView.hidden = NO;
        contentLabel.hidden = YES;
        detail.hidden = NO;
    }else{
        contentLabel.hidden = NO;
        bkView.hidden = YES;
        detail.hidden = YES;
    }
}
@end
