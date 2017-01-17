//
//  NSLocalProductViewController.m
//  NestSound
//
//  Created by yinchao on 2016/11/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLocalProductViewController.h"
#import "NSCacheProductCell.h"
#import "NSAccommpanyListModel.h"
@interface NSLocalProductViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton *lyricBtn;
    UIButton *musicBtn;
    UIView   *lineView;
    int screenWith;
    UIScrollView *contentScrollView;
    UITableView *lyricTab;
    UITableView *musicTab;
    int tableType;
    UIImageView *emptyOneImage;
    UIImageView *emptyTwoImage;
    UILabel *tipOneLabel;
    UILabel *tipTwoLabel;
}
@property (nonatomic ,strong) NSMutableArray *lyricDataArr;
@property (nonatomic ,strong) NSMutableArray *musicDataArr;
@property (nonatomic ,strong) NSMutableArray *accompanyArr;
@property (nonatomic, strong) UIButton *button;
@end

@implementation NSLocalProductViewController
- (NSMutableArray *)lyricDataArr {
    if (!_lyricDataArr) {
        self.lyricDataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _lyricDataArr;
}
- (NSMutableArray *)musicDataArr {
    if (!_musicDataArr) {
        self.musicDataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _musicDataArr;
}
- (NSMutableArray *)accompanyArr {
    if (!_accompanyArr) {
        self.accompanyArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _accompanyArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accompanyArr = [NSMutableArray arrayWithArray:[self getLocalAccompanyList]];
    self.lyricDataArr = [NSMutableArray arrayWithArray:[self getLocalFinishLyricWorkList]];
    self.musicDataArr = [NSMutableArray arrayWithArray:[self getLocalFinishMusicWorkList]];
    
    [self setupLocalProductUI];
    
    if (self.viewFrom == LocalProduct) {
        if (!_lyricDataArr.count) {
            
            emptyOneImage.hidden = NO;
            tipOneLabel.hidden = NO;
        }
        
        if (!_musicDataArr.count) {
            emptyTwoImage.hidden = NO;
            tipTwoLabel.hidden = NO;
        }
    } else {
        if (!self.accompanyArr.count) {
            emptyOneImage.hidden = NO;
            tipOneLabel.hidden = NO;
        }
    }
    
    
}

- (NSArray *)getLocalFinishMusicWorkList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:LocalFinishMusicWorkListKey]) {
        
        [fileManager createFileAtPath:LocalFinishMusicWorkListKey contents:nil attributes:nil];
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:LocalFinishMusicWorkListKey] ];
    if (!resultArray) {
        resultArray = [NSMutableArray array];
    }
    NSMutableArray *workList = [NSMutableArray array];
    for (NSString *jsonStr in resultArray) {
        NSDictionary *jsonDIct = [NSTool dictionaryWithJsonString:jsonStr];
        [workList addObject:jsonDIct];
    }
    
    return workList;
}
- (NSArray *)getLocalFinishLyricWorkList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:LocalFinishLyricWorkListKey]) {
        
        [fileManager createFileAtPath:LocalFinishLyricWorkListKey contents:nil attributes:nil];
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:LocalFinishLyricWorkListKey] ];
    if (!resultArray) {
        resultArray = [NSMutableArray array];
    }
    NSMutableArray *workList = [NSMutableArray array];
    for (NSString *jsonStr in resultArray) {
        NSDictionary *jsonDIct = [NSTool dictionaryWithJsonString:jsonStr];
        [workList addObject:jsonDIct];
    }
    
    return workList;
}
- (NSArray *)getLocalAccompanyList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:LocalAccompanyListPath]) {
        
        [fileManager createFileAtPath:LocalAccompanyListPath contents:nil attributes:nil];
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:LocalAccompanyListPath] ];
    if (!resultArray) {
        resultArray = [NSMutableArray array];
    }

    NSMutableArray *acoompanyList = [NSMutableArray array];
    for (NSString *jsonStr in resultArray) {
        NSAccommpanyModel *accompanyModel = [NSAccommpanyModel yy_modelWithJSON:jsonStr];
        [acoompanyList addObject:accompanyModel];
    }
    return acoompanyList;
}

- (void)setupLocalProductUI {
    if (self.viewFrom == LocalProduct) {
        screenWith = 2;
        tableType = 1;
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
    
    tipOneLabel.hidden = YES;
    
    tipOneLabel.textAlignment = NSTextAlignmentCenter;
    
    tipOneLabel.textColor = [UIColor lightGrayColor];
    if (self.viewFrom == LocalProduct) {
        tipOneLabel.text = @"已保存但未上传的作品将会出现在这里";
    } else {
        tipOneLabel.text = @"您还未缓存过任何伴奏";
    }
    
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
    
    tipTwoLabel.hidden = YES;
    
    tipTwoLabel.textAlignment = NSTextAlignmentCenter;
    
    tipTwoLabel.textColor = [UIColor lightGrayColor];
    
    tipTwoLabel.text = @"已保存但未上传的作品将会出现在这里";
    
    tipTwoLabel.font = [UIFont systemFontOfSize:13];
    
    [contentScrollView addSubview:tipTwoLabel];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewFrom == AccompanyCache) {
        return self.accompanyArr.count;
    } else {
        if (tableView == lyricTab) {
            return _lyricDataArr.count;
        }
        return _musicDataArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cacheCell";
    
    NSCacheProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[NSCacheProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.playBtn addTarget:self action:@selector(playBntClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.viewFrom == AccompanyCache) {
        cell.accompanyModel = self.accompanyArr[indexPath.row];
    } else {
        if (tableView == lyricTab) {
            [cell setupCacheLyricProductWithDictionary:self.lyricDataArr[indexPath.row]];
        } else {
            
        }
        
    }
    return cell;
}
#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if (self.viewFrom == AccompanyCache) {
            [self.accompanyArr removeObjectAtIndex:indexPath.row];
        } else {
            if (tableView == lyricTab) {
                [self.lyricDataArr removeObjectAtIndex:indexPath.row];
            } else {
                [self.musicDataArr removeObjectAtIndex:indexPath.row];
            }
        }
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}
- (void)playBntClick:(UIButton *)sender {
    if (self.viewFrom == AccompanyCache) {
        
        sender.selected = !sender.selected;
        
        if (sender == self.button) {
            
        } else {
            
            self.button.selected = NO;
        }
//        NSAccompanyTableCell * cell = (NSAccompanyTableCell *)btn.superview.superview;
#warning 播放缓存好的伴奏
        if (sender.selected) {
            
//            if (self.player) {
//                
//                [NSPlayMusicTool pauseMusicWithName:nil];
//                
//                self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
//                
//            } else {
//                
//                self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
//            }
            
        } else {
            
//            [NSPlayMusicTool pauseMusicWithName:nil];
        }
        
        self.button = sender;
        
    } else {
        
        if (tableType == 1) {
#warning 发布歌词
            
        } else {
            
#warning 发布歌曲
        }
        
    }
}
- (void)lyricBtnClick:(UIButton *)sender {
//    [self.loginBtn removeFromSuperview];
    
    tableType = 1;
    
    [contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        lineView.x = sender.x;
    }];
}
- (void)musicBtnClick:(UIButton *)sender {
    
    tableType = 2;
    
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
