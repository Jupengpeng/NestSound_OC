//
//  NSComposeView.h
//  NestSound
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSComposeView;

@protocol NSComposeViewDelegate <NSObject>

- (void)composeView:(NSComposeView *)composeView withComposeButton:(UIButton *)composeBtn;

@end


@interface NSComposeView : UIView

- (void)startAnimation;

@property (nonatomic, weak) id<NSComposeViewDelegate> delegate;

@end
