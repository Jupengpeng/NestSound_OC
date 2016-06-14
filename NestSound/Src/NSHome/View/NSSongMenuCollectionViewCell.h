//
//  NSSongMenuCollectionViewCell.h
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSRecommendSong;
@class singListModel;
@interface NSSongMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSRecommendSong * recommendSong;
@property (nonatomic,strong) singListModel * singList;
@end
