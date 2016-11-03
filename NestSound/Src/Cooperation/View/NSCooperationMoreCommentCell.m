//
//  NSCooperationMoreCommentCell.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationMoreCommentCell.h"
#import "NSCooperationListModel.h"
@interface NSCooperationMoreCommentCell ()
{
    UILabel *moreMessage;
    UILabel *cooperationNum;
}
@end

@implementation NSCooperationMoreCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupCooperationCommentCellUI];
    }
    return self;
}
- (void)setupCooperationCommentCellUI {

    moreMessage = [[UILabel alloc] init];
    
    moreMessage.text = @"更多留言";
    
    moreMessage.textColor = [UIColor lightGrayColor];
    
    moreMessage.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:moreMessage];
    
    cooperationNum = [[UILabel alloc] init];
    
    cooperationNum.text = @"已有0位巢人参与合作";
    
    cooperationNum.textAlignment = NSTextAlignmentRight;
    
    cooperationNum.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:cooperationNum];
    
    [moreMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
- (void)setCooperationModel:(CooperationModel *)cooperationModel {
    _cooperationModel = cooperationModel;
    moreMessage.text = [NSString stringWithFormat:@"更多%d条留言",cooperationModel.commentNum];
    cooperationNum.text = [NSString stringWithFormat:@"已有%d位巢人参与合作",cooperationModel.workNum];
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
