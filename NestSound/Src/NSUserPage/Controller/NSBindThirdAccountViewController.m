//
//  NSBindThirdAccountViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBindThirdAccountViewController.h"

@interface NSBindThirdAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *bindThirdAccountTab;
}

@end
static NSString *bindAccountCellIdentifier = @"bindAccountCellIdentifier";
@implementation NSBindThirdAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBindThirdAccountUI];
}
- (void)configureBindThirdAccountUI {
    
    self.title = @"账号绑定信息";
    
    bindThirdAccountTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    bindThirdAccountTab.dataSource = self;
    
    bindThirdAccountTab.delegate = self;
    
    bindThirdAccountTab.rowHeight = 60;
    
    bindThirdAccountTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self.view addSubview:bindThirdAccountTab];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *bindAccountCell = [tableView dequeueReusableCellWithIdentifier:bindAccountCellIdentifier];
    
    NSArray *titles = @[@"微信",@"微博",@"QQ"];
    NSArray *images = @[@"2.0_weChat",@"2.0_sina",@"2.0_qq"];
    if (!bindAccountCell) {
        bindAccountCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bindAccountCellIdentifier];
        UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        bindBtn.layer.cornerRadius = 3;
        bindBtn.layer.masksToBounds = YES;
        [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [bindBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        bindBtn.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
        [bindAccountCell addSubview:bindBtn];
        [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bindAccountCell.mas_right).offset(-10);
            make.centerY.equalTo(bindAccountCell.mas_centerY);
            make.width.mas_offset(80);
        }];
    }
    bindAccountCell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    bindAccountCell.textLabel.text = titles[indexPath.row];
    return bindAccountCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
