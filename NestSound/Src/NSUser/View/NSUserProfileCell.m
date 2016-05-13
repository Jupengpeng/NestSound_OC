//
//  NSUserProfileCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserProfileCell.h"

@interface NSUserProfileCell ()
{
    UIImageView * userIcon;
    UILabel * nickLabel;
    UILabel * numberLabel;
    UIImageView * editImageView;
    

}
@end

@implementation NSUserProfileCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self configureUIAppearance];
    }
    
    return self;
}

#pragma mark -configureAppearance
-(void)configureUIAppearance
{
    //userIcon
    userIcon = [[UIImageView alloc] init];
    userIcon.layer.cornerRadius = 51;
    userIcon.layer.borderWidth = 1;
    userIcon.layer.borderColor = [UIColor hexColorFloat:@"999999"].CGColor;
    [self addSubview:userIcon];
    
    //nickNameLabel
    nickLabel = [[UILabel alloc] init];
    nickLabel.textAlignment = NSTextAlignmentLeft;
    nickLabel.textColor = [UIColor hexColorFloat:@"1818181"];
    nickLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:nickLabel];
    
    //numberLabel
    numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor = [UIColor hexColorFloat:@"999999"];
    numberLabel.font = [UIFont systemFontOfSize:9];
    [self addSubview:numberLabel];
    
    editImageView = [[UIImageView alloc] init];
   
    [self addSubview:editImageView];
    
    

}

#pragma mark -layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //constraints
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(51);
    }];
    
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(22);
        make.right.equalTo(self.mas_right).with.offset(-40);
    }];

    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickLabel.mas_left);
        make.top.equalTo(nickLabel.mas_bottom).with.offset(6);
        make.right.equalTo(nickLabel.mas_right);
    }];
    
    [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}


#pragma mark setter&getter

-(void)setIconURL:(NSString *)iconURL
{
    _iconURL = iconURL;
    [userIcon setDDImageWithURLString:iconURL placeHolderImage:[UIImage imageNamed:@"d"]];
}

-(void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    nickLabel.text = _nickName;
}

-(void)setNumber:(NSString *)number
{
    _number = number;
    numberLabel.text = _number;
}


@end
