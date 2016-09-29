//
//  NSIndexModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSMusicModel.h"

@protocol NSBanner <NSObject>
@end


@interface NSBanner : NSBaseModel<NSCoding>

@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,assign) long itemID;
@property (nonatomic,assign) int state;
@property (nonatomic,copy) NSString * activityURL;

@end

@interface NSBannerList : NSBaseModel

@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<NSBanner> * bannerList;
@end

@protocol NSRecommend <NSObject>
@end

@interface NSRecommend : NSBaseModel<NSCoding>

@property (nonatomic,copy) NSString * titlePageUrl;
@property (nonatomic,copy) NSString * authorName;
@property (nonatomic,copy) NSString * workName;
@property (nonatomic,assign) long  itemId;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int playCount;

@end

@interface NSRecommendList : NSBaseModel

@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSRecommend> * recommendList;
@end

@protocol  NSRecommendSong  <NSObject>

@end

@interface NSRecommendSong : NSBaseModel<NSCoding>
@property (nonatomic,copy) NSString * titleImageURl;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,assign) long itemID;
@end

@interface NSRecommendSongLs : NSBaseModel
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSRecommendSong> * recommendSongList;
@end


@protocol NSNew <NSObject>
@end

@interface NSNew : NSBaseModel<NSCoding>

@property (nonatomic,copy) NSString * titlePageUrl;
@property (nonatomic,copy) NSString * authorName;
@property (nonatomic,copy) NSString * workName;
@property (nonatomic,assign) long  itemId;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int  playCount;
@end

@interface NSNewList : NSBaseModel

@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSNew> * songList;
@end


@protocol NSMusicSay <NSObject>
@end

@interface NSMusicSay : NSBaseModel<NSCoding>

@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,assign) int itemID;
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString * playUrl;
@property (nonatomic,copy) NSString * detail;
@property (nonatomic,copy) NSString * workName;
@property (nonatomic,copy) NSString *shareurl;
@property (nonatomic,copy) NSString *zannum;
@property (nonatomic,copy) NSString *commentnum;
@property (nonatomic,copy) NSString *sharenum;


@property (nonatomic,assign) NSInteger isZan;
@end


@interface NSMusicSayList : NSBaseModel
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSMusicSay> * musicSayList;

@end


@interface NSIndexModel : NSBaseModel
@property (nonatomic,strong) NSBannerList * BannerList;
@property (nonatomic,strong) NSRecommendList * RecommendList;
@property (nonatomic,strong) NSNewList * NewList;
@property (nonatomic,strong) NSRecommendSongLs * RecommendSongList;
@property (nonatomic,strong) NSMusicSayList * MusicSayList;
@end
