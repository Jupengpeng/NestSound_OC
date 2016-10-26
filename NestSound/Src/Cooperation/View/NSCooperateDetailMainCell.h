//
//  NSCooperateDetailMainCell.h
//  NestSound
//
//  Created by yintao on 2016/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//


typedef void(^NSCooperateDetailMainCellHeightBlock)(CGFloat height);

#import <UIKit/UIKit.h>

@interface NSCooperateDetailMainCell : UITableViewCell

@property (nonatomic,assign) CGFloat totalHeight;

- (void)showDataWithModel:(id)model completion:(NSCooperateDetailMainCellHeightBlock)completion;

@end
