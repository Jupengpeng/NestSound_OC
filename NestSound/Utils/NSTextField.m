//
//  NSTextField.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSTextField.h"

@implementation NSTextField
-(id)initWithFrame:(CGRect)frame drawingLeft:(UIImageView *)icon{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.6;
        self.layer.masksToBounds = YES;
        self.textColor = [UIColor darkGrayColor];
    }
    return self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 6;// 右偏6
    return iconRect;
}
- (id)initWithFrame:(CGRect)frame drawingRight:(UIImageView *)icon {
    self = [super initWithFrame:frame];
    if (self) {
        self.rightView = icon;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.6;
        self.layer.masksToBounds = YES;
    }
    return self;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -= 6;// 左偏6
    return iconRect;
}
@end
