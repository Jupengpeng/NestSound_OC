//
//  NSInvitationListViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInvitationListViewController.h"
#import "NSInvitationListTableViewCell.h"
@interface NSInvitationListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation NSInvitationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInvitationView];
}
- (void)setupInvitationView {
    
    self.title = @"邀请";

    self.view.backgroundColor = KBackgroundColor;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 30)];
    
//    searchBar.backgroundColor = [UIColor lightGrayColor];
    
    searchBar.backgroundImage = [image imageWithColor:[UIColor whiteColor] size:searchBar.bounds.size];
    
    searchBar.layer.cornerRadius = 5;
    
    searchBar.layer.masksToBounds = YES;
    
    searchBar.delegate = self;
    
//    searchBar.tintColor = [UIColor darkGrayColor];
    
    searchBar.showsCancelButton = NO;
    
    searchBar.placeholder = @"搜索";
    
    [self.view addSubview:searchBar];
    
    UITableView *invitationTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-40) style:UITableViewStylePlain];
    
    invitationTab.dataSource = self;
    
    invitationTab.delegate = self;
    
    invitationTab.rowHeight = 60;
    
    [self.view addSubview:invitationTab];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"invitationCell";
    
    NSInvitationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSInvitationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
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
