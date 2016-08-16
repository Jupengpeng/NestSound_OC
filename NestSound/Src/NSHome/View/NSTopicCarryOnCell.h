//
//  NSTopicCarryOnCell.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

typedef void(^NSTopicCarryOnCellTopicClickBlock)(NSInteger clickIndex);

#import <UIKit/UIKit.h>

@interface NSTopicCarryOnCell : UICollectionViewCell

- (void)setupDataWithTopicArray:(NSMutableArray *)topicArray;


@property (nonatomic,copy) NSTopicCarryOnCellTopicClickBlock topicClickBlock;

@end
