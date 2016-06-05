//
//  NSSongListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
@class singListModel;

@protocol songModel <NSObject>
@end
@interface songModel: NSBaseModel

@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * workName;
@property (nonatomic,copy) NSString * playUrl;
@property (nonatomic,assign) long itemId;

@end

@interface SongListModel : NSBaseModel

@property (nonatomic,assign) long totalCount;
@property (nonatomic,strong) NSArray <songModel> * songList;

@end

@interface NSSongListDetail : NSBaseModel
@property (nonatomic,strong) singListModel * listDetail;
@end

@interface NSSongListModel : NSBaseModel

@property (nonatomic,strong) SongListModel * SongList;

@property (nonatomic,strong) NSSongListDetail * songListDetail;

@end
