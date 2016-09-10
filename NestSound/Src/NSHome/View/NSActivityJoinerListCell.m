//
//  NSActivityJoinerListCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityJoinerListCell.h"
#import "UIButton+WebCache.h"
#import "NSActivityJoinerListModel.h"
@interface NSActivityJoinerListCell ()

@property (nonatomic,strong) UIButton *headerButton;

@property (nonatomic,strong) UILabel *joinerNameLabel;

@property (nonatomic,strong) UILabel *descriptionLabel;

@property (nonatomic,strong) UIButton *followButton;

@end

@implementation NSActivityJoinerListCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        [self initUI];
    }
    return self;
}


- (void)initUI{
    
    self.headerButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {

        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 22.0f;
        
        
    } action:^(UIButton *btn) {
        
    }];
    [self addSubview:self.headerButton];
    
    [self.headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.width.mas_equalTo(44.0f);
        make.height.mas_equalTo(44.0f);
        make.top.equalTo(self.mas_top).offset(10);
        
    }];
    
    self.joinerNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.joinerNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.joinerNameLabel.textColor = [UIColor hexColorFloat:@"7d7d7d"];
    [self addSubview:self.joinerNameLabel];
    
    [self.joinerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerButton.mas_right).offset(11.0f);
        make.top.equalTo(self.mas_top).offset(16.0f);
        make.right.equalTo(self.mas_right).offset(15.0f);
    }];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
    self.descriptionLabel.textColor = [UIColor hexColorFloat:@"a3a3a3"];
    [self addSubview:self.descriptionLabel];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerButton.mas_right).offset(11.0f);
        make.top.equalTo(self.joinerNameLabel.mas_bottom).offset(8);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
    
    /**
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {

        
    } action:^(UIButton *btn) {
        
        
    }];
    
    [self addSubview:self.followButton];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(13.0f);
        make.right.equalTo(self.mas_right).offset(- 14.0f);
        make.height.mas_equalTo(36.0f);
        make.width.mas_equalTo(44.0f);
    }];
     */
 

}

- (void)setDetailModel:(NSActivityJoinerDetailModel *)detailModel{
    _detailModel =detailModel;
    
    [self.headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:detailModel.headurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    
    self.joinerNameLabel.text = detailModel.nickname;
    
    if (detailModel.descr.length) {
        self.descriptionLabel.text = detailModel.descr;

    }else{
        self.descriptionLabel.text = @"这个人很懒什么都没留下";

    }
    
}

- (void)setupData{
        

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
