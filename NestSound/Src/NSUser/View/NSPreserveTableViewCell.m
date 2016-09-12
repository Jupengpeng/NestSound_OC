//
//  NSPreserveTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/9/12.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveTableViewCell.h"

@interface NSPreserveTableViewCell ()
{
    UILabel *leftLabel;
    UILabel *rightLabel;
    UIImageView *midImgView;
}
@end

@implementation NSPreserveTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)configurePreserveCellUIAppearance {
    //titleLabel
    leftLabel = [[UILabel alloc] init];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.textColor = [UIColor hexColorFloat:@"1818181"];
    leftLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:leftLabel];
    
    //dateLabel or state
    rightLabel = [[UILabel alloc] init];
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.textColor = [UIColor hexColorFloat:@"999999"];
    rightLabel.font = [UIFont systemFontOfSize:9];
    [self addSubview:rightLabel];
    
    midImgView = [[UIImageView alloc] init];
    midImgView.image = [UIImage imageNamed:@"2.0_modify"];
    [self addSubview:midImgView];
}
#pragma mark -layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(22);
        make.right.equalTo(self.mas_right).with.offset(-40);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_left);
        make.top.equalTo(leftLabel.mas_bottom).with.offset(6);
        make.right.equalTo(leftLabel.mas_right);
    }];
    
    [midImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(14);
    }];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
