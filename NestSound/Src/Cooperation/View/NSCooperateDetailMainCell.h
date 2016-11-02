//
//  NSCooperateDetailMainCell.h
//  NestSound
//
//  Created by yintao on 2016/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//


typedef void(^NSCooperateDetailMainCellHeightBlock)(CGFloat height);
typedef void(^NSCooperateDetailMainCellUserPageClickBlock)(NSString *userId);

#import <UIKit/UIKit.h>

@interface NSCooperateDetailMainCell : UITableViewCell

@property (nonatomic,assign) CGFloat totalHeight;

@property (nonatomic,copy) NSCooperateDetailMainCellUserPageClickBlock userClickBlock;

- (void)showDataWithModel:(id)model completion:(NSCooperateDetailMainCellHeightBlock)completion;

@end
