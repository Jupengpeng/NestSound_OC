//
//  NSPreserveDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveDetailViewController.h"
#import "NSPreserveWorkInfoCell.h"
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
    
    UITableView *preserveDetailTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60) style:UITableViewStyleGrouped];
    
    preserveDetailTab.dataSource = self;
    
    preserveDetailTab.delegate = self;
    
    preserveDetailTab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    preserveDetailTab.backgroundColor = KBackgroundColor;
    
    [self.view addSubview:preserveDetailTab];
    
    UIButton *preserveState = [UIButton buttonWithType:UIButtonTypeSystem];
    
    preserveState.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
    
    preserveState.layer.cornerRadius = 20;
    
    preserveState.layer.masksToBounds = YES;
    
    [preserveState setTitle:@"申请中..." forState:UIControlStateNormal];
    
    [preserveState setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [preserveState addTarget:self action:@selector(handleUserMessageFinish) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:preserveState];
    
    [preserveState mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.height.mas_equalTo(40);
        
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return 4;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles1 = @[@"保全用户信息",@"保全人姓名",@"手机号",@"证件号码",@"保全身份"];
    NSArray *titles2 = @[@"保全人姓名",@"手机号",@"证件号码",@"保全身份"];
    
    UITableViewCell * userMessageCell = [tableView dequeueReusableCellWithIdentifier:preserveDetailCellIdentifier];
    NSPreserveWorkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSPreserveWorkInfoCellId"];
    if (indexPath.section == 2) {
        if (!cell) {
            cell = [[NSPreserveWorkInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSPreserveWorkInfoCellId"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupData];
        return cell;
    } else {
        if (!userMessageCell) {
            userMessageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:preserveDetailCellIdentifier];
            userMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel * leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:15];
        [userMessageCell.contentView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = [UIColor lightGrayColor];
        [userMessageCell.contentView addSubview:rightLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(userMessageCell.contentView.mas_left).offset(15);
            
            make.width.mas_equalTo(100);
            
            make.centerY.equalTo(userMessageCell.mas_centerY);
        }];
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(leftLabel.mas_left).offset(90);
            
            make.right.equalTo(userMessageCell.contentView.mas_right).offset(-15);
            
            make.centerY.equalTo(userMessageCell.mas_centerY);
            
        }];
        if (!indexPath.section) {
            leftLabel.text = titles1[indexPath.row];
            rightLabel.text = titles1[indexPath.row];
        } else {
            leftLabel.text = titles2[indexPath.row];
            rightLabel.text = titles2[indexPath.row];
        }
        if (!indexPath.section&&!indexPath.row) {
            leftLabel.textColor = [UIColor lightGrayColor];
            rightLabel.hidden = YES;
        } else {
            leftLabel.textColor = [UIColor hexColorFloat:@"181818"];
            rightLabel.hidden = NO;
        }
        return userMessageCell;
    }
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 2 ? 185 : 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
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