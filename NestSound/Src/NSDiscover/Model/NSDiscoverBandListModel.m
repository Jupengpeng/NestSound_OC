//
//  NSDiscoverBandListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDiscoverBandListModel.h"


@implementation NSBandMusic
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"author":@"author",
             @"workName":@"title",
             @"titleImageUrl":@"pic",
             @"createDate":@"createDate",
             @"fovNum":@"fovnum",
             @"lookNum":@"looknum",
             @"zanNum":@"zannum",
             @"itemId":@"itemid"
             };

}
@end

@implementation NSDiscoverBandListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"BandLyricList":@"data",
            @"BandMusicList":@"data"};
}

@end
