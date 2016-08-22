//
//  NSBiaoqianView.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBiaoqianView.h"
#import "NSTool.h"

@interface NSBiaoqianView ()

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UIImageView *biaoqianImage;

@end

@implementation NSBiaoqianView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self) {
        self = [super initWithFrame:frame];
        [self initUI];
    }
    return self;
}


- (void)initUI{
    self.biaoqianImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31.3, 11)];
    self.biaoqianImage.image = [UIImage imageNamed:@"biaoqian"];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        btn.height = 11.0f;
        btn.y = 0;
        btn.backgroundColor = [UIColor hexColorFloat:@"000000"];

    } action:^(UIButton *btn) {
        
    }];
    
    
    [self addSubview:self.biaoqianImage];
    [self addSubview:self.button];
}



- (void)setTitle:(NSString *)title{
    
    /**
     *  计算宽度
     */
    self.button.width = [NSTool getWidthWithContent:title font:[UIFont systemFontOfSize:10.0f]];
    self.button.x = 12.0f;
    self.width = self.button.width + 12.0f;
    [self.button setTitle:title forState:UIControlStateNormal];
    [self bringSubviewToFront:self.button];
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    self.button.hidden = hidden;
    self.biaoqianImage.hidden = hidden;
}



@end
