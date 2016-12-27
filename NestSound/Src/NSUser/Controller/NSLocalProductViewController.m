//
//  NSLocalProductViewController.m
//  NestSound
//
//  Created by yinchao on 2016/11/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLocalProductViewController.h"
#import "NSCacheProductCell.h"
@interface NSLocalProductViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton *lyricBtn;
    UIButton *musicBtn;
    UIView   *lineView;
    int screenWith;
    UIScrollView *contentScrollView;
    UITableView *lyricTab;
    UITableView *musicTab;
    UIImageView *emptyOneImage;
    UIImageView *emptyTwoImage;
    UILabel *tipOneLabel;
    UILabel *tipTwoLabel;
}
@property (nonatomic ,strong) NSMutableArray *lyricDataArr;
@property (nonatomic ,strong) NSMutableArray *musicDataArr;
@end

@implementation NSLocalProductViewController
- (NSMutableArray *)lyricDataArr {
    if (_lyricDataArr) {
        self.lyricDataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _lyricDataArr;
}
- (NSMutableArray *)musicDataArr {
    if (_musicDataArr) {
        self.musicDataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _musicDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocalProductUI];
    
//    self.lyricDataArr = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3"]];
//    self.musicDataArr = [NSMutableArray arrayWithArray:@[@"4",@"5",@"6"]];
    
    if (_lyricDataArr.count) {
        emptyOneImage.hidden = YES;
        tipOneLabel.hidden = YES;
    } else {
        emptyOneImage.hidden = NO;
        tipOneLabel.hidden = NO;
    }
    if (_musicDataArr.count) {
        emptyTwoImage.hidden = YES;
        tipTwoLabel.hidden = YES;
    } else {
        emptyTwoImage.hidden = NO;
        tipTwoLabel.hidden = NO;
    }
}
- (void)setupLocalProductUI {
    if (self.viewFrom == LocalProduct) {
        screenWith = 2;
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
    } else {
        screenWith = 1;
        self.title = @"已缓存伴奏";
    }
    
    
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height - 64)];
    
    contentScrollView.contentSize = CGSizeMake(ScreenWidth * screenWith, 0);
    
    contentScrollView.showsHorizontalScrollIndicator = NO;
    
    contentScrollView.showsVerticalScrollIndicator = NO;
    
    contentScrollView.scrollEnabled = NO;
    
    contentScrollView.pagingEnabled = YES;
    
    contentScrollView.delegate = self;
    
    [self.view addSubview:contentScrollView];
    
    lyricTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height - 64) style:UITableViewStyleGrouped];
    
    lyricTab.delegate = self;
    
    lyricTab.dataSource = self;
    
    lyricTab.rowHeight = 60;
    
    lyricTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [contentScrollView addSubview:lyricTab];
    
    emptyOneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.5_noLoaclProduct"]];
    
    emptyOneImage.hidden = YES;
    
    emptyOneImage.centerX = ScreenWidth/2;
    
    emptyOneImage.y = 100;
    
    [contentScrollView addSubview:emptyOneImage];

    tipOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(emptyOneImage.frame) + 30, ScreenWidth, 20)];
    
    tipOneLabel.textAlignment = NSTextAlignmentCenter;
    
    tipOneLabel.textColor = [UIColor lightGrayColor];
    
    tipOneLabel.text = @"已保存但未上传的作品将会出现在这里";
    
    tipOneLabel.font = [UIFont systemFontOfSize:13];
    
    [contentScrollView addSubview:tipOneLabel];
    musicTab = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.view.height - 64) style:UITableViewStyleGrouped];
    
    musicTab.delegate = self;
    
    musicTab.dataSource = self;
    
    musicTab.rowHeight = 60;
    
    musicTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [contentScrollView addSubview:musicTab];
    
    
    emptyTwoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.5_noLoaclProduct"]];
    
    emptyTwoImage.hidden = YES;
    
    emptyTwoImage.centerX = 3*ScreenWidth/2;
    
    emptyTwoImage.y = 100;
    
    [contentScrollView addSubview:emptyTwoImage];

    tipTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth, CGRectGetMaxY(emptyTwoImage.frame) + 30, ScreenWidth, 20)];
    
    tipTwoLabel.textAlignment = NSTextAlignmentCenter;
    
    tipTwoLabel.textColor = [UIColor lightGrayColor];
    
    tipTwoLabel.text = @"已保存但未上传的作品将会出现在这里";
    
    tipTwoLabel.font = [UIFont systemFontOfSize:13];
    
    [contentScrollView addSubview:tipTwoLabel];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == lyricTab) {
        return _lyricDataArr.count;
    }
    return _musicDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cacheCell";
    
    NSCacheProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[NSCacheProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    return cell;
}
#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
#pragma mark - UITableViewDelegate

- (void)lyricBtnClick:(UIButton *)sender {
//    [self.loginBtn removeFromSuperview];
    
    [contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        lineView.x = sender.x;
    }];
}
- (void)musicBtnClick:(UIButton *)sender {
    [contentScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        lineView.x = sender.x;
    }];
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
