//
//  NSInspirationRecordTableViewCell.h
//  NestSound
//
//  Created by Apple on 16/5/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSMyMusicModel;

@interface NSInspirationRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIImageView *frequencyImageView;

@property (nonatomic,strong) NSMyMusicModel * myInspirationModel;

@end


