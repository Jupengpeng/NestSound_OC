//
//  UIActionSheet+NSAdditions.h
// YueDong
//
//  Created by Jing Li on 15/11/14.
//  Copyright © 2015年 yinchao All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (NSAdditions)

@property (nonatomic,strong,readonly) NSMutableArray *sheetTitles;
@property (nonatomic,copy,readonly) void (^clickBlock) (NSString *clickBtnTitle);

+ (UIActionSheet *)showWithTitle:(NSString *)title
                  cancelBtnTitle:(NSString *)cancelBtnTitle
                           click:(void(^)(NSString *clickBtnTitle))clickBlock
                  otherBtnTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION;
@end
