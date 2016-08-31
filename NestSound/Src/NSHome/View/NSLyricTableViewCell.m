//
//  NSLyricTableViewCell.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/10.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricTableViewCell.h"

@implementation NSLyricTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupLyricCellUI];
    }
    return self;
}

- (void)setupLyricCellUI {
    if (!self.leftImgView) {
        self.leftImgView = [UIImageView new];

    }
    
    _leftImgView.image = [UIImage imageNamed:@"2.0_select_icon"];
    
    _leftImgView.hidden = YES;
    
    [self.contentView addSubview:_leftImgView];
    
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.size.mas_equalTo(CGSizeMake(10, 10));
        
    }];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, ScreenWidth - 70, 10)];
//    rightLabel.text = self.lyricsArray[indexPath.row];
    _rightLabel.font = [UIFont systemFontOfSize:15];
    
    _rightLabel.numberOfLines = 0;
    
    _rightLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
    
    _rightLabel.backgroundColor = [UIColor clearColor];
    
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_rightLabel];
}

//- (void)layoutSubviews {
//    
//    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        
//        make.left.equalTo(self.contentView.mas_left).offset(10);
//        
//        make.size.mas_equalTo(CGSizeMake(10, 10));
//        
//    }];
//    
//    _rightLabel.frame = CGRectMake(40, 10, ScreenWidth - 70, 10);
//    
//}

//- (void)setLyric:(NSString *)lyric {
//    
//    self.lyric = lyric;
//    
//    self.rightLabel.text = lyric;
//    
//    NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
//    
//    CGFloat height = [self.lyric boundingRectWithSize:CGSizeMake(ScreenWidth-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:fontDic context:nil].size.height;
//    
//    _rightLabel.height = height;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
