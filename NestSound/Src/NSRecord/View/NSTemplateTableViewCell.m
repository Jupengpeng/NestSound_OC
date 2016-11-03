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
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 20, 20)];
    
    _topLabel.numberOfLines = 2;
    
    _topLabel.textColor = [UIColor lightGrayColor];
    
    _topLabel.textAlignment = NSTextAlignmentCenter;
    
    _topLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:_topLabel];
    
    self.bottomTF = [UITextField new];
    
    _bottomTF.borderStyle = UITextBorderStyleNone;
    
    _bottomTF.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_bottomTF];
    [_bottomTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.height.mas_offset(20);
        
    }];
    NSDrawLineView * line = [[NSDrawLineView alloc] init];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-3);
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.height.mas_offset(0.8);
    }];
}
- (void)setTemplateLyric:(NSString *)templateLyric {
    
    _templateLyric = templateLyric;
    
    self.topLabel.text = templateLyric;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGFloat height = [templateLyric boundingRectWithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:dic context:nil].size.height;
    if (height > 40) {
        self.topLabel.height = 40;
    } else {
    self.topLabel.height = height;
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
