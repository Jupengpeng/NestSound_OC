//
//  NSDownloadProgressView.h
//  NestSound
//
//  Created by 李龙飞 on 16/7/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDownloadProgressView : UIView
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *bottomLab;
@property (nonatomic, strong) NSDictionary *downloadDic;
@end
