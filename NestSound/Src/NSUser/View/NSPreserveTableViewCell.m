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
    UILabel *statusLabel;
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
    //midImgView
    midImgView = [[UIImageView alloc] init];
    midImgView.image = [UIImage imageNamed:@"2.2_preserveAll"];
    [self addSubview:midImgView];
    
    //titleLabel
    leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"保全申请保全申请";
    leftLabel.textColor = [UIColor hexColorFloat:@"1818181"];
    leftLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:leftLabel];
    
    //dateLabel
    rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"2016-08-15";
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor hexColorFloat:@"999999"];
    rightLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:rightLabel];
    
    //statusLabel
    statusLabel = [[UILabel alloc] init];
    statusLabel.text = @"保全成功";
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.textColor = [UIColor hexColorFloat:@"999999"];
    statusLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:statusLabel];
    
}
#pragma mark -layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [midImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midImgView.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(44);
        make.right.equalTo(rightLabel.mas_left).offset(-10);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(midImgView.mas_right);
        make.top.equalTo(self.mas_top).offset(6);
        make.height.mas_offset(15);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.mas_bottom).offset(-6);
        make.height.mas_offset(15);
        make.right.equalTo(self.mas_right).offset(-10);
        
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
