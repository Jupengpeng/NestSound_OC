//
//  NSBaseNavigationController.h
//  NestSound
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NSBaseNavigationController : UINavigationController
@property (nonatomic,strong) UIButton * playStatusBtn;
- (void)backClick:(UIBarButtonItem *)back;
@end
