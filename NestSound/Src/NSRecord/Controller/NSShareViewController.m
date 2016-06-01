//
//  NSShareViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSShareViewController.h"


@interface NSShareViewController ()
{
    NSMutableArray * shareModuleAry;
    NSMutableArray * availableShareModuleAry;
    NSString * workName;
    NSString * titleImageURl;
    NSString * shareUrl;
}
@end


@implementation NSShareViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
}


#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

#pragma mark
-(void)doShare:(UIButton *)sender
{
    

}


#pragma mark -setter & getter
-(void)setShareDataDic:(NSMutableDictionary *)shareDataDic
{
    _shareDataDic = shareDataDic;
    workName = _shareDataDic[@"workName"];
    shareUrl = _shareDataDic[@"shareUrl"];
    titleImageURl = _shareDataDic[@"titleImageURl"];
}

@end
