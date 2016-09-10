//
//  NSUserWorkListController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#define kAlertViewTag 200

#import "NSUserWorkListController.h"
#import "NSMyLricListModel.h"
#import "NSUserMusicListModel.h"

@interface NSUserWorkListController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSString *_lyricUrl;
    NSString *_musicUrl;
    NSUInteger _countOfRow;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *lyricesArray;

@property (nonatomic,strong) NSMutableArray *musicArray;

@end

@implementation NSUserWorkListController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initUI];
}

- (void)initUI{
    
    self.page = 1;
    
    self.title = @"我的作品";
    
    [self.view addSubview:self.tableView];
    
    WS(weakSelf);
    [self.tableView addDDPullToRefreshWithActionHandler:^{
       
        if (!weakSelf) {
            
        }else{
            weakSelf.page = 1 ;

            [weakSelf fetchDataWithIsLoadingMore:NO];
        }
        
    }];
    
    [self.tableView addDDInfiniteScrollingWithActionHandler:^{
        
        weakSelf.page ++ ;
        [weakSelf fetchDataWithIsLoadingMore:YES];

    }];
    
    [_tableView triggerPullToRefresh];

}

#pragma mark -fetchData
-(void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = YES;
    if (!isLoadingMore) {
        self.page = 1;
        self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++self.page;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    self.requestType = YES;
    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d", self.page],@"uid":JUserID};
    NSString * str = [NSTool encrytWithDic:dic];
    
    NSString *url;
    if ([self.workType isEqualToString:@"0"]) {
        _musicUrl = [myMusicListURL stringByAppendingString:str];
        url = _musicUrl;
    }else{
        _lyricUrl = [myLyricListURL stringByAppendingString:str];
        url = _lyricUrl;
    }
    self.requestURL = url;
    
    
}

- (void)fetchPublicDataWithWorkId:(NSString *)workId{
    
    self.requestType = NO;
    self.requestParams = @{@"activityid":self.activityId,
                           @"userid":JUserID,
                           @"workid":workId,
                           @"token":LoginToken};
    self.requestURL = joinMatchSubmitUrl;
    
}


- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        [_tableView.pullToRefreshView stopAnimating];
        [_tableView.infiniteScrollingView stopAnimating];
    }else{
        if ([operation.urlTag isEqualToString:_lyricUrl]){
            NSMyLricListModel * myLyricListModel = (NSMyLricListModel *)parserObject;
            if (!operation.isLoadingMore) {
                self.lyricesArray = [NSMutableArray arrayWithArray:myLyricListModel.myLyricList];

            }else{
                [self.lyricesArray addObjectsFromArray:myLyricListModel.myLyricList];
            }
            _countOfRow = self.lyricesArray.count;

            if (!operation.isLoadingMore) {
                [_tableView.pullToRefreshView stopAnimating];
            }else{
                [_tableView.infiniteScrollingView stopAnimating];
            }
            [self.tableView reloadData];
        }
        if ([operation.urlTag isEqualToString:_musicUrl]) {
            NSUserMusicListModel * myMusicListModel = (NSUserMusicListModel *)parserObject;
            if (!operation.isLoadingMore) {
                self.musicArray = [NSMutableArray arrayWithArray:myMusicListModel.myMusicList];
            }else{
                [self.musicArray addObjectsFromArray:myMusicListModel.myMusicList];
            }
            _countOfRow = self.musicArray.count;
            
            if (!operation.isLoadingMore) {
                [_tableView.pullToRefreshView stopAnimating];
            }else{
                [_tableView.infiniteScrollingView stopAnimating];
            }
            [self.tableView reloadData];
        }

        if ([operation.urlTag isEqualToString:joinMatchSubmitUrl]) {
            if (self.submitBlock) {
                self.submitBlock();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _countOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * const cellID = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.textColor = [UIColor hexColorFloat:@"545454"];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    
    UILabel *createTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    createTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    createTimeLabel.textColor = [UIColor hexColorFloat:@"878787"];
    createTimeLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:createTimeLabel];
    [createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).offset(-15.0f);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    
    if ([self.workType isEqualToString:@"0"]) {
        
        NSUserMusicModel *musicModel = self.musicArray[indexPath.row];
        cell.textLabel.text = musicModel.title;
        createTimeLabel.text = [date datetoStringWithDate:musicModel.createtime];
        
    }else{
        NSMyLyricModel *lyricModel = self.lyricesArray[indexPath.row];
        cell.textLabel.text = lyricModel.title;
        createTimeLabel.text = [date datetoStringWithDate:lyricModel.createTime];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"操作" message:@"是否将该作品发布到活动页面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发布", nil];
    if ([self.workType isEqualToString:@"0"]) {
        
        NSUserMusicModel *musicModel = self.musicArray[indexPath.row];
        alertView.tag = musicModel.itemid + kAlertViewTag;
        
    }else{
        NSMyLyricModel *lyricModel = self.lyricesArray[indexPath.row];
        alertView.tag = lyricModel.itemId + kAlertViewTag;

    }
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
    }else{
        [self fetchPublicDataWithWorkId:[NSString stringWithFormat:@"%ld",alertView.tag - kAlertViewTag]];
    }
    
}

#pragma mark - lazy init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor hexColorFloat:@"efeff4"];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



@end
