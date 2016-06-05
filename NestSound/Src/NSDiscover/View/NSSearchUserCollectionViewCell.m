
//
//  NSSearchUserCollectionViewCell.m
//  NestSound
//
//  Created by Apple on 16/6/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSearchUserCollectionViewCell.h"

@interface NSSearchUserCollectionViewCell ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation NSSearchUserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    
    icon.image = [UIImage imageNamed:@"2.0_addPicture"];
    
    self.icon = icon;
    
    [self.contentView addSubview:icon];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    nameLabel.font = [UIFont systemFontOfSize:12];
    
    nameLabel.text = @"谢豪杰";
    
    self.nameLabel = nameLabel;
    
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        
        make.right.equalTo(self.contentView.mas_right);
        
        make.top.equalTo(icon.mas_bottom);
        
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
}

@end
