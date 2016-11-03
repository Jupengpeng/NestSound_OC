//
//  NSMyCooperationTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMyCooperationTableViewCell.h"
#import "NSMyCooperationListModel.h"
@interface NSMyCooperationTableViewCell ()
{
    //日期
    UILabel *dateLabel;
    //作品名称
    UILabel * workNameLabel;
    //合作状态
    UILabel * statusLabel;
}
@end

@implementation NSMyCooperationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupMyCooperationCell];
    }
    return self;
}
- (void)setupMyCooperationCell {
    //
    workNameLabel = [[UILabel alloc] init];
    
    workNameLabel.text = @"从你的全世界路过";
    
    workNameLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:workNameLabel];
    
    //
    dateLabel = [[UILabel alloc] init];
    
    dateLabel.text = @"2016.10.25 21:00";
    
    dateLabel.font = [UIFont systemFontOfSize:12];
    
    dateLabel.textColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:dateLabel];
    
    //
    statusLabel = [[UILabel alloc] init];
    
    statusLabel.text = @"合作成功";
    
    statusLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:statusLabel];
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [workNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.contentView).offset(10);
        
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.top.equalTo(workNameLabel.mas_bottom).offset(10);
    }];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
}
- (void)setMyCooperation:(myCooperationModel *)myCooperation {
    _myCooperation = myCooperation;
    workNameLabel.text = myCooperation.cooperationTitle;
    dateLabel.text = [date datetoLongLongStringWithDate:myCooperation.createTime];
    switch (myCooperation.status) {
        case 1:
            statusLabel.text = [NSString stringWithFormat:@"%ld",myCooperation.workNum];
            statusLabel.textColor = [UIColor lightGrayColor];
            break;
        case 3:
            statusLabel.text = @"已经删除";
            statusLabel.textColor = [UIColor redColor];
            break;
        case 4:
            statusLabel.text = @"已经到期";
            statusLabel.textColor = [UIColor redColor];
            break;
        case 8:
            statusLabel.text = @"合作成功";
            statusLabel.textColor = [UIColor hexColorFloat:@"ffd705"];
            break;
        default:
            break;
    }
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
