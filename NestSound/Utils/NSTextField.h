//
//  NSTextField.h
//  NestSound
//
//  Created by 李龙飞 on 16/8/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSTextField : UITextField
@property (nonatomic, assign) id<UITextFieldDelegate> delegate;
-(id)initWithFrame:(CGRect)frame drawingLeft:(UIImageView*)icon;
-(id)initWithFrame:(CGRect)frame drawingRight:(UIImageView*)icon;
@end
