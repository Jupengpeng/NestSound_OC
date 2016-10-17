//
//  NSInspirationListViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/20.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInspirationListViewController.h"
#import "NSInspirationRecordTableViewCell.h"
#import "NSInspirationRecordViewController.h"
#import "NSDiscoverMoreLyricModel.h"
@interface NSInspirationListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int currentPage;
    NSString *url;
    UIImageView *emptyImage;
}
@property (nonatomic, strong) UITableView *inspirationTab;
@property (nonatomic, strong) NSMutableArray *myInspirationAry;
@end
static NSString *cellIdentifier = @"cellIdentifier";
@implementation NSInspirationListViewController
- (NSMutableArray *)myInspirationAry {
    if (!_myInspirationAry) {
        self.myInspirationAry = [NSMutableArray array];
    }
    return _myInspirationAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureInspirationListUI];
    [self fectInspirationDataWithIsLoadingMore:NO];
    
    //无数据显示
    [self.view addSubview:self.noDataView];
}
- (void)fectInspirationDataWithIsLoadingMore:(BOOL)isLoadingMore {
    self.requestType = YES;
    NSDictionary * dic;
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    dic = @{@"uid":JUserID,@"token":LoginToken,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:4]};
    NSString * str = [NSTool encrytWithDic:dic];
    url = [userMLICListUrl stringByAppendingString:str];
    self.requestURL = url;
}
#pragma mark -override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if ( requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSDiscoverMoreLyricModel * discoverMore = (NSDiscoverMoreLyricModel *)parserObject;
                if (!operation.isLoadingMore) {
                    [_inspirationTab.pullToRefreshView stopAnimating];
                    self.myInspirationAry = [NSMutableArray arrayWithArray:discoverMore.moreLyricList];
                    
                }else{
                    [_inspirationTab.infiniteScrollingView stopAnimating];
                    [self.myInspirationAry addObjectsFromArray:discoverMore.moreLyricList];
                }
                
                if (!self.myInspirationAry.count) {
                    self.noDataView.hidden = NO;
                }else{
                    self.noDataView.hidden = YES;

                }
                
                [_inspirationTab reloadData];
                if (!self.myInspirationAry.count) {
                    emptyImage.hidden = NO;
                }
            }
        }
    }
}
- (void)configureInspirationListUI {
    self.title = @"灵感纪录";
    
    self.inspirationTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _inspirationTab.delegate = self;
    
    _inspirationTab.dataSource = self;
    
    _inspirationTab.rowHeight = 140;
    
    _inspirationTab.backgroundColor = [UIColor whiteColor];
    
    [_inspirationTab registerClass:[NSInspirationRecordTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _inspirationTab.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_inspirationTab];
    
    [_inspirationTab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_inspirationTab setTableFooterView:noLineView];
    
    WS(wSelf);
    [_inspirationTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fectInspirationDataWithIsLoadingMore:NO];
        }
    }];
    [_inspirationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fectInspirationDataWithIsLoadingMore:YES];
        }
    }];
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyImage.hidden = YES;
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [self.view addSubview:emptyImage];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myInspirationAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSInspirationRecordTableViewCell *cell =(NSInspirationRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.myInspirationModel = _myInspirationAry[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMyMusicModel * myMusic = _myInspirationAry[indexPath.row];
    NSInspirationRecordViewController * inspirationVC = [[NSInspirationRecordViewController alloc] initWithItemId:myMusic.itemId andType:NO];
    [self.navigationController pushViewController:inspirationVC animated:YES];
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
