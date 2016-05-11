//
//  UINavigationItem+ILAdditions.h
//  iLight
//
//  Created by chang qin on 15/9/4.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (DDAdditions)

- (UIButton *)actionCustomLeftBarButton:(NSString *)title
                               nrlImage:(NSString *)nrlImage
                               hltImage:(NSString *)hltImage
                                 action:(void(^)())actionBlock;

- (UIButton *)actionCustomRightBarButton:(NSString *)title
                                nrlImage:(NSString *)nrlImage
                                hltImage:(NSString *)hltImage
                                  action:(void(^)())actionBlock;
@end
