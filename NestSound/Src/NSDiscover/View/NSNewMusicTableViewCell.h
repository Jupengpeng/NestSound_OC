//
//  NSNewMusicTableViewCell.h
//  NestSound
//
//  Created by Apple on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSBandMusic;
@class NSMyMusicModel;
@class NSCooperateProductModel;

@interface NSNewMusicTableViewCell : UITableViewCell

//排行数字
@property (nonatomic, strong) UILabel *numLabel;

//是否公开
@property (nonatomic, strong) UIImageView *secretImgView;

@property (nonatomic,assign) long itemId;

//日期
- (void)addDateLabel;

@property (nonatomic,strong) NSBandMusic * musicModel;

@property (nonatomic,strong) NSMyMusicModel * myMusicModel;

@property (nonatomic,strong) NSCooperateProductModel *coWorkModel;

@end
