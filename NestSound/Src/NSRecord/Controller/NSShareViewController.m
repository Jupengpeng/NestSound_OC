//
//  NSShareViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSShareViewController.h"
#import "NSShareCollectionViewCell.h"


@interface NSShareViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray * shareModuleAry;
    NSMutableArray * availableShareModuleAry;
    NSString * workName;
    NSString * titleImageURl;
    NSString * shareUrl;
    NSString * desc;
}

@property (nonatomic, strong) NSDictionary *weixinDict;
@property (nonatomic, strong) NSDictionary *pengyouquanDict;
@property (nonatomic, strong) NSDictionary *weiboDict;
@property (nonatomic, strong) NSDictionary *QQDict;
@property (nonatomic, strong) NSDictionary *QzoneDict;

@end

static NSString *identifier = @"identifier";

@implementation NSShareViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.weixinDict         = @{@"icon": @"2.0_shareWX_btn", @"name": @"微信"};
    self.pengyouquanDict    = @{@"icon": @"2.0_shareFriend_btn", @"name": @"朋友圈"};
    self.weiboDict          = @{@"icon": @"2.0_shareSina_btn", @"name": @"微博"};
    self.QQDict             = @{@"icon": @"2.0_shareQQ_btn", @"name": @"QQ"};
    self.QzoneDict          = @{@"icon": @"2.0_qzoneShare_btn", @"name": @"QQ空间"};
    availableShareModuleAry = [NSMutableArray array];
  
   
}


#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2.0_share_background"]];
    
    CGFloat W = (ScreenWidth - 120) / 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 15;
    
    layout.minimumInteritemSpacing = 30;
    
    layout.itemSize = CGSizeMake(W, W + W/3);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
    
    UICollectionView *shareCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    shareCollection.x = 0;
    
    shareCollection.y = self.view.height * 0.5 - W;
    
    shareCollection.width = ScreenWidth;
    
    shareCollection.height = 300;
    
    shareCollection.backgroundColor = [UIColor clearColor];
    
    shareCollection.delegate = self;
    
    shareCollection.dataSource = self;
    
    [self.view addSubview:shareCollection];
    
    
    
    [shareCollection registerClass:[NSShareCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_back"] forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(15, 32, 30, 30);
        
    } action:^(UIButton *btn) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:btn];
}


#pragma mark - chose avaiableShareModule
-(void)availableShareModue
{
    if ([Share shareAvailableWeiXin]) {
        [availableShareModuleAry addObject:_weixinDict];
        [availableShareModuleAry addObject:_pengyouquanDict];
    }
    if ([Share shareAvailableQQ]) {
     [availableShareModuleAry addObject:_QQDict];
     [availableShareModuleAry addObject:_QzoneDict];

    }

    [availableShareModuleAry addObject:_weiboDict];


}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self availableShareModue];
     [self configureUIAppearance];
}


#pragma mark -setter & getter
-(void)setShareDataDic:(NSMutableDictionary *)shareDataDic
{
    _shareDataDic = shareDataDic;
    workName = _shareDataDic[@"workName"];
    shareUrl = _shareDataDic[@"shareUrl"];
    titleImageURl = _shareDataDic[@"titleImageURl"];
    desc = _shareDataDic[@"desc"];
}

#pragma mark -collectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return availableShareModuleAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.dic = availableShareModuleAry[indexPath.row];
    return cell;
}


#pragma mark -collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = availableShareModuleAry[indexPath.row];
    WS(wSelf);
    UMSocialUrlResource * urlResource  = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:titleImageURl];
    [UMSocialData defaultData].extConfig.title = workName;
    if ([[dic objectForKey:@"name"] isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.shareDataDic[@"desc"] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
    }
    
    if ([[dic objectForKey:@"name"] isEqualToString:@"朋友圈"]) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareDataDic[@"desc"] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    if ([[dic objectForKey:@"name"] isEqualToString:@"微博"]) {
        [UMSocialData defaultData].extConfig.sinaData.urlResource = urlResource;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:self.shareDataDic[@"desc"] image:[UIImage imageNamed:@"2.0_placeHolder"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    if ([[dic objectForKey:@"name"] isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:self.shareDataDic[@"desc"] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    if ([[dic objectForKey:@"name"] isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:self.shareDataDic[@"desc"] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
<<<<<<< HEAD
    
=======
    [wSelf.navigationController popToRootViewControllerAnimated:YES];

>>>>>>> b35939b4a30208d24c9cfcdce9507aa670a4a412
}
@end
