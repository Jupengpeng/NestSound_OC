//
//  NSPreserveTypeView.h
//  NestSound
//
//  Created by yintao on 16/9/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

typedef void(^NSPreserveTypeViewChooseBlock)(NSString *typeStr,NSInteger typeId);

#import <UIKit/UIKit.h>


@interface NSPreserveTypeView : UIView

@property (nonatomic,copy) NSPreserveTypeViewChooseBlock chooseTypeBlock;

- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr;



- (void)show;

- (void)disMiss;

@end
