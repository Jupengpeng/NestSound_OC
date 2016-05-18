//
//  NSPlusTabBar.m
//  NestSound
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPlusTabBar.h"

@interface NSPlusTabBar ()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation NSPlusTabBar

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *btn = [[UIButton alloc] init];
        
        [btn setImage:[UIImage imageNamed:@"2.0_plus_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_plus_selected"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(plusClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn sizeToFit];
        
        self.plusBtn = btn;
        
        [self addSubview:btn];
    }
    
    return self;
}

- (void)plusClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(plusTabBar:didSelectedPlusBtn:)]) {
        
        [self.delegate plusTabBar:self didSelectedPlusBtn:btn];
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.plusBtn.centerX = self.width * 0.5;
    
    self.plusBtn.centerY = self.height * 0.5;
    
    NSInteger count = self.subviews.count;
    
    CGFloat buttonWidth = self.width / 5;
    
    NSInteger index = 0;
    
    
    for (int i=0; i<count; i++) {
        
        UIView *childView = self.subviews[i];
        
        if ([childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            childView.width = buttonWidth;
            
            childView.x = buttonWidth * index;
            
            index += index == 1 ? 2 : 1;
        }
        
    }
    
}


@end
