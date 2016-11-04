//
//  MCModelFactory.m
//  MissCandy
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//
#import "NSTool.h"
#import "NSModelFactory.h"
#import "NSIndexModel.h"
#import "NSDiscoverMusicListModel.h"
#import "NSDicoverLyricListModel.h"
#import "NSDiscoverBandListModel.h"
#import "NSActivityListModel.h"
#import "NSLyricDetailModel.h"
#import "NSMusicSayListMode.h"
#import "NSSongListModel.h"
#import "NSSingListModel.h"
#import "NSUserModel.h"
#import "NSUserDataModel.h"
#import "NSUpvoteMessageListModel.h"
#import "NSMessageListModel.h"
#import "NSAccommpanyListModel.h"
#import "NSMyLricListModel.h"
#import "NSCommentMessageListModel.h"
#import "NSSystemMessageListModel.h"
#import "NSPlayMusicDetailModel.h"
#import "NSCommentListModel.h"
#import "NSGetQiNiuModel.h"
#import "NSPublicLyricModel.h"
#import "NSDiscoverMoreLyricModel.h"
#import "NSSearchUserListModel.h"
#import "NSFansListModel.h"
#import "NSInspirtationModel.h"
#import "NSTunMusicModel.h"
#import "NSLyricLibraryListModel.h"
#import "NSDraftListModel.h"
#import "NSTemplateListModel.h"
#import "NSActivityDetailModel.h"
#import "NSActivityJoinerListModel.h"
#import "NSJoinedWorkListModel.h"
#import "NSMusicianListModel.h"
#import "NSStarMusicianModel.h"
#import "NSUserMusicListModel.h"
#import "NSMusicSayChargeModel.h"
#import "YYModel.h"
#import "NSPreserveListModel.h"
#import "NSPreservePersonListModel.h"
#import "NSUnPreserveListModel.h"
#import "NSPreserveMessageListModel.h"
#import "NSPreserveApplyModel.h"
#import "NSPreserveApplyModel.h"
#import "NSPreserveMessageListModel.h"
#import "NSPreserveDetailListModel.h"
#import "NSCooperationListModel.h"
#import "NSMyCooperationListModel.h"
#import "NSCollectionCooperationListModel.h"
#import "NSCooperationLyricListModel.h"
#import "NSCooperationDetailModel.h"
#import "NSInvitationListModel.h"
@implementation NSModelFactory
+ (NSBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict {
//    NSString *jsonStr = [NSTool transformTOjsonStringWithObject:jsonDict];
    CHLog(@"jsonDict%@",jsonDict);
    if ([url isEqualToString:indexURL]) {

        return [[NSIndexModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:dicoverActivityURL]){
        return [[NSActivityListModel alloc] initWithJSONDict:jsonDict];
        
    }else if([url isEqualToString:dicoverMusicURL]){
        return [[NSDiscoverMusicListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:discoverBandURL]){
        return [[NSDiscoverBandListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:dicoverLyricURL]){
    
        return [[NSDicoverLyricListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:lyricDetailURL]){
        
        return [[NSLyricDetailModel alloc] initWithJSONDict:jsonDict];
    
    }else if ([url isEqualToString:yueShuoURL]){
    
        return [[NSMusicSayListMode alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:SongListURL]){
    
        return [[NSSongListModel alloc] initWithJSONDict:jsonDict];
    
    }else if ([url isEqualToString:songListURL]){
    
        return [[NSSingListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:loginURl] || [url isEqualToString:getToken]){
        
        return [[NSUserModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:upvoteMessageURL] || [url isEqualToString:collectMessageURL]){
        
        return [[NSUpvoteMessageListModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:messageURL]){
        
        return [[NSMessageListModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:accompanyListURL] || [url isEqualToString:accompanyCategoryListUrl]){
        
        return [[NSAccommpanyListModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:myLyricListURL]){
        
        return [[NSMyLricListModel alloc] initWithJSONDict:jsonDict];
    }
//    else if ([url isEqualToString:collectMessageURL]){
//        return [[NSUpvoteMessageListModel alloc] initWithJSONDict:jsonDict];
//    }
    else if ([url isEqualToString:commentMessageURL] || [url isEqualToString:commentURL]||
             [url isEqualToString:coWorkCommentListUrl]){
        
        return [[NSCommentListModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:systemMessageURL] || [url isEqualToString:preserveMessageUrl] || [url isEqualToString:cooperationMessageUrl]){
        return [[NSPreserveMessageListModel alloc] initWithJSONDict:jsonDict];
    }
//    else if ([url isEqualToString:systemMessageURL]) {
//        return [[NSPreserveMessageListModel alloc] initWithJSONDict:jsonDict];
//    }
    else if ([url isEqualToString:playMusicURL] ||
             [url isEqualToString:coWorkPlayDetailUrl]){
        
        return [[NSPlayMusicDetailModel alloc] initWithJSONDict:jsonDict];
        
    } else if ([url isEqualToString:preserveDetailUrl]) {
        
        return [[NSPreserveDetailListModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:userCenterURL] || [url isEqualToString:userListUrl] || [url isEqualToString:otherCenterURL] ||[url isEqualToString:myUserCenterDefaultUrl] || [url isEqualToString:otherUserCenterDefaultUrl]){
    
        return [[NSUserDataModel alloc] initWithJSONDict:jsonDict];
    
    }
//    else if ([url isEqualToString:commentURL] ){
//        return [[NSCommentListModel alloc] initWithJSONDict:jsonDict];
//    
//    }
//    else if ([url isEqualToString:otherCenterURL]){
//        /**
//         其他人的个人中心
//         */
//        return [[NSUserDataModel alloc] initWithJSONDict:jsonDict];
//    }
    else if ([url isEqualToString:publicLyricURL] || [url isEqualToString:publicMusicURL]){
        
        return [[NSPublicLyricModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:getQiniuDetail]){
        
        return [[NSGetQiNiuModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:discoverLyricMoreURL] || [url isEqualToString:discoverMusicMoreURL] || [url isEqualToString:userMLICListUrl] || [url isEqualToString:myUserCenterListUrl] || [url isEqualToString:otherUserCenterListUrl]){
        
        return [[NSDiscoverMoreLyricModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:searchURL]){
        
        return [[NSSearchUserListModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:myFansListURL] || [url isEqualToString:otherFFURL]){
        
        return [[NSFansListModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:getInspirationURL]){
        
        return [[NSInspirtationModel alloc] initWithJSONDict:jsonDict];
    }
//    else if ([url isEqualToString:getToken]){
//    
//        return [[NSUserModel alloc] initWithJSONDict:jsonDict];
//    }
    else if ([url isEqualToString:tunMusicURL]){
    
        return [[NSTunMusicModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:lyricLibraryURL]){
        
        return [[NSLyricLibraryListModel alloc] initWithJSONDict:jsonDict];
    }
//    else if ([url isEqualToString:publicMusicURL]){
//        return [[NSPublicLyricModel alloc] initWithJSONDict:jsonDict];
//    }
    else if ([url isEqualToString:draftListUrl]) {
        
        return [[NSDraftListModel alloc] initWithJSONDict:jsonDict];
        
    } else if ([url isEqualToString:templateListUrl]) {
        
        return [[NSTemplateListModel alloc] initWithJSONDict:jsonDict];
        
    }
    else if([url isEqualToString:activityDetailUrl]){
        
        return [[NSActivityDetailModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:joinedUserListUrl]){
        
        return [[NSActivityJoinerListModel alloc] initWithJSONDict:jsonDict];
        
    }else if([url isEqualToString:joinedWorksDetailUrl]){
        
        return [[NSJoinedWorkListModel alloc] initWithJSONDict:jsonDict];
        
    }else if([url isEqualToString:publicLyricURL] || [url isEqualToString:publicMusicURL]){
        
        return [[NSActPublicLyricModel alloc] initWithJSONDict:jsonDict];
        
    }
//    else if([url isEqualToString:publicMusicURL]){
//        return [[NSActPublicLyricModel alloc] initWithJSONDict:jsonDict];
//    }
    else if([url isEqualToString:musicianListUrl]){
        
        return [[NSMusicianListModel alloc] initWithJSONDict:jsonDict];

    }else if ([url isEqualToString:musicianDetailUrl]){
        
        return [[NSStarMusicianModel alloc] initWithJSONDict:jsonDict];
        
    }else if([url isEqualToString:myMusicListURL]){
        
        return [[NSUserMusicListModel alloc] initWithJSONDict:jsonDict];

    }else if ([url isEqualToString:getGoodChargeUrl]){
        NSMusicSayChargeModel *chargeModel = [NSMusicSayChargeModel yy_modelWithDictionary:[jsonDict objectForKey:@"data"]];
        chargeModel.chargeDict = [jsonDict objectForKey:@"data"];
        return chargeModel;

    }else if ([url isEqualToString:preserveListUrl]) {
        
        return [[NSPreserveListModel alloc] initWithJSONDict:jsonDict];
    }
    else if([url isEqualToString:preservePersonListUrl]){
        
        return [[NSPreservePersonListModel alloc] initWithJSONDict:jsonDict];
        
    } else if ([url isEqualToString:unPreservedListUrl]) {
        
        return [[NSUnPreserveListModel alloc] initWithJSONDict:jsonDict];
    }
    
//    else if([url isEqualToString:uploadBgimageUrl]){
//        CHLog(@"%@",jsonStr);
//    }
    else if ([url isEqualToString:musicSayDetailUrl]){
        
        CHLog(@"%@",[jsonDict objectForKey:@"data"]);
        return [NSMusicSay yy_modelWithDictionary:[jsonDict objectForKey:@"data"]];

    
    }
    else if ([url isEqualToString:getPreserveInfoUrl]){
        CHLog(@"%@",[jsonDict objectForKey:@"data"]);
        return [NSPreserveApplyModel yy_modelWithDictionary:[jsonDict objectForKey:@"data"]];
    }
    //支付成功回调
    else if ([url isEqualToString:paiedSuccessUrl]){
        
    }
    //个人用户中心默认
//    else if([url isEqualToString:myUserCenterDefaultUrl]){
//        return [[NSUserDataModel alloc] initWithJSONDict:jsonDict];
//    }
    //他人用户中心默认
//    else if ([url isEqualToString:otherUserCenterDefaultUrl]){
//        return [[NSUserDataModel alloc] initWithJSONDict:jsonDict];
//    }
    //用户个人中心 列表
//    else if ([url isEqualToString:myUserCenterListUrl]){
//        return [[NSDiscoverMoreLyricModel alloc] initWithJSONDict:jsonDict];
//    }
    //他人用户中心 列表
//    else if ([url isEqualToString:otherUserCenterListUrl]){
//        return [[NSDiscoverMoreLyricModel alloc] initWithJSONDict:jsonDict];
//    }
    //合作
    else if ([url isEqualToString:cooperationListUrl]) {
        
        return [[NSCooperationListModel alloc] initWithJSONDict:jsonDict];
        
    } else if ([url isEqualToString:myCooperationListUrl]) {
        
        return [[NSMyCooperationListModel alloc] initWithJSONDict:jsonDict];
        
    } else if ([url isEqualToString:collectCooperationListUrl]) {
        
        return [[NSCollectionCooperationListModel alloc] initWithJSONDict:jsonDict];
    } else if ([url isEqualToString:demandLyricListUrl]) {
        
        return [[NSCooperationLyricListModel alloc] initWithJSONDict:jsonDict];
        
    } else if ([url isEqualToString:invitationListUrl]) {
        
        return [[NSInvitationListModel alloc] initWithJSONDict:jsonDict];
        
    } else if ([url isEqualToString:coDetailUrl]){
        NSCooperationDetailModel *detailModel = [NSCooperationDetailModel yy_modelWithDictionary:[jsonDict objectForKey:@"data"]];
        return detailModel;
    } else if ([url isEqualToString:coCooperateActionUrl]){
        CoWorkModel *workModel = [CoWorkModel yy_modelWithDictionary:[jsonDict objectForKey:@"data"]];
        return workModel;
        
    } else if ([url isEqualToString:coWorkReleaseUrl]){
        
        
    } else if ([url isEqualToString:coAcceptActionUrl]){
        
    }
    return [[NSBaseModel alloc] initWithJSONDict:jsonDict];
    
}





@end
