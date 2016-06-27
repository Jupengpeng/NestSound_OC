//
//  NSFansViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSFansViewController.h"
#import "NSFanscell.h"
#import "NSUserPageViewController.h"
#import "NSFansListModel.h"
@interface NSFansViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    UITableView * fansTableView;
    UIImageView * emptyImageView;
    NSMutableArray * fansAry;
    NSString * userId;
    BOOL isFans;
    int currentPage;
    NSString * fansURL;
    NSString * otherFansURL;
    int fansType;
    Who _iswho;
}
@end

static NSString * const NSFansCellIdeify = @"NSFanscell";

@implementation NSFansViewController

-(instancetype)initWithUserID:(NSString *)UserID _isFans:(BOOL)isFans_ isWho:(BOOL)isWho
{
    if (self = [super init]) {
        isFans = isFans_;
        userId = UserID;
        _iswho = isWho;
    }
    return  self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAppearance];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchFansListData];
}
#pragma mark -fetchFansListData
-(void)fetchFansListData
{
    if (fansAry.count == 0) {
        [fansTableView setContentOffset:CGPointMake(0, -60) animated:YES];
        [fansTableView performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
    }
   
}


-(void)fetchFansListDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = YES;
    if (!isLoadingMore) {
        currentPage = 1;
    }else{
        ++currentPage;
    }
    self.requestParams = @{kIsLoadingMore :@(isLoadingMore)};
    if (isFans) {
        fansType = 1;
    }else{
        fansType = 2;
    }
    if (_iswho == Myself) {
        NSDictionary * dic = @{@"userid":JUserID,@"token":LoginToken,@"page":[NSString stringWithFormat:@"%d",currentPage],@"type":[NSNumber numberWithInt:fansType]};
        NSString * str = [NSTool encrytWithDic:dic];
        fansURL = [myFansListURL stringByAppendingString:str];
        self.requestURL = fansURL;

    }else{
        NSDictionary * dic = @{@"userid":userId,@"uid":JUserID,@"token":LoginToken,@"page":[NSString stringWithFormat:@"%d",currentPage],@"type":[NSNumber numberWithInt:fansType]};
        NSString * str = [NSTool encrytWithDic:dic];
        otherFansURL = [otherFFURL stringByAppendingString:str];
        self.requestURL = otherFansURL;
    }
    
}

#pragma mark -overrider actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
     
        if ([operation.urlTag isEqualToString:fansURL]||[operation.urlTag isEqualToString:otherFansURL]) {
            
            NSFansListModel * fansList = (NSFansListModel *)parserObject;
            if (!operation.isLoadingMore) {
                fansAry = [NSMutableArray arrayWithArray:fansList.fansListModel];
            }else{
                if (fansList.fansListModel.count!=0) {
                    [fansAry addObjectsFromArray:fansList.fansListModel];
                }
                
            }
        }
        if (fansAry.count == 0) {
            emptyImageView.hidden = NO;
        }
        [fansTableView reloadData];
        if (!operation.isLoadingMore) {
            [fansTableView.pullToRefreshView stopAnimating];
            
        }else{
            [fansTableView.infiniteScrollingView stopAnimating];
        }
        
    }
    
}


#pragma mark
-(void)configureUIAppearance
{
    
    //emptyImageView
    emptyImageView = [[UIImageView alloc] init];
    [self.view addSubview:emptyImageView];
    emptyImageView.hidden = YES;
    //nav
    if (isFans) {
        self.title = @"粉丝";
        emptyImageView.image = [UIImage imageNamed:@"2.0_noFans_bk"];
    }else{
        self.title = @"关注";
        emptyImageView.image = [UIImage imageNamed:@"2.0_noFocus_bk"];
    }
    
    
    //fansTableView
    fansTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    fansTableView.dataSource = self;
    fansTableView.delegate = self;
     fansTableView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    fansTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [fansTableView registerClass:[NSFanscell class] forCellReuseIdentifier:NSFansCellIdeify];
    [self.view addSubview:fansTableView];
    
    [fansTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    WS(wSelf);
    [fansTableView addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchFansListDataWithIsLoadingMore:NO];
        }
    }];
    
    [fansTableView addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchFansListDataWithIsLoadingMore:YES];
        }
    }];
    
   
    fansTableView.showsInfiniteScrolling = NO;
    
}


#pragma mark -focusUser
-(void)focusWithBtn:(UIButton *)btn
{
    NSFanscell * cell = (NSFanscell *)btn.superview.superview;
    self.requestType = NO;
    self.requestParams =@{@"userid":@(cell.fansModel.fansID),@"fansid":JUserID,@"token":LoginToken};
    self.requestURL = focusUserURL;
}

#pragma mark -tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return fansAry.count;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFanscell * fansCell = [tableView dequeueReusableCellWithIdentifier:NSFansCellIdeify];
    if (!fansCell) {
        fansCell = [[NSFanscell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSFansCellIdeify];
        
    }
    [fansCell.focusBtn addTarget:self action:@selector(focusWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    fansCell.fansModel = fansAry[indexPath.row];
    if (isFans) {
        fansCell.isFans = YES;
    }else{
        fansCell.isFans = NO;
    }
    
    return fansCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}
#pragma mark TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFansModel * fans = fansAry[indexPath.row];
    NSUserPageViewController * userVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",fans.fansID]];
    if ([NSTool compareWithUser:fans.fansID]) {
        userVC.who = Myself;
    }else{
        userVC.who = Other;
    }
    [self.navigationController pushViewController:userVC animated:YES];

}

@end
