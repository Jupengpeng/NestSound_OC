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
    UIButton * focusBtn;
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
    focusBtn = [[UIButton alloc] init];
    [self.contentView addSubview:focusBtn];
    
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
        
    }];
    
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(40);
    }];
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImage.mas_left).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(20);
        make.right.equalTo(focusBtn.mas_right).with.offset(-10);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authorLabel.mas_left);
        make.top.equalTo(authorLabel.mas_bottom).with.offset(6);
        make.right.equalTo(authorLabel.mas_right);
    }];
    
}


#pragma mark setter & getter
-(void)setFansModel:(NSFansModel *)fansModel
{
  
    _fansModel = fansModel;
    
    [headerImage setDDImageWithURLString:_fansModel.fansHeadURL placeHolderImage:[UIImage imageNamed:@"2.0_addPicture"]];


    authorLabel.text = _fansModel.fansName;

    descLabel.text = _fansModel.fansSign;

    if (_fansModel.status) {
        [focusBtn setBackgroundImage:[UIImage imageNamed:@"2.0_addPicture"] forState:UIControlStateNormal];
    }else{
        [focusBtn setBackgroundImage:[UIImage imageNamed:@"2.0_addPicture"] forState:UIControlStateNormal];
    }
}
@end
