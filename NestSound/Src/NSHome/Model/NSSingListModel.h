//
//  NSSingListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol singListModel <NSObject>
@end

@interface singListModel : NSBaseModel
@property (nonatomic,copy) NSString * detail;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,assign) long itemId;

@end

@interface NSSingListModel : NSBaseModel

@property (nonatomic,strong) NSArray <singListModel> * singList;

@end
