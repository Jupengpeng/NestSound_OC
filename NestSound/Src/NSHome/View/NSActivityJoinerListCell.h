//
//  NSActivityJoinerListCell.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//


typedef void(^NSActivityJoinerListCellFollowBlock)(NSString *uid);
@class NSActivityJoinerDetailModel;
#import <UIKit/UIKit.h>

@interface NSActivityJoinerListCell : UITableViewCell


@property (nonatomic,strong) NSActivityJoinerDetailModel *detailModel;

@property (nonatomic,copy) NSActivityJoinerListCellFollowBlock followBlock;

@end
