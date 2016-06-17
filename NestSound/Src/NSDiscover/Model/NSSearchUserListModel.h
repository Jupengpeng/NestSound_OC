//
//  NSSearchUserListModel.h
//  NestSound
//
//  Created by Apple on 16/6/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSMyMusicModel.h"

@protocol NSSearchUserModel <NSObject>
@end
@interface NSSearchUserModel : NSBaseModel

@property (nonatomic,assign) long userID;
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * headImageUrl;
@end

@interface NSSearchUserListModel : NSBaseModel
@property (nonatomic,strong) NSArray <NSSearchUserModel> * searchUserList;
@property (nonatomic,strong) NSArray <NSMyMusicModel> * searchMusicList;
@end
