//
//  NSShareViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
@class publicLyricModel;
@interface NSShareViewController : NSBaseViewController

@property (nonatomic,strong) NSMutableDictionary * shareDataDic;
@property (nonatomic,strong) publicLyricModel * publicModel;
@property (nonatomic,assign) BOOL lyricOrMusic;
@end
