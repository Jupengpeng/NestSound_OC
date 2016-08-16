//
//  NSMusicSayCollectionViewCell.h
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSMusicSay;

@interface NSMusicSayCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) NSMusicSay * musicSay;
/**
 *  定制未来
 */
@property (nonatomic,strong) NSString *picUrlStr;

@end
