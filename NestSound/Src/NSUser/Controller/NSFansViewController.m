//
//  NSFansViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSFansViewController.h"
#import "NSFanscell.h"
@interface NSFansViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    UITableView * fansTableView;
    NSMutableArray * fansAry;
}
@end

static NSString * const NSFansCellIdeify = @"NSFanscell";

@implementation NSFansViewController

-(instancetype)initWithUserID:(NSString *)UserID
{
    if (self = [super init]) {
        
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFanscell * fansCell = [tableView dequeueReusableCellWithIdentifier:NSFansCellIdeify];

    
    return fansCell;
    
}


@end
