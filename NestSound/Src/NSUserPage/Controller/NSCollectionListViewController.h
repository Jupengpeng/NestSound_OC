//
//  NSCollectionListViewController.h
//  NestSound
//
//  Created by yinchao on 16/9/20.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

typedef  NS_ENUM(NSInteger,ViewType){
    
    CooperationViewType,
    CollectionViewType
};

@interface NSCollectionListViewController : NSBaseViewController
@property (nonatomic, assign) ViewType viewType;
@end
