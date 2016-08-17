//
//  NSTemplateTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSTemplateTableViewCell.h"
#import "NSDrawLineView.h"
@implementation NSTemplateTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupTemplateCellUI];
        
    }
    return self;
}
- (void)setupTemplateCellUI {
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 20)];
    
    _topLabel.textColor = [UIColor lightGrayColor];
    
    _topLabel.textAlignment = NSTextAlignmentCenter;
    
    _topLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:_topLabel];
    
    self.bottomTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth - 20, 20)];
    
    _bottomTF.borderStyle = UITextBorderStyleNone;
    
    _bottomTF.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_bottomTF];
    
    NSDrawLineView * line = [[NSDrawLineView alloc] initWithFrame:CGRectMake(20, 60, ScreenWidth - 40, 0.8)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:line];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
