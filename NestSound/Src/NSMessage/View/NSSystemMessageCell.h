//
//  NSSystemMessageCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSSystemMessageCell : UITableViewCell

@property (nonatomic,copy) NSString * headViewUrl;
@property (nonatomic,copy) NSString * DateString;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,assign) BOOL isTu;
@end
