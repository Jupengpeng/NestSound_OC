//
//  NSPreserveTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/9/12.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveTableViewCell.h"
#import "NSPreserveListModel.h"
@interface NSPreserveTableViewCell ()
{
    UILabel *leftLabel;
    UILabel *rightLabel;
    UIImageView *leftImgView;
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
    //leftImgView
    leftImgView = [[UIImageView alloc] init];
    leftImgView.image = [UIImage imageNamed:@"2.2_preserveAll"];
    [self addSubview:leftImgView];
    
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
    statusLabel.textColor = [UIColor darkGrayColor];
    statusLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:statusLabel];
    
}
#pragma mark -layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImgView.mas_right).offset(10);
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
- (void)setPreserveModel:(NSPreserveModel *)preserveModel {
    
    switch (preserveModel.sortId) {
        case 1:
            leftImgView.image = [UIImage imageNamed:@"2.2_preserveMusic"];
            break;
        case 2:
            leftImgView.image = [UIImage imageNamed:@"2.2_preserveLyric"];
            break;
        case 3:
            leftImgView.image = [UIImage imageNamed:@"2.2_preserveAll"];
            break;
        default:
            break;
    }
    if (preserveModel.status == 3) {
        statusLabel.text = @"保全失败";
        statusLabel.textColor = [UIColor redColor];
    } else if (preserveModel.status == 1) {
        statusLabel.text = @"保全成功";
    } else if (preserveModel.status == 2){
        statusLabel.text = @"保全认证中...";
        statusLabel.textColor = [UIColor orangeColor];
    }
    leftLabel.text = preserveModel.preserveName;
    rightLabel.text = [date  datetoLongLongStringWithDate:[preserveModel.createTime longLongValue]];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
