//
//  NSImageCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSImageCell.h"

@implementation NSImageCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

-(void)configureUI
{
    self.image = [[UIImageView alloc] init];
    [self.image setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.image.contentMode =  UIViewContentModeScaleAspectFill;
    self.image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.image.clipsToBounds  = YES;
    [self.contentView addSubview:self.image];
    
    WS(wSelf);
    //constranits
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(wSelf.contentView);
    }];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"2.0_cross"] forState:UIControlStateNormal];
    [_deleteBtn sizeToFit];
    [self.contentView addSubview:_deleteBtn];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.contentView).with.offset(2);
        make.right.equalTo(wSelf.contentView).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

@end
