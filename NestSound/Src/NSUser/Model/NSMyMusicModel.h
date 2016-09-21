//
//  NSMyMusicModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol NSMyMusicModel <NSObject>
@end

@interface NSMyMusicModel : NSBaseModel
@property (nonatomic,assign) NSTimeInterval  createDate;
@property (nonatomic,assign) NSTimeInterval  createdate;
@property (nonatomic,assign) long fovNum;
@property (nonatomic,assign) long itemId;
@property (nonatomic,assign) long lookNum;
@property (nonatomic,assign) long upvoteNum;
@property (nonatomic,assign) long isShow;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,copy) NSString * titleImageUrls;
@property (nonatomic,assign) long userID;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,assign) NSTimeInterval inTableTime;
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString * spireContent;
@property (nonatomic,copy) NSString * audio;
@end
