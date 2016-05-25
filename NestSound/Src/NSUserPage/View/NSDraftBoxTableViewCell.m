//
//  NSDraftBoxTableViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDraftBoxTableViewCell.h"

@interface NSDraftBoxTableViewCell ()

@property (nonatomic, strong) UILabel *songName;

@property (nonatomic, strong) UIImageView *sendFailure;

@property (nonatomic, strong) UIImageView *songType;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation NSDraftBoxTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    self.songName = [[UILabel alloc] init];
    
    self.songName.font = [UIFont systemFontOfSize:15];
    
    self.songName.text = @"我在那一角落患过伤风";
    
    [self.contentView addSubview:self.songName];
    
    [self.songName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);
        
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    
    self.sendFailure = [[UIImageView alloc] init];
    
    self.sendFailure.image = [UIImage imageNamed:@"2.0_sendFailure"];
    
    [self.sendFailure sizeToFit];
    
    [self.contentView addSubview:self.sendFailure];
    
    [self.sendFailure mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.songName.mas_right).offset(10);
        
        make.centerY.equalTo(self.songName.mas_centerY);
        
    }];

    self.songType = [[UIImageView alloc] init];
    
    self.songType.image = [UIImage imageNamed:@"2.0_draft_lyric"];
    
    [self.songType sizeToFit];
    
    [self.contentView addSubview:self.songType];
    
    [self.songType mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.songName.mas_bottom).offset(10);
        
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    

    self.timeLabel = [[UILabel alloc] init];
    
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@  %@",@"05-20",@"12:42"];
    
    [self.contentView addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.songType.mas_right).offset(10);
        
        make.centerY.equalTo(self.songType.mas_centerY);
        
    }];
    

    self.sendBtn = [[UIButton alloc] init];
    
    [self.sendBtn setImage:[UIImage imageNamed:@"2.0_draft_send"] forState:UIControlStateNormal];
    
    [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sendBtn sizeToFit];
    
    [self.contentView addSubview:self.sendBtn];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
}

- (void)sendBtnClick:(UIButton *)sendBtn {
    
    if ([self.delegate respondsToSelector:@selector(draftBoxTableViewCell:withSendBtn:)]) {
        
        [self.delegate draftBoxTableViewCell:self withSendBtn:sendBtn];
    }
    
}

@end








