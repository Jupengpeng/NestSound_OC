//
//  NSUserProfileCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserProfileCell.h"
#import "NSUserDataModel.h"
@interface NSUserProfileCell ()
{
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
    self.userIcon = [[UIImageView alloc] init];
    _userIcon.layer.cornerRadius = 25;
    _userIcon.layer.borderWidth = 1;
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.borderColor = [UIColor hexColorFloat:@"999999"].CGColor;
    _userIcon.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_userIcon];
    
    //nickNameLabel
    nickLabel = [[UILabel alloc] init];
    nickLabel.textAlignment = NSTextAlignmentLeft;
    nickLabel.textColor = [UIColor hexColorFloat:@"1818181"];
    nickLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:nickLabel];
    
    //numberLabel
    numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor = [UIColor hexColorFloat:@"999999"];
    numberLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:numberLabel];
    
//    editImageView = [[UIImageView alloc] init];
//    editImageView.image = [UIImage imageNamed:@"2.0_modify"];
//    [self addSubview:editImageView];
    
}

#pragma mark -layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //constraints
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).with.offset(10);
        make.bottom.equalTo(self.userIcon.mas_centerY).with.offset(-1);
        make.right.equalTo(self.mas_right).with.offset(-100);
    }];

    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickLabel.mas_left);
        make.top.equalTo(self.userIcon.mas_centerY).with.offset(1);
        make.right.equalTo(nickLabel.mas_right);
    }];
    
//    [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.userIcon.mas_centerY);
//        make.right.equalTo(self.mas_right).with.offset(-15);
//        make.width.mas_equalTo(12);
//        make.height.mas_equalTo(14);
//    }];
}


#pragma mark setter&getter

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

- (void)setUserModel:(UserModel *)userModel {
    
    _userModel = userModel;
    [self.userIcon setDDImageWithURLString:userModel.headerUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    
    nickLabel.text = userModel.nickName;
    
    if (userModel.signature) {
        numberLabel.text = userModel.signature;
    }else{
        numberLabel.text = @"您还没有描述哦";
    }
}
@end
