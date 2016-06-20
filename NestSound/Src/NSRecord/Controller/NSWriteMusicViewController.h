//
//  NSWriteMusicViewController.h
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
@class NSAccommpanyModel;

@interface NSWriteMusicViewController : NSBaseViewController

@property (nonatomic,strong) NSAccommpanyModel * accompanyModel;

-(instancetype)initWithItemId:(long)itemID_;

@end
