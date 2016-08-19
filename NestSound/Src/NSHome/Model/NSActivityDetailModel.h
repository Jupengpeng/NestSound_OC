//
//  NSActivityDetailModel.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"



@interface ActivityDetailModel : NSBaseModel

@property (nonatomic, assign) NSInteger activityId;

@property (nonatomic, copy) NSString *actDesc;

@property (nonatomic, assign) NSInteger joinnum;

@property (nonatomic, assign) long long begindate;

@property (nonatomic, assign) long long enddate;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger looknum;

@property (nonatomic, assign) NSInteger worknum;

@property (nonatomic, assign) NSInteger sort;

@end


@interface NSActivityDataModel : NSBaseModel

@property (nonatomic,strong) ActivityDetailModel *activityDetailModel;

@property (nonatomic,assign) BOOL isJoin;

@end

@interface NSActivityDetailModel : NSBaseModel

/**
 *   "activityDetail": {
 "id": 2, //活动id
 "title": "活动标题",   //活动标题
 "sort": 222, //排序
 "description": "活动描述", //活动描述
 "looknum": 7, //浏览量
 "pic": "http://pic.yinchao.cn/uploadfiles2/2016/08/13/2016081311392483689682.png",  //封面
 "enddate": 1471017600000,  //结束时间戳
 "begindate": 1471017600000, //开始时间戳
 "worknum": 1, //作品数量
 "type": 0,  //活动类型  0表示歌曲类  1表示歌词类
 "url": "http://22222"  //暂用不用
 }
 */

@property (nonatomic,strong) NSActivityDataModel *activityDataModel;

@end


