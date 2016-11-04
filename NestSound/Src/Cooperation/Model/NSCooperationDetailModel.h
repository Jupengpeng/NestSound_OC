//
//  NSCooperationDetailModel.h
//  NestSound
//
//  Created by yintao on 2016/11/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"



@class UserinfoModel,DemandinfoModel,CoWorkModel,CommentModel;
@interface NSCooperationDetailModel : NSBaseModel


@property (nonatomic, strong) NSArray<CoWorkModel *> *completeList;

@property (nonatomic, strong) NSArray<CommentModel *> *commentList;

@property (nonatomic, strong) UserinfoModel *userInfo;

@property (nonatomic, strong) DemandinfoModel *demandInfo;

//将 cmmentModel转为 NScommentModel
@property (nonatomic ,strong) NSArray *commentArray;

@end

@interface UserinfoModel : NSObject

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *headurl;

@end

@interface DemandinfoModel : NSObject

@property (nonatomic, copy) NSString *lyrics;

@property (nonatomic, assign) NSInteger did;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger commentnum;

@property (nonatomic, copy) NSString *requirement;

@property (nonatomic, assign) long long createtime;

@property (nonatomic, assign) long long endtime;

@property (nonatomic,assign) BOOL iscollect;

@end

@interface CoWorkModel : NSBaseModel

@property (nonatomic, copy) NSString *wUsername;

@property (nonatomic, copy) NSString *lUsername;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) long long createtime;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *itemid;

@property (nonatomic,copy) NSString *lyrics;

@property (nonatomic,copy) NSString *wUid;

@property (nonatomic,copy) NSString *lUid;

@property (nonatomic,copy) NSString *did;

@end

@interface CommentModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger target_uid;

@property (nonatomic, copy) NSString *headerurl;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, assign) NSInteger comment_type;

@property (nonatomic, assign) NSInteger isread;

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *targetheaderurl;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *target_nickname;

@property (nonatomic, assign) NSInteger itemid;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) long long createdate;

@end
