//
//  NSTemplateListModel.h
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@protocol  NSTemplateModel <NSObject>
@end

@interface NSTemplateModel : NSBaseModel
@property (nonatomic,assign) long itemId;
@property (nonatomic,assign) long createtime;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * workname;
@property (nonatomic,copy) NSString * playUrl;
@end


@interface NSTemplateListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSTemplateModel> * templateList;
@end
