//
//  NSInvitationListTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInvitationListTableViewCell.h"
#import "NSCooperationListModel.h"
#include "NSInvitationListModel.h"
@interface NSInvitationListTableViewCell ()
{
    //头像
    UIImageView *iconImgView;
    //作者名字
    UILabel *authorNameLabel;
    //签名
    UILabel *signatureLabel;
    //邀请
//    UIButton *invitationBtn;
    //推荐
    UILabel * recommend;
}
@end

@implementation NSInvitationListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupInvitationCellUI];
    }
    return self;
}
- (void)setupInvitationCellUI {
    
    //头像
    iconImgView = [[UIImageView alloc] init];
    
    iconImgView.userInteractionEnabled = YES;
    
    iconImgView.image = [UIImage imageNamed:@"2.0_weChat"];
    
    [self.contentView addSubview:iconImgView];
    
    iconImgView.clipsToBounds = YES;
    
    iconImgView.layer.cornerRadius = 20;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImgClick)];
    
    [iconImgView addGestureRecognizer:tap];
    //作者名
    authorNameLabel = [[UILabel alloc] init];
    
    authorNameLabel.font = [UIFont systemFontOfSize:14];
    
    authorNameLabel.text = @"疯子";
    
    [self.contentView addSubview:authorNameLabel];
    
    
    //签名
    signatureLabel = [[UILabel alloc] init];
    
    signatureLabel.font = [UIFont systemFontOfSize:12];
    
    signatureLabel.textColor = [UIColor lightGrayColor];
    
//    signatureLabel.text = @"人不风流枉少年";
    
    [self.contentView addSubview:signatureLabel];
    
    //邀请
    self.invitationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _invitationBtn.layer.cornerRadius = 3;
    
    _invitationBtn.layer.masksToBounds = YES;
    
    _invitationBtn.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [_invitationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_invitationBtn addTarget:self action:@selector(invitationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [invitationBtn setTitle:@"邀请" forState:UIControlStateNormal];
    
    [self.contentView addSubview:_invitationBtn];
    
    //推荐
    recommend = [[UILabel alloc] init];
    
    recommend.text = @"推荐";
    
    recommend.layer.cornerRadius = 1.5;
    
    recommend.layer.masksToBounds = YES;
    
    recommend.textAlignment = NSTextAlignmentCenter;
    
    recommend.font = [UIFont systemFontOfSize:9];
    
    recommend.backgroundColor = [UIColor hexColorFloat:@"a6db70"];
    
    recommend.textColor = [UIColor whiteColor];
    
    [self.contentView addSubview:recommend];
    
}
- (void)iconImgClick {
    if ([self.delegate respondsToSelector:@selector(iconBtnClickWith:)]) {
        
        [self.delegate iconBtnClickWith:self];
    }
}
- (void)invitationBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(invitationBtnClickWith:)]) {
        
        [self.delegate invitationBtnClickWith:self];
    }
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
        make.width.mas_equalTo(40);
        
        make.height.mas_equalTo(40);
        
    }];
    
    [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImgView.mas_right).offset(10);
        
        make.top.equalTo(iconImgView.mas_top);
        
    }];
    
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImgView.mas_right).offset(10);
        
        make.bottom.equalTo(iconImgView.mas_bottom);
        
        make.right.equalTo(_invitationBtn.mas_left).offset(-10);
    }];
    
    [_invitationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        
        make.size.mas_equalTo(CGSizeMake(72, 30));
        
    }];
    
    [recommend mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconImgView.mas_bottom).offset(-6);
        
        make.centerX.equalTo(iconImgView.mas_centerX);
        
        make.size.mas_equalTo(CGSizeMake(20, 12));
        
    }];
}
- (void)setInvitationModel:(InvitationModel *)invitationModel {
    _invitationModel = invitationModel;
    [iconImgView setDDImageWithURLString:invitationModel.headerUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    authorNameLabel.text = invitationModel.nickName;
    signatureLabel.text = invitationModel.signature;
    if (invitationModel.isInvited) {
        [self.invitationBtn setTitle:@"已邀请" forState:UIControlStateNormal];
        self.invitationBtn.backgroundColor = [UIColor hexColorFloat:@"f2f2f2"];
        self.invitationBtn.userInteractionEnabled = NO;
    } else {
        [self.invitationBtn setTitle:@"邀请" forState:UIControlStateNormal];
        self.invitationBtn.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    }
    if (invitationModel.isRecommend) {
        recommend.hidden = NO;
    } else {
        recommend.hidden = YES;
    }
}
- (void)setCooperationModel:(CooperationModel *)cooperationModel {
    _cooperationModel = cooperationModel;
    signatureLabel.text = [date datetoLongLongStringWithDate:cooperationModel.createTime];
}
- (void)setCooperationUser:(CooperationUser *)cooperationUser {
    _cooperationUser = cooperationUser;
    [iconImgView setDDImageWithURLString:cooperationUser.headerUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    authorNameLabel.text = cooperationUser.nickName;
//    signatureLabel.text = cooperationUser.
    recommend.hidden = YES;
    [self.invitationBtn setTitle:@"合作" forState:UIControlStateNormal];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
