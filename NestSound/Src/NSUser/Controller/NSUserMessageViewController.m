//
//  NSUserMessageViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/12.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserMessageViewController.h"
#import "NSPreservePersonListModel.h"
@interface NSUserMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UserMessageType type;
    UITableView *userMessageTab;
    UITableViewCell * userMessageCell;
    NSDictionary *userMessageDic;
    UILabel * leftLabel;
//    UITextField *rightTF;
}
@end
@implementation NSUserMessageViewController
- (instancetype)initWithUserMessageType:(UserMessageType)userMessageType_ {
    if (self = [super init]) {
        type = userMessageType_;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUserMessageView];
    [self fetchPreserveUserMessageData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id obj;
    if (self.fillInBlock) {
        self.fillInBlock(obj);
    }
}
- (void)fetchPreserveUserMessageData {
    
    self.requestType = NO;
    
    self.requestParams = @{@"token":LoginToken,@"bq_uid":JUserID};
    
    self.requestURL = preservePersonListUrl;
}

- (void)handleUserMessageFinish {
    UITableViewCell *cell1 = (UITableViewCell *)[userMessageTab viewWithTag:161];
    UITextField *textField1 = (UITextField*)[cell1 viewWithTag:180];
    UITableViewCell *cell2 = (UITableViewCell *)[userMessageTab viewWithTag:162];
    UITextField *textField2 = (UITextField*)[cell2 viewWithTag:180];
    UITableViewCell *cell3 = (UITableViewCell *)[userMessageTab viewWithTag:163];
    UITextField *textField3 = (UITextField*)[cell3 viewWithTag:180];
    self.requestType = NO;
    if (userMessageDic[@"bq_id"]) {
        self.requestParams = @{@"token":LoginToken,
                               @"bq_uid":JUserID,
                               @"bq_id":userMessageDic[@"bq_id"],
                               @"bq_username":
                                   textField1.text,
                               @"bq_phone":
                                   textField2.text,
                               @"bq_creditID":
                                   textField3.text
                               };
    } else {
        self.requestParams = @{@"token":LoginToken,
                               @"bq_uid":JUserID,
//                               @"bq_id":@(NULL),
                               @"bq_username":
                                   textField1.text,
                               @"bq_creditID":
                                   textField2.text,
                               @"bq_phone":
                                   textField3.text
                               };
    }
    
    self.requestURL = addPreservePersonUrl;
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        
    }else{
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:preservePersonListUrl]) {

                userMessageDic = (NSDictionary *)parserObject.data;
                [userMessageTab reloadData];
                
            } else if ([operation.urlTag isEqualToString:addPreservePersonUrl]) {
              
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }
}
- (void)configureUserMessageView {
    if (type == EditMessageType) {
        
        self.title = @"个人信息填写";
    } else {
        
        self.title = @"个人信息";
    }
    
    userMessageTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180) style:UITableViewStyleGrouped];
    
    userMessageTab.dataSource = self;
    
    userMessageTab.delegate = self;
    
    userMessageTab.scrollEnabled = NO;
    
    [self.view addSubview:userMessageTab];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    finishBtn.frame = CGRectMake(15, CGRectGetMaxY(userMessageTab.frame) + 20, ScreenWidth - 30, 40);
    
    finishBtn.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
    
    finishBtn.layer.cornerRadius = 20;
    
    finishBtn.layer.masksToBounds = YES;
    
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [finishBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [finishBtn addTarget:self action:@selector(handleUserMessageFinish) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:finishBtn];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles = @[@"保全用户信息",@"姓名",@"身份证",@"手机号"];
    
    userMessageCell = [[UITableViewCell alloc] init];
    userMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;

    userMessageCell.tag = 160 + indexPath.row;
    leftLabel = [[UILabel alloc] init];
    leftLabel.text = titles[indexPath.row];
    leftLabel.font = [UIFont systemFontOfSize:15];
    [userMessageCell.contentView addSubview:leftLabel];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userMessageCell.contentView.mas_left).offset(15);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(userMessageCell.mas_centerY);
    }];

    UITextField *rightTF = [[UITextField alloc] init];
    rightTF.textColor = [UIColor lightGrayColor];
    rightTF.tag = 180;
    if (userMessageDic) {
        if (indexPath.row ==1) {
            rightTF.text = userMessageDic[@"bq_username"];
        } else if (indexPath.row == 2) {
            rightTF.text = userMessageDic[@"bq_creditID"];
        } else {
            rightTF.text = userMessageDic[@"bq_phone"];
        }
    }
    [userMessageCell.contentView addSubview:rightTF];
    [rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_left).offset(60);
        make.right.equalTo(userMessageCell.contentView.mas_right).offset(-15);
        make.centerY.equalTo(userMessageCell.mas_centerY);
    }];
    

    if (!indexPath.row) {
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
    return 1;
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
