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
}
@end

static NSString * const NSFansCellIdeify = @"NSFanscell";

@implementation NSFansViewController

-(instancetype)initWithUserID:(NSString *)UserID _isFans:(BOOL)isFans_
{
    if (self = [super init]) {
        isFans = isFans_;
        userId = UserID;
        [self configureUIAppearance];
    }
    return  self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFanscell * fansCell = [tableView dequeueReusableCellWithIdentifier:NSFansCellIdeify];
    if (!fansCell) {
        fansCell = [[NSFanscell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSFansCellIdeify];
        
    }
    fansCell.headUrl = @"";
    fansCell.authorName = @"hjay";
    fansCell.desc = @"i am a shy boy";
    fansCell.isFocus = NO;
    
    return fansCell;
    
}
#pragma mark TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserPageViewController * userVC = [[NSUserPageViewController alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];

}

@end
