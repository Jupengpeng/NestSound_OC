//
//  NSPlayMusicDetailModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@interface NSPlayMusicDetail : NSBaseModel
@property (nonatomic,assign) long commentNum;
@property (nonatomic,assign) long fovNum;
@property (nonatomic,assign) long hotId;
@property (nonatomic,assign) long hotMp3Times;
@property (nonatomic,assign) int isZan;
@property (nonatomic,assign) int isCollection;
@property (nonatomic,assign) long itemID;
@property (nonatomic,assign) long mp3Times;
@property (nonatomic,assign) long nextItemID;
@property (nonatomic,assign) long prevItemID;
@property (nonatomic,assign) long userID;
@property (nonatomic,assign) long zanNum;
@property (nonatomic,assign) long isShow;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * headURL;
@property (nonatomic,copy) NSString * hotTitle;
@property (nonatomic,copy) NSString * hotMP3;
@property (nonatomic,copy) NSString * shareURL;
@property (nonatomic,copy) NSString * lyrics;
@property (nonatomic,copy) NSString * titleImageURL;
@property (nonatomic,copy) NSString * playURL;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * detaile;


@end

@interface NSPlayMusicDetailModel : NSBaseModel
@property (nonatomic,strong) NSPlayMusicDetail * musicdDetail;
@end
