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
        self.layer.cornerRadius = 3;
        topImgView = [[UIImageView alloc] init];
        topImgView.layer.cornerRadius = 3;
        topImgView.layer.masksToBounds = YES;
        [self addSubview:topImgView];
        
        midLabel = [[UILabel alloc] init];
        midLabel.numberOfLines = 0;
        midLabel.textAlignment = NSTextAlignmentCenter;
        midLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:midLabel];
        
        leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        leftBtn.layer.cornerRadius = 3;
        leftBtn.layer.masksToBounds = YES;
        leftBtn.backgroundColor = [UIColor lightGrayColor];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];

        rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.layer.cornerRadius = 3;
        rightBtn.layer.masksToBounds = YES;
        rightBtn.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(188);
    }];
    
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(topImgView.mas_bottom).offset(5);
        make.height.mas_equalTo(66);
    }];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.bottom.equalTo(self.mas_bottom).offset(-14);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(38);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-14);
        make.bottom.equalTo(self.mas_bottom).offset(-14);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(38);
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
