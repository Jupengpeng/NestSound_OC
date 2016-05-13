//
//  NSNewMusicViewController.h
//  NestSound
//
//  Created by Apple on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@interface NSNewMusicViewController : NSBaseViewController

@property (nonatomic,copy) NSString * MusicType;

-(instancetype)initWithType:(NSString *)type;
@end
