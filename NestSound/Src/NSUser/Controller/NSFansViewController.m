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
@interface NSFansViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    UITableView * fansTableView;
    NSMutableArray * fansAry;
    NSString * userId;
    BOOL isFans;
    int currentPage;
    NSString * fansURL;
    NSString * fansType;
}
@end

static NSString * const NSFansCellIdeify = @"NSFanscell";

@implementation NSFansViewController

-(instancetype)initWithUserID:(NSString *)UserID _isFans:(BOOL)isFans_
{
    if (self = [super init]) {
        isFans = isFans_;
        userId = UserID;
    }
    return  self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
}

#pragma mark -fetchFansListData
-(void)fetchFansListData
{
    [fansTableView setContentOffset:CGPointMake(0, 60) animated:YES];
    [fansTableView performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
}


-(void)fetchFansListDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    if (!isLoadingMore) {
        currentPage = 1;
    }else{
        ++currentPage;
    }
    if (isFans) {
        fansType = [NSString stringWithFormat:@"%d",1];
    }else{
        fansType = [NSString stringWithFormat:@"%d",2];
    }
    NSDictionary * dic = @{@"userid":JUserID,@"token":LoginToken,@"page":[NSString stringWithFormat:@"%d",currentPage],@"type":fansType};
    NSString * str = [NSTool encrytWithDic:dic];
    fansURL = [myFansListURL stringByAppendingString:str];
    self.requestURL = fansURL;
    
}

#pragma mark -overrider actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (parserObject.success) {
     
        if ([operation.urlTag isEqualToString:fansURL]) {
            
            
            
        }
        
    }
    
}


#pragma mark
-(void)configureUIAppearance
{
    
    //nav
    if (isFans) {
        self.title = LocalizedStr(@"prompt_fans");
    }else{
        self.title = LocalizedStr(@"prompt_focus");
    }
    
    
    //fansTableView
    fansTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    fansTableView.dataSource = self;
    fansTableView.delegate = self;
    [fansTableView registerClass:[NSFanscell class] forCellReuseIdentifier:NSFansCellIdeify];
    [self.view addSubview:fansTableView];
    
    fansAry = [[NSMutableArray alloc] init];
    
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
    fansCell.fansModel = fansAry[indexPath.row];
//    fansCell.isFocus = NO;
    
    return fansCell;
    
}
#pragma mark TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserPageViewController * userVC = [[NSUserPageViewController alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];

}

@end
