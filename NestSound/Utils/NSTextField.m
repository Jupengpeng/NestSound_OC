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
    iconRect.origin.x += 5;// 右偏5
    return iconRect;
}
// 修改文本展示区域，一般跟editingRectForBounds一起重写
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+24, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+24, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
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
    iconRect.origin.x -= 5;// 左偏5
    return iconRect;
}
@end
