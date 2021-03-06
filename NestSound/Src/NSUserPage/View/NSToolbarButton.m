//
//  NSToolbarButton.m
//  NestSound
//
//  Created by Apple on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSToolbarButton.h"

@implementation NSToolbarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setTitleColor:[UIColor hexColorFloat:@"323232"] forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];

    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.centerX = self.width * 0.5;
    
    self.imageView.centerY = self.centerY * 0.75;
    
    CGFloat maxY = CGRectGetMaxY(self.imageView.frame);
    
    self.titleLabel.centerX = self.width * 0.5;
    
    self.titleLabel.y = maxY + 10;
    
    
}





@end
