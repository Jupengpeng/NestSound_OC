//
//  NSLyricLibraryListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol LyricLibList <NSObject>
@end

@interface LyricLibList : NSBaseModel
@property (nonatomic,assign) long libId;
@property (nonatomic,copy) NSString * lyrics;

@end


@protocol NSTypeLyricListModel <NSObject>
@end
@interface NSTypeLyricListModel : NSBaseModel
@property (nonatomic,assign) long typeId;
@property (nonatomic,copy) NSString * typeTitle;
@property (nonatomic,strong) NSArray <LyricLibList> * lyricLibaryList;

@end

@interface NSLyricLibraryListModel : NSBaseModel

@property(nonatomic,strong) NSArray <NSTypeLyricListModel> * LyricLibaryListModel;

@end
