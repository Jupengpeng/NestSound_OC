//
//  NSTopLBottomLView.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSTopLBottomLView.h"

@implementation NSTopLBottomLView
- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        [self  setupUI];
    }
    return self;
}

- (void)setupUI {
    self.topLabel = [UILabel new];
    
    _topLabel.textColor = [UIColor whiteColor];
    
    _topLabel.userInteractionEnabled = YES;
    
    _topLabel.textAlignment = NSTextAlignmentCenter;
    
    _topLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:_topLabel];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
                
    }];
    
    self.bottomLabel = [UILabel new];
    
    _bottomLabel.textColor = [UIColor whiteColor];
    
    _bottomLabel.userInteractionEnabled = YES;
    
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    _bottomLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:_bottomLabel];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self);
        
    }];
}
@end
