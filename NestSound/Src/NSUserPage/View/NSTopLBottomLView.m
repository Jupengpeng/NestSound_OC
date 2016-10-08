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
    
    _topLabel.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:_topLabel];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
                
    }];
    
//    self.tipView = [UIView new];
//    
//    _tipView.hidden = YES;
//    
//    _tipView.backgroundColor = [UIColor redColor];
//    
//    _tipView.layer.cornerRadius = 3;
//    
//    [self addSubview:_tipView];
    
//    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.right.equalTo(_topLabel.mas_right).offset(2);
//        
//        make.top.equalTo(_topLabel.mas_top).offset(0);
//        
//        make.size.mas_offset(CGSizeMake(6, 6));
//        
//    }];
    
    self.bottomLabel = [UILabel new];
    
    _bottomLabel.textColor = [UIColor whiteColor];
    
    _bottomLabel.userInteractionEnabled = YES;
    
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    _bottomLabel.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:_bottomLabel];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self);
        
    }];
}
@end
