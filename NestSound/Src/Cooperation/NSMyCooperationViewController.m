//
//  NSMyCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMyCooperationViewController.h"

@interface NSMyCooperationViewController ()
{
    UITableView *myCooperationTab;
    UIImageView *emptyImage;
}
@end

@implementation NSMyCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMyCooperationViewController];
}
- (void)setupMyCooperationViewController {
    
    //我的
    myCooperationTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    //    myCooperationTab.delegate = self;
    //
    //    myCooperationTab.dataSource= self;
    
//    myCooperationTab.rowHeight = 80;
    
    myCooperationTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    myCooperationTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //    [lyricTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:lyricCellIdentify];
    self.view = myCooperationTab;
//    [self.contentScrollView addSubview:myCooperationTab];
    
   
    WS(wSelf);
    //refresh
    [myCooperationTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            //            [Wself fetchDataWithType:2 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [myCooperationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }
        //        [Wself fetchDataWithType:2 andIsLoadingMore:YES];
    }];
    
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    //    emptyTwoImage.hidden = YES;
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [myCooperationTab addSubview:emptyImage];
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
