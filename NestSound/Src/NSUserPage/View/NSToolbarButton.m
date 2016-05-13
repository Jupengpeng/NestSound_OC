//
//  NSToolbarButton.m
//  NestSound
//
//  Created by Apple on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSToolbarButton.h"

@implementation NSToolbarButton

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image addTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupWithImage:image addTitle:title];
    }
    
    return self;
}


- (void)setupWithImage:(UIImage *)image addTitle:(NSString *)title {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.image = image;
    
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX);
        
        make.top.equalTo(self.mas_top).offset(8);
        
    }];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = [UIColor hexColorFloat:@"666666"];
    
    label.font = [UIFont systemFontOfSize:12];
    
    label.text = title;
    
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        
        make.top.equalTo(imageView.mas_bottom).offset(5);
        
    }];
}





@end
