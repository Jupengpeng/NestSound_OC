//
//  NSShareViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSShareViewController.h"
#import "NSShareCollectionViewCell.h"
#import "NSPreserveApplyController.h"
#import "NSPublicLyricModel.h"
@interface NSShareViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray * shareModuleAry;
//    NSMutableArray * availableShareModuleAry;
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

@property (nonatomic, strong) NSMutableArray * availableShareModuleAry;;
@end

static NSString *identifier = @"identifier";

@implementation NSShareViewController

- (NSMutableArray *)availableShareModuleAry {
    
    if (!_availableShareModuleAry) {
        
        _availableShareModuleAry = [NSMutableArray array];
    }
    
    return _availableShareModuleAry;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.weixinDict         = @{@"icon": @"2.0_shareWX_btn", @"name": @"微信"};
    self.pengyouquanDict    = @{@"icon": @"2.0_shareFriend_btn", @"name": @"朋友圈"};
    self.weiboDict          = @{@"icon": @"2.0_shareSina_btn", @"name": @"微博"};
    self.QQDict             = @{@"icon": @"2.0_shareQQ_btn", @"name": @"QQ"};
    self.QzoneDict          = @{@"icon": @"2.0_qzoneShare_btn", @"name": @"QQ空间"};
//    availableShareModuleAry = [NSMutableArray array];
  
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_share_background"]];
    image.userInteractionEnabled = YES;
    self.view = image;
}


#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2.0_share_background"]];
    
    CGFloat W = (ScreenWidth - 120) / 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 15;
    
    layout.minimumInteritemSpacing = 30;
    
    layout.itemSize = CGSizeMake(W, W + W/3);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
    
    UICollectionView *shareCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    shareCollection.x = 0;
    
    shareCollection.y = ScreenHeight/3-10;
    
    shareCollection.width = ScreenWidth;
    
    shareCollection.height = 3*W;
    
    shareCollection.backgroundColor = [UIColor clearColor];
    
    shareCollection.delegate = self;
    
    shareCollection.dataSource = self;
    
    [shareCollection registerClass:[NSShareCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    [self.view addSubview:shareCollection];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareCollection.frame) + 30, ScreenWidth, 20)];
    
    tipLabel.text = @"*为了您的个人权益,推荐您进行保全登记";
    
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    tipLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:tipLabel];
    
    UIButton *preserveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    preserveBtn.centerX = self.view.centerX;
//    
//    preserveBtn.y = CGRectGetMaxY(tipLabel.frame) + 10;
    
    
    [preserveBtn setBackgroundImage:[UIImage imageNamed:@"2.0_preserve_btn"] forState:UIControlStateNormal];
    
    [preserveBtn addTarget:self action:@selector(preserveApply) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:preserveBtn];
    
    [preserveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.height.mas_equalTo(44);
        
        make.top.equalTo(tipLabel.mas_bottom).offset(20);
        
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        btn.tintColor = [UIColor blackColor];
        
        [btn setImage:[UIImage imageNamed:@"2.0_cancel_btn"] forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(15, 32, 30, 30);
        
    } action:^(UIButton *btn) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:btn];
}

- (void)preserveApply {
    NSPreserveApplyController *preserveController = [[NSPreserveApplyController alloc] init];
    if (_lyricOrMusic) {
        preserveController.sortId = @"2";
    }else{
        preserveController.sortId = @"1";
    }
    preserveController.itemUid = self.publicModel.itemID;
    [self.navigationController pushViewController:preserveController animated:YES];
}
#pragma mark - chose avaiableShareModule
-(void)availableShareModue
{
    self.availableShareModuleAry = [NSMutableArray array];
    if ([Share shareAvailableWeiXin]) {
        [self.availableShareModuleAry addObject:_weixinDict];
        [self.availableShareModuleAry addObject:_pengyouquanDict];
    }
    if ([Share shareAvailableQQ]) {
     [self.availableShareModuleAry addObject:_QQDict];
     [self.availableShareModuleAry addObject:_QzoneDict];

    }
    if ([Share shareAvailableSina]) {
        [self.availableShareModuleAry addObject:_weiboDict];

    }

    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.availableShareModuleAry) {
        self.availableShareModuleAry = nil;
    }
    [self availableShareModue];
    [self configureUIAppearance];
    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark -setter & getter
-(void)setShareDataDic:(NSMutableDictionary *)shareDataDic
{
    _shareDataDic = shareDataDic;
    workName = _shareDataDic[@"lyricName"];
    shareUrl = _shareDataDic[@"shareURL"];
    titleImageURl = [NSString stringWithFormat:@"http://pic.yinchao.cn/%@",_shareDataDic[@"titleImageUrl"]];
    desc = _shareDataDic[@"desc"];
}

#pragma mark -collectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.availableShareModuleAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.dic = self.availableShareModuleAry[indexPath.row];
    return cell;
}


#pragma mark -collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.availableShareModuleAry[indexPath.row];
    WS(wSelf);
    UIImage * imageShare;
    NSString *contentShare;
    UMSocialUrlResource *urlResource;
    if (self.lyricOrMusic) {
        contentShare = [NSString stringWithFormat:@"我用音巢APP创作了一首歌词，快来看看吧！《%@》,%@",workName,shareUrl];
        urlResource  = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:titleImageURl];
    } else {
        contentShare = _shareDataDic[@"author"];
        urlResource  = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeMusic url:shareUrl];
    }
    if (titleImageURl.length != 0) {
        imageShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:titleImageURl]]];
    }else{
        imageShare = [UIImage imageNamed:@"2.0_placeHolder"];
    }
    
    [UMSocialData defaultData].extConfig.title = workName;
    if ([[dic objectForKey:@"name"] isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://audio.yinchao.cn%@",_shareDataDic[@"mp3Url"]];
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:contentShare image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    if ([[dic objectForKey:@"name"] isEqualToString:@"朋友圈"]) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://audio.yinchao.cn%@",_shareDataDic[@"mp3Url"]];
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:contentShare image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    if ([[dic objectForKey:@"name"] isEqualToString:@"微博"]) {
        [UMSocialData defaultData].extConfig.sinaData.urlResource = urlResource;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:contentShare image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    if ([[dic objectForKey:@"name"] isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"http://audio.yinchao.cn%@",_shareDataDic[@"mp3Url"]];
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:contentShare image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    if ([[dic objectForKey:@"name"] isEqualToString:@"QQ空间"]) {
        
        [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"http://audio.yinchao.cn%@",_shareDataDic[@"mp3Url"]];
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:contentShare image:imageShare location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }


}
@end
