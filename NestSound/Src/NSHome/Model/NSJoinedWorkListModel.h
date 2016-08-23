//
//  NSJoinedWorkListModel.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"



@protocol NSJoinWorkCommentModel
@end

@interface NSJoinWorkCommentModel : NSBaseModel


@property (nonatomic, assign) NSInteger commentId;

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

//
//@interface NSJoinWorkCommentDataListModel : NSBaseModel
//
//@property (nonatomic,strong) NSArray<NSJoinWorkCommentModel> *workCommonList;
//
//@end



@protocol NSJoinedWorkDetailModel <NSObject>
@end

@interface NSJoinedWorkDetailModel : NSBaseModel

@property (nonatomic, assign) long long jointime;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, assign) NSInteger userid;

@property (nonatomic, assign) NSInteger zannum;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger commentnum;

@property (nonatomic, assign) NSInteger looknum;

@property (nonatomic, assign) NSInteger fovnum;

@property (nonatomic, assign) NSInteger itemid;

@property (nonatomic, copy) NSString *headurl;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic,strong) NSArray<NSJoinWorkCommentModel> *workCommonList;


@property (nonatomic,copy) NSString *mp3;

/**补充参数
 
 *
 */

@property (nonatomic,assign) BOOL isPlay;


/**
 *  是否是歌曲
 */
@property (nonatomic,assign) BOOL isMusic;

@end


@interface NSJoinedWorkListModel : NSBaseModel

@property (nonatomic,strong) NSArray<NSJoinedWorkDetailModel> *joinWorkList;
@property (nonatomic,assign) long totalCount;

@property (nonatomic,copy) NSString *resultMessage;

@end
