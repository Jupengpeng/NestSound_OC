//
//  NSInspirationListViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/20.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInspirationListViewController.h"
#import "NSInspirationRecordTableViewCell.h"
@interface NSInspirationListViewController ()
@property (nonatomic, strong) UITableView *inspirationTab;
@end
static NSString *cellIdentifier = @"cellIdentifier";
@implementation NSInspirationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureInspirationListUI];
}
- (void)configureInspirationListUI {
    self.inspirationTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _inspirationTab.delegate = self;
    
    _inspirationTab.dataSource = self;
    
    _inspirationTab.backgroundColor = [UIColor whiteColor];
    
    [_inspirationTab registerClass:[NSInspirationRecordTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _inspirationTab.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_inspirationTab];
    
    WS(wSelf);
    [_inspirationTab addInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
//            [wSelf fetchUserDataWithIsSelf:wSelf.who andIsLoadingMore:YES];
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
//    return dataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        
        NSInspirationRecordTableViewCell *cell =(NSInspirationRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
//        cell.myInspirationModel = dataAry[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    
    
    
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
