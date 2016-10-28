//
//  NSCommentTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationCommentCell.h"

@implementation NSCooperationCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupCooperationCommentCellUI];
    }
    return self;
}
- (void)setupCooperationCommentCellUI {

    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [moreBtn setTitle:@"更多留言" forState:UIControlStateNormal];
    
    [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:moreBtn];
    
    UILabel *cooperationNum = [[UILabel alloc] init];
    
    cooperationNum.text = @"已有23位巢人参与合作";
    
    cooperationNum.textAlignment = NSTextAlignmentRight;
    
    cooperationNum.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:cooperationNum];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.top.equalTo(self.contentView.mas_top).offset(5);
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [cooperationNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.top.equalTo(self.contentView.mas_top).offset(5);
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
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
