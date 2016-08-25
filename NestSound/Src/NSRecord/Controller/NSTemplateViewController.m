//
//  NSTemplateViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSTemplateViewController.h"
#import "NSEditTemplateViewController.h"
#import "NSTemplateListModel.h"
@interface NSTemplateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *templateListTab;
    NSInteger currentPage;
}
@property (nonatomic, strong) NSMutableArray *templateListArr;
@end
static NSString  * const templateCellIdifity = @"templateCell";
@implementation NSTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTemplateUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.templateListArr.count) {
        [templateListTab setContentOffset:CGPointMake(0, -60) animated:YES];
            [templateListTab performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
    }
    
    
}
#pragma mark -fectData
-(void)fetchDraftListDataIsLoadingMore:(BOOL)isLoadingMore
{
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],kIsLoadingMore:@(NO),@"token":LoginToken};
    }else{
        ++currentPage;
        self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],kIsLoadingMore:@(YES),@"token":LoginToken};
    }
    self.requestType = NO;
    self.requestURL = templateListUrl;
    
}

#pragma mark --override action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:templateListUrl]) {
                NSTemplateListModel * templateList = (NSTemplateListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    
                    [templateListTab.pullToRefreshView stopAnimating];
                    
                    self.templateListArr = [NSMutableArray arrayWithArray:templateList.templateList];
                }else{
                    
                    [templateListTab.infiniteScrollingView stopAnimating];
                    
                    for (NSTemplateModel *model in templateList.templateList) {
                        [self.templateListArr addObject:model];
                    }
                }
                
                [templateListTab reloadData];
            } else if ([operation.urlTag isEqualToString:deleteDraftUrl]) {
                [[NSToastManager manager] showtoast:@"操作成功"];
            }
        }
    }
}
#pragma mark -configureAppearance
- (void)setupTemplateUI {
    
    self.title = @"模版";

    self.view.backgroundColor = KBackgroundColor;
    
    //templateListTableView
    templateListTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    
    templateListTab.delegate = self;
    
    templateListTab.dataSource = self;
    
     templateListTab.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [templateListTab registerClass:[UITableViewCell class] forCellReuseIdentifier:templateCellIdifity];
    
    [self.view addSubview:templateListTab];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [templateListTab setTableFooterView:noLineView];
    
    WS(wSelf);
    
    //refresh
    [templateListTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchDraftListDataIsLoadingMore:NO];
        }
    }];
    
    //loadingMore
    [templateListTab addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchDraftListDataIsLoadingMore:YES];
        }
    }];
//    templateListTab.showsInfiniteScrolling = NO;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.templateListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSTemplateModel *model = self.templateListArr[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:templateCellIdifity forIndexPath:indexPath];
    
    cell.textLabel.text = model.title;
    
    UIImageView *musicalNote = [UIImageView new];
    
    musicalNote.image = [UIImage imageNamed:@"2.0_music_note"];
    
    [cell addSubview:musicalNote];
    
    [musicalNote mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(cell.mas_right).offset(-10);
        
        make.centerY.equalTo(cell.mas_centerY);
    }];
    
    if (model.playUrl.length) {
        
        musicalNote.hidden = NO;
    } else {
        
        musicalNote.hidden = YES;
    }
    
    return cell;
}

#pragma mark collectionViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSTemplateModel *model = self.templateListArr[indexPath.row];
    
    NSEditTemplateViewController *editTemplateVC = [[NSEditTemplateViewController alloc] initWithTemplateTitle:model.title templateContent:model.content playUrl:model.playUrl];
    
    [self.navigationController pushViewController:editTemplateVC animated:YES];
    
}
- (void)saveTemplate {
    
}
- (NSMutableArray *)templateListArr {
    if (!_templateListArr) {
        self.templateListArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _templateListArr;
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
