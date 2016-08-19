//
//  NSJoinedWorkListModel.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSCommentMessageListModel.h"




@interface NSJoinWorkCommentDataListModel : NSBaseModel

@property (nonatomic,strong) NSArray<commentMessageModel> *workCommonList;

@end



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

@property (nonatomic,strong) NSArray<commentMessageModel> *workCommonList;


@end


@interface NSJoinedWorkListModel : NSBaseModel

@property (nonatomic,strong) NSArray<NSJoinedWorkDetailModel> *joinWorkList;
@property (nonatomic,assign) long totalCount;

@property (nonatomic,copy) NSString *resultMessage;

@end
