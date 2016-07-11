//
//  NSShareView.h
//  NestSound
//
//  Created by 李龙飞 on 16/7/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSShareView : UIView
//@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic, strong) NSDictionary *shareDic;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *urlResource;
@end
