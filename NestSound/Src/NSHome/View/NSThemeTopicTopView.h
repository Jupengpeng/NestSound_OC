//
//  NSThemeTopicTopView.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

static NSInteger const kTopViewLabelTag = 151;

typedef void(^NSThemeTopicTopViewDescriptionClickBlock)(BOOL isFoledOn);
typedef void(^NSThemeTopicTopViewHeaderClickBlock)(NSInteger index, id);

#import <UIKit/UIKit.h>

@interface NSThemeTopicTopView : UIView

@property (nonatomic,strong) TTTAttributedLabel *descriptionLabel;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,assign) BOOL isFoldOn;

@property (nonatomic,copy) NSThemeTopicTopViewDescriptionClickBlock descriptionBlock;
@property (nonatomic,copy) NSThemeTopicTopViewHeaderClickBlock headerClickBlock;


- (void)setupDataWithData:(id)data descriptionIsFoldOn:(BOOL)isFoldOn;

@end
