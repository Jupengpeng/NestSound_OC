//
//  NSLocalProductViewController.m
//  NestSound
//
//  Created by yinchao on 2016/11/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLocalProductViewController.h"

@interface NSLocalProductViewController ()<UIScrollViewDelegate>
{
    UIButton *lyricBtn;
    UIButton *musicBtn;
    UIView   *lineView;
    UIScrollView *contentScrollView;
}
@end

@implementation NSLocalProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocalProductUI];
}
- (void)setupLocalProductUI {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-90, 0, 180, 44)];
    navigationView.backgroundColor = [UIColor clearColor];
    lyricBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    lyricBtn.frame = CGRectMake(0, 0, 60, 41);
    [lyricBtn setTitle:@"歌词" forState:UIControlStateNormal];
    [lyricBtn addTarget:self action:@selector(lyricBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:lyricBtn];
    
    musicBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    musicBtn.frame = CGRectMake(120, 0, 60, 41);
    [musicBtn setTitle:@"歌曲" forState:UIControlStateNormal];
    [musicBtn addTarget:self action:@selector(musicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:musicBtn];
    self.navigationItem.titleView = navigationView;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, 60, 3)];
    
    lineView.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [navigationView addSubview:lineView];
    
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height - 64)];
    
    contentScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    
    contentScrollView.showsHorizontalScrollIndicator = NO;
    
    contentScrollView.showsVerticalScrollIndicator = NO;
    
    contentScrollView.scrollEnabled = NO;
    
    contentScrollView.pagingEnabled = YES;
    
    contentScrollView.delegate = self;
    
    [self.view addSubview:contentScrollView];
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
