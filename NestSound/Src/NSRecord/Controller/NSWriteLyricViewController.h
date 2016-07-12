//
//  NSWriteLyricViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@interface NSWriteLyricViewController: NSBaseViewController
@property (nonatomic,copy) NSString *lyricTitle,*lyricText,*lyricDetail,*lyricImgUrl;
@property (nonatomic,assign) long lyricId;
@end
