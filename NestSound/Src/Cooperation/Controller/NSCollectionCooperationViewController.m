//
//  NSCollectionCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCollectionCooperationViewController.h"

@interface NSCollectionCooperationViewController ()
{
    UITableView *collectionTab;
    UIImageView *emptyImage;
}
@end

@implementation NSCollectionCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionViewController];
}
- (void)setupCollectionViewController {
    //收藏
    
    collectionTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    //    collectionTab.dataSource = self;
    //
    //    collectionTab.delegate = self;
    
    collectionTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //    [collectionTab registerClass:[NSSearchUserCollectionViewCell class] forCellWithReuseIdentifier:userCellIdentify];
    self.view = collectionTab;
    WS(Wself);
    //refresh
    [collectionTab addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            //            [Wself fetchDataWithType:3 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [collectionTab addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        //        [Wself fetchDataWithType:3 andIsLoadingMore:YES];
    }];
    
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    //    emptyThreeImage.hidden = YES;
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [collectionTab addSubview:emptyImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
