//
//  NSWriteLyricMaskView.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSWriteLyricMaskView.h"
#import "NSLyricLibraryListModel.h"

@interface NSWriteLyricMaskView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>
{
    NSMutableArray * lyricTypeAry;
    

}
@end

@implementation NSWriteLyricMaskView
-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma  mark -configureUIAppearance
-(void)configreUIAppearance
{

}
#pragma mark -layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    

}



@end
