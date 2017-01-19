//
//  NSSettingViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/20.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSettingViewController.h"
#import "NSAboutUsViewController.h"
#import "NSModifyPwdViewController.h"
#import "NSBindThirdAccountViewController.h"
@interface NSSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *settingTable;
}
@end
static NSString * const SettingCellIdefity = @"SettingCell";
static NSString * const LoginOutIdefity = @"LoginOutCell";
@implementation NSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSettingUI];
}
- (void)configureSettingUI {
    self.title = @"设置";
    //settingPaegTable
    settingTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    settingTable.dataSource = self;
    settingTable.delegate = self;
    settingTable.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    [self.view addSubview:settingTable];
    //messageNotificationSwitch
//    messageNotifictionSwitch = [[UISwitch alloc] init];
//    messageNotifictionSwitch.tintColor = [UIColor hexColorFloat:@"ffd00b"];
    
    //constraints
    [settingTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}
#pragma mark TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section == 0 ? 3: 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *stringArr = @[@"修改密码",@"新消息通知",@"关于我们"];
    
    UITableViewCell * settingCell = [tableView dequeueReusableCellWithIdentifier:SettingCellIdefity];
    UITableViewCell * loginOutCell = [tableView dequeueReusableCellWithIdentifier:LoginOutIdefity];
    
    
    if (indexPath.section == 0){
        
        if (!settingCell) {
            settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingCellIdefity];
            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        settingCell.textLabel.text = stringArr[indexPath.row];
//        if (indexPath.row == 1) {
//            settingCell.accessoryType = UITableViewCellAccessoryNone;
//            settingCell.detailTextLabel.text = [Memory getCacheSize];
//            settingCell.detailTextLabel.tag = 100;
//        }
        
        return settingCell;
        
    } else if (indexPath.section == 1){
        if (!loginOutCell) {
            loginOutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoginOutIdefity];
            
        }
        loginOutCell.textLabel.textColor = [UIColor redColor];
        loginOutCell.textLabel.text = @"退出登录";
        //        LocalizedStr(@"prompt_loginOut");
        loginOutCell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return loginOutCell;
        
    }
    return settingCell;
}

#pragma mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0){
//        if (row == 0) {
//            NSBindThirdAccountViewController *bindAccountVC = [[NSBindThirdAccountViewController alloc] init];
//            [self.navigationController pushViewController:bindAccountVC animated:YES];
//            
//        } else
            if (row == 0) {
            NSModifyPwdViewController *modifyPwdVC = [[NSModifyPwdViewController alloc] init];
            [self.navigationController pushViewController:modifyPwdVC animated:YES];
            
        }
//            else if (row == 1) {
//            [Memory clearCache];
//            [[NSToastManager manager] showtoast:@"已成功清理缓存"];
//            UITableViewCell * settingCell = [settingTable cellForRowAtIndexPath:indexPath];
//            UILabel * cacheSize = (UILabel *)[settingCell viewWithTag:100];
//            cacheSize.text = [Memory getCacheSize];
//        }
        else if (row == 1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else if (row == 2){
            
            NSAboutUsViewController *aboutUsVC = [[NSAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
        
    }else if(section == 1){
        
        //logingOut
        [self logintOut];
    }
    
}

#pragma mark -loginOut
-(void)logintOut
{
    self.requestType = NO;
    self.requestParams = @{@"token":LoginToken};
    self.requestURL = loginOutURL;
    
}

-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:loginOutURL]) {
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:@"user"];
                [MobClick profileSignOff];
                [user synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBtnsState" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }
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
