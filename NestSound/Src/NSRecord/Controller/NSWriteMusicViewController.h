//
//  NSWriteMusicViewController.h
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
@class NSAccommpanyModel;
@class CoWorkModel;

@interface NSWriteMusicViewController : NSBaseViewController<UIScrollViewDelegate>

//@property (nonatomic,strong) NSAccommpanyModel * accompanyModel;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) NSArray * descibelArray;
//@property (nonatomic,strong) NSArray *urlStrArr;
//@property (nonatomic,assign) NSInteger accompanyId;
@property (nonatomic,strong) NSMutableDictionary * descibelDictionary;


/**
 *  活动id
 */
@property (nonatomic,copy) NSString *aid;

//合作作品的歌词信息
@property (nonatomic,strong) CoWorkModel *coWorkModel;


-(instancetype)initWithItemId:(long)itemID_ andMusicTime:(long)musicTime andHotMp3:(NSString *)hotMp3;

@end
