//
//  UITextField+NSAdditions.m
//  NestSound
//
//  Created by yinchao on 16/10/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "UITextField+NSAdditions.h"

@implementation UITextField (NSAdditions)
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, ScreenWidth,44)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 60, 7,50, 30)];
    [button setTitle:@"完成"forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:22.0/255 green:104.0/255 blue:249.0/255 alpha:1.0];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    button.layer.borderColor = [UIColor redColor].CGColor;
//    button.layer.borderWidth =1;
    button.layer.cornerRadius =3;
    [bar addSubview:button];
    self.inputAccessoryView = bar;
    
    [button addTarget:self action:@selector(print)forControlEvents:UIControlEventTouchUpInside];
}

- (void) print {
    [self resignFirstResponder];
    NSLog(@"button click");
}

@end
