//
//  NSUserMusicListModel.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"



@protocol  NSUserMusicModel <NSObject>
@end

@interface NSUserMusicModel : NSBaseModel


@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) long long createtime;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, assign) NSInteger itemid;



@end


@interface NSUserMusicListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSUserMusicModel> * myMusicList;

@end
