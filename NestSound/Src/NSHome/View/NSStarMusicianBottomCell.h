//
//  NSStarMusicianBottomCell.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//


#import <UIKit/UIKit.h>

@class NSWorklistModel;
typedef void(^NSStarMusicianBottomCellClickBlock)(UIButton *clickButton,NSWorklistModel *workListModel);


@interface NSStarMusicianBottomCell : UITableViewCell

@property (nonatomic,strong) NSWorklistModel *musicianModel;


@property (nonatomic,copy) NSStarMusicianBottomCellClickBlock clickBlock;


@end
