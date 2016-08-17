//
//  NSDraftListViewController.h
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@protocol NSDraftListViewControllerDelegate <NSObject>
-(void)selectDraft:(NSString *)draft withDraftTitle:(NSString *)draftTitle;

@end

@interface NSDraftListViewController : NSBaseViewController

@property (nonatomic,weak) id <NSDraftListViewControllerDelegate> delegate;
@end
