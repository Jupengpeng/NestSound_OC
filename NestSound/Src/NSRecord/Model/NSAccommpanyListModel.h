//
//  NSAccommpanyListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

//清唱
@protocol NSSimpleSingModel <NSObject>

@end
@interface NSSimpleSingModel : NSBaseModel

@property (nonatomic,assign) long itemID;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *playUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,assign) long playTimes;

@end

@protocol  NSSimpleListModel<NSObject>

@end
@interface NSSimpleListModel : NSBaseModel

@property (nonatomic,strong) NSSimpleSingModel * simpleSingList;
@end



//分类
@protocol NSSimpleCategoryModel <NSObject>

@end

@interface NSSimpleCategoryModel : NSBaseModel
@property (nonatomic,copy) NSString * categoryName;
@property (nonatomic,assign) long categoryId;
@property (nonatomic,copy) NSString *categoryPic;

@end

@protocol NSSimpleCategoryListModel <NSObject>

@end
@interface NSSimpleCategoryListModel : NSBaseModel

@property (nonatomic,strong) NSArray<NSSimpleCategoryModel> *simpleCategory;

@end



//伴奏
@protocol NSAccommpanyModel <NSObject>
@end

@interface NSAccommpanyModel : NSBaseModel

@property (nonatomic,assign) long itemID;
@property (nonatomic,assign) int mp3Times;
@property (nonatomic,copy) NSString * mp3URL;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * titleImageUrl;

@end

@interface NSAccommpanyListModel : NSBaseModel

@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<NSAccommpanyModel> * accommpanyList;
//@property (nonatomic,strong) NSAccommpanyModel * accommpanyList;
@property (nonatomic,strong) NSSimpleListModel * simpleList;
@property (nonatomic,strong) NSSimpleCategoryListModel * simpleCategoryList;
@end
