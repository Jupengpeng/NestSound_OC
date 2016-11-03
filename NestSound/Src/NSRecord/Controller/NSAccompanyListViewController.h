//
//  NSAccompanyListViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
@class CoWorkModel;

@interface NSAccompanyListViewController : NSBaseViewController

/**
 *  活动id
 */
@property (nonatomic,copy) NSString *aid;


//合作作品的歌词信息
@property (nonatomic,strong) CoWorkModel *coWorkModel;



@end
