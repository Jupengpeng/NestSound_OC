//
//  NSFanscell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSFanscell : UITableViewCell

@property (nonatomic,copy) NSString * headUrl;
@property (nonatomic,copy) NSString * authorName;
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,assign) BOOL isFocus;
@end
