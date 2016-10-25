//
//  NSCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationViewController.h"

@interface NSCooperationViewController ()<NSTipViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *emptyImgView;
    UITableView *cooperationTab;
    
}


@end

@implementation NSCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCooperationViewController];
}
- (void)setupCooperationViewController {
    
    //合作
    cooperationTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    //    cooperationTab.delegate = self;
    //
    //    cooperationTab.dataSource = self;
    
//    cooperationTab.rowHeight = 80;
    
    cooperationTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cooperationTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //    [musicTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:musicCellIdentify];
    self.view = cooperationTab;
    
    WS(Wself);
    //refresh
    [cooperationTab addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            //            [Wself fetchDataWithType:1 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [cooperationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        //        [Wself fetchDataWithType:1 andIsLoadingMore:YES];
    }];
    emptyImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    //    emptyOneImage.hidden = YES;
    
    emptyImgView.centerX = ScreenWidth/2;
    
    emptyImgView.y = 100;
    
    [cooperationTab addSubview:emptyImgView];
    
    
   
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
    
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
