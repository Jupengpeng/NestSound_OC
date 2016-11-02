//
//  NSCooperateDetailWorkCell.h
//  NestSound
//
//  Created by yintao on 2016/11/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NSCooperateDetailWorkCellAcceptBlock)(NSString *workId);

@interface NSCooperateDetailWorkCell : UITableViewCell


@property (nonatomic,copy) NSCooperateDetailWorkCellAcceptBlock acceptBlock;

- (void)setupData;

@end
