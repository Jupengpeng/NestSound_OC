//
//  NSSongCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class songModel;
@interface NSSongCell : UITableViewCell

@property (nonatomic,assign) NSInteger  number;
@property (nonatomic, strong) UIImageView *playImg;
@property (nonatomic, strong) UILabel * numberLab;
@property (nonatomic, assign) BOOL index;
@property (nonatomic,strong) songModel * songModel;

@end
