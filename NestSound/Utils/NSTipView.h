//
//  NSTipView.h
//  NestSound
//
//  Created by yinchao on 16/10/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NSTipViewDelegate <NSObject>

- (void)ensureBtnClick;
- (void)cancelBtnClick;
@end

@interface NSTipView : UIView


/** 1.图片*/
@property (nonatomic, copy) NSString *imgName;
/** 2.提示标题*/
@property (nonatomic, copy) NSString *tipText;
/** 3.设置代理 */
@property (nonatomic, assign) id <NSTipViewDelegate> delegate;

@end
