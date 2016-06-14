//
//  NSImportLyricViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@protocol ImportLyric <NSObject>
-(void)selectLyric:(NSString *)lyrics withMusicName:(NSString *)musicName;
@end

@interface NSImportLyricViewController : NSBaseViewController

@property (nonatomic,weak) id <ImportLyric> delegate;
@end
