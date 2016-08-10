//
//  NSLyricTableViewCell.h
//  NestSound
//
//  Created by 李龙飞 on 16/8/10.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLyricTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) NSString *lyric;
@end
