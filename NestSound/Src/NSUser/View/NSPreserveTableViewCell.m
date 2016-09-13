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
        [self configurePreserveCellUIAppearance];
    }
    return self;
}
-(void)configurePreserveCellUIAppearance {
    //titleLabel
    leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"保全申请保全申请";
    leftLabel.textColor = [UIColor hexColorFloat:@"1818181"];
    leftLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:leftLabel];
    
    //dateLabel or state
    rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"2016-08-15";
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.textColor = [UIColor hexColorFloat:@"999999"];
    rightLabel.font = [UIFont systemFontOfSize:12];
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
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(44);
//        make.right.equalTo(self.mas_right).with.offset(-40);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(midImgView.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [midImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(leftLabel.mas_right).with.offset(10);
        make.width.mas_equalTo(14);
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
