//
//  NSInvitationListTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInvitationListTableViewCell.h"

@interface NSInvitationListTableViewCell ()
{
    //头像
    UIImageView *iconImgView;
    //作者名字
    UILabel *authorNameLabel;
    //签名
    UILabel *signatureLabel;
    //邀请
    UIButton *invitationBtn;
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
    
    iconImgView.image = [UIImage imageNamed:@"2.0_weChat"];
    
    [self.contentView addSubview:iconImgView];
    
    iconImgView.clipsToBounds = YES;
    
    iconImgView.layer.cornerRadius = 20;
    
    //作者名
    authorNameLabel = [[UILabel alloc] init];
    
    authorNameLabel.font = [UIFont systemFontOfSize:14];
    
    authorNameLabel.text = @"疯子";
    
    [self.contentView addSubview:authorNameLabel];
    
    
    //签名
    signatureLabel = [[UILabel alloc] init];
    
    signatureLabel.font = [UIFont systemFontOfSize:12];
    
    signatureLabel.textColor = [UIColor lightGrayColor];
    
    signatureLabel.text = @"人不风流枉少年";
    
    [self.contentView addSubview:signatureLabel];
    
    //邀请
    invitationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    invitationBtn.layer.cornerRadius = 3;
    
    invitationBtn.layer.masksToBounds = YES;
    
    invitationBtn.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [invitationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [invitationBtn addTarget:self action:@selector(invitationBtnClickWith:) forControlEvents:UIControlEventTouchUpInside];
    
    [invitationBtn setTitle:@"邀请" forState:UIControlStateNormal];
    
    [self.contentView addSubview:invitationBtn];
    
    //推荐
    recommend = [[UILabel alloc] init];
    
    recommend.text = @"推荐";
    
    recommend.layer.cornerRadius = 1.5;
    
    recommend.layer.masksToBounds = YES;
    
    recommend.textAlignment = NSTextAlignmentCenter;
    
    recommend.font = [UIFont systemFontOfSize:9];
    
    recommend.backgroundColor = [UIColor greenColor];
    
    recommend.textColor = [UIColor whiteColor];
    
    [self.contentView addSubview:recommend];
    
}
- (void)invitationBtnClickWith {
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
        
    }];
    
    [invitationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
