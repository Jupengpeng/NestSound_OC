//
//  NSUpvoteMessageCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSUpvoteMessageCell : UITableViewCell

@property (nonatomic,copy) NSString * headUrl;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * createDate;
@property (nonatomic,copy) NSString * workName;
@property (nonatomic,copy) NSString * authorName;
@property (nonatomic,copy) NSString * titlePageUrl;
@property (nonatomic,assign) BOOL isUpvote;
@end
