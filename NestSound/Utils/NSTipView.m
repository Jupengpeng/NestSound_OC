//
//  NSTipView.m
//  NestSound
//
//  Created by yinchao on 16/10/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSTipView.h"

@interface NSTipView ()
{
    UIImageView *topImgView;
    UILabel *midLabel;
    UIButton *leftBtn;
    UIButton *rightBtn;
}


@end

@implementation NSTipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        
        topImgView = [[UIImageView alloc] init];
        
//        topImgView.layer.cornerRadius = 4;
//        topImgView.layer.masksToBounds = YES;
        [self addSubview:topImgView];
        
        midLabel = [[UILabel alloc] init];
        midLabel.numberOfLines = 0;
        midLabel.textColor = [UIColor hexColorFloat:@"333333"];
        midLabel.textAlignment = NSTextAlignmentCenter;
        midLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:midLabel];
        
        leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        leftBtn.layer.cornerRadius = 3;
        leftBtn.layer.masksToBounds = YES;
        leftBtn.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor hexColorFloat:@"666666"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];

        rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.layer.cornerRadius = 3;
        rightBtn.layer.masksToBounds = YES;
        rightBtn.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor hexColorFloat:@"333333"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];

    }
    return self;
}
- (void)leftBtnClick {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    if ([self.delegate respondsToSelector:@selector(cancelBtnClick)]) {
        
        [self.delegate cancelBtnClick];
    }
}
- (void)rightBtnClick {
    if ([self.delegate respondsToSelector:@selector(ensureBtnClick)]) {
        
        [self.delegate ensureBtnClick];
    }
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(self.height * 194/338.0f);
    }];
    
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.width - 20);
        make.top.equalTo(topImgView.mas_bottom).offset(8);
        make.height.mas_equalTo(66);
    }];
    
    CGFloat offSet =self.width * 55/256.0f;
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(14);
        make.centerX.equalTo(self.mas_centerX).offset(-offSet);
        make.bottom.equalTo(self.mas_bottom).offset(-(self.height * 14/338.0f));
        make.width.mas_equalTo(self.width * 90/256.0f);
        make.height.mas_equalTo(self.height * 38/338.0);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-14);
        make.centerX.equalTo(self.mas_centerX).offset(offSet);
        make.bottom.equalTo(self.mas_bottom).offset(- (self.height * 14/338.0f));
        make.width.mas_equalTo(self.width * 90/256.0f);
        make.height.mas_equalTo(self.height * 38/338.0);
    }];
}
- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    topImgView.image = [UIImage imageNamed:self.imgName];
}
- (void)setTipText:(NSString *)tipText {
    _tipText = tipText;


    midLabel.text = self.tipText;
}
@end
