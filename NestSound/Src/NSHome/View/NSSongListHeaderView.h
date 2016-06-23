//
//  NSSongListHeaderView.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class singListModel;
@interface NSSongListHeaderView : UIView

@property (nonatomic,strong) singListModel * singListType;
@property (nonatomic,strong) UIButton * playAllBtn;
@end
