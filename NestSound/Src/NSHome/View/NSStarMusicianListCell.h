//
//  NSStarMusicianListCell.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

@class NSMusicianListDetailModel;

#import <UIKit/UIKit.h>

@interface NSStarMusicianListCell : UITableViewCell

@property (nonatomic,strong) NSMusicianListDetailModel *musicianModel;

- (void)updateUIWithData;


@end
