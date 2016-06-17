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
    [self.contentView addSubview:self.image];
    
    WS(wSelf);
    //constranits
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(wSelf.contentView);
    }];

}

@end
