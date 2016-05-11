//
//  UIAlertView+NSAdditions.h
//  YueDong
//
//  Created by yandi on 15/12/9.
//  Copyright © 2015年 yinchao All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (NSAdditions)

@property (nonatomic,strong,readonly) NSMutableArray *alertTitles;
@property (nonatomic,copy,readonly) void (^clickBlock) (NSString *clickBtnTitle);

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                cancelBtnTitle:(NSString *)cancelBtnTitle
                         click:(void(^)(NSString *clickBtnTitle))clickBlock
                otherBtnTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION;

@end
