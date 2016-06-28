//
//  NSFanscell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSFanscell.h"
#import "NSFansListModel.h"
@interface NSFanscell ()
{
    UIImageView * headerImage;
    UILabel * authorLabel;
    UILabel * descLabel;
    
}
@end

@implementation NSFanscell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUIAppearance];
    }
    
    return self;
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //headerImage
    headerImage = [[UIImageView alloc] init];
    [self.contentView addSubview:headerImage];
    
    //authorLabel
    authorLabel = [[UILabel alloc] init];
    authorLabel.font = [UIFont systemFontOfSize:15];
    authorLabel.textColor = [UIColor hexColorFloat:@"181818"];
    authorLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:authorLabel];
    
    //descLabel
    descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:11];
    descLabel.textColor = [UIColor hexColorFloat:@"666666"];
    descLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:descLabel];
    
    
    //focusBtn
    self.focusBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.focusBtn];
   

    
}

#pragma mark layoutSubViewS
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //constraints
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(40);
    }];
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImage.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(20);
        make.right.equalTo(self.focusBtn.mas_right).with.offset(-10);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authorLabel.mas_right);
        make.top.equalTo(authorLabel.mas_bottom).with.offset(6);
        make.right.equalTo(authorLabel.mas_right);
    }];
    
}


#pragma mark setter & getter
-(void)setIsFans:(BOOL)isFans
{
    _isFans = isFans;
    if (!self.isFans) {
        [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"2.0_focused"]  forState:UIControlStateNormal];
    }else{
        [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"2.0_focusBtn"] forState:UIControlStateNormal];
    }
}
-(void)setFansModel:(NSFansModel *)fansModel
{
  
    _fansModel = fansModel;
    
    [headerImage setDDImageWithURLString:_fansModel.fansHeadURL placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    authorLabel.text = _fansModel.fansName;
    descLabel.text = _fansModel.fansSign;
    
    if (_fansModel.status ==2) {
        [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"2.0_focusTurn"] forState:UIControlStateNormal];
    }
}
@end
