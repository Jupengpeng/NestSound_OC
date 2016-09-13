//
//  NSPreserveDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveDetailViewController.h"

@interface NSPreserveDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end
static NSString *const preserveDetailCellIdentifier = @"preserveDetailCellIdentifier";
@implementation NSPreserveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPreserveDetailUI];
}
- (void)setupPreserveDetailUI {
    
    self.title = @"保全申请";
    
    UITableView *preserveDetailTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    preserveDetailTab.dataSource = self;
    
    preserveDetailTab.delegate = self;
    
    preserveDetailTab.backgroundColor = KBackgroundColor;
    
    [self.view addSubview:preserveDetailTab];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? 4 : 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles1 = @[@"保全用户信息",@"保全人姓名",@"手机号",@"证件号码",@"保全身份"];
    NSArray *titles2 = @[@"保全人姓名",@"手机号",@"证件号码",@"保全身份"];
    
    UITableViewCell * userMessageCell = [tableView dequeueReusableCellWithIdentifier:preserveDetailCellIdentifier];
    
    if (!userMessageCell) {
        userMessageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:preserveDetailCellIdentifier];
        userMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel * leftLabel = [[UILabel alloc] init];
    if (!indexPath.section) {
        leftLabel.text = titles1[indexPath.row];
    } else {
        leftLabel.text = titles2[indexPath.row];
    }
    
    leftLabel.font = [UIFont systemFontOfSize:15];
    [userMessageCell.contentView addSubview:leftLabel];
    
    UITextField *rightTF = [[UITextField alloc] init];
    [userMessageCell.contentView addSubview:rightTF];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(userMessageCell.contentView.mas_left).offset(15);
        
        make.width.mas_equalTo(100);
        
        make.centerY.equalTo(userMessageCell.mas_centerY);
    }];
    
    [rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(leftLabel.mas_left).offset(90);
        
        make.right.equalTo(userMessageCell.contentView.mas_right).offset(-15);
        
        make.centerY.equalTo(userMessageCell.mas_centerY);
        
    }];
    
    if (!indexPath.section&&!indexPath.row) {
        leftLabel.textColor = [UIColor lightGrayColor];
        rightTF.hidden = YES;
    } else {
        leftLabel.textColor = [UIColor hexColorFloat:@"181818"];
        rightTF.hidden = NO;
    }
    return userMessageCell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
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
