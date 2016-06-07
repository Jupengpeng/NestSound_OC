//
//  NSUserDataModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSMyMusicModel.h"


@interface UserOtherModel : NSBaseModel
@property (nonatomic,assign) long fansNum;
@property (nonatomic,assign) long focusNum;
@end

@interface UserModel : NSBaseModel
@property (nonatomic,assign) long userId;
@property (nonatomic,copy) NSString * headerUrl;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * signature;
@end

@interface UserDataModel : NSBaseModel

@property (nonatomic,strong) UserModel * userModel;
@end
@interface MyMusicList : NSBaseModel


@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSMyMusicModel> * musicList;
@end

@interface NSUserDataModel : NSBaseModel

@property (nonatomic,strong) UserDataModel * userDataModel;
@property (nonatomic,strong) MyMusicList * myMusicList;
@property (nonatomic,strong) UserOtherModel * userOtherModel;
@end