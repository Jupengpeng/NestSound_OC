//
//  NSCacheProductCell.m
//  NestSound
//
//  Created by yinchao on 2016/11/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCacheProductCell.h"

@interface NSCacheProductCell ()
{
    UILabel *titleLabel;
    UILabel *dateLabel;
}
@end

@implementation NSCacheProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupCacheProductCellUI];
    }
    return self;
}
- (void)setupCacheProductCellUI {
    
    //标题
    titleLabel = [[UILabel alloc] init];
    
    titleLabel.text = @"为你钟情";
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        
        make.top.equalTo(self.mas_top).offset(10);
        
    }];
    //时间
    dateLabel = [[UILabel alloc] init];
    
    dateLabel.font = [UIFont systemFontOfSize:10];
    
    dateLabel.textColor = [UIColor hexColorFloat:@"bababa"];
    
    dateLabel.textAlignment = NSTextAlignmentRight;
    
    dateLabel.text = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    [self.contentView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
//        make.width.mas_equalTo(ScreenWidth/2);
        
    }];
    
    //上传
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    
    uploadBtn.layer.borderWidth = 0.5;
    
    uploadBtn.layer.borderColor = [[UIColor hexColorFloat:@"ffd705"] CGColor];
    
    uploadBtn.layer.cornerRadius = 3;
    
    uploadBtn.layer.masksToBounds= YES;
    
    [self.contentView addSubview:uploadBtn];
    
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-10);
        
        make.centerY.equalTo(self.mas_centerY);
        
        make.size.mas_offset(CGSizeMake(40, 20));
        
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
