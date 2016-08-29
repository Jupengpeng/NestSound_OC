//
//  NSUserViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserViewController.h"
#import "NSUserProfileCell.h"
#import "NSUserProfileViewController.h"
#import "NSUserFeedbackViewController.h"
#import "NSAboutUsViewController.h"
#import "NSModifyPwdViewController.h"
@interface NSUserViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSIndexPath * index;
    
    UITableView * settingPageTable;
    
    UISwitch * messageNotifictionSwitch;

}
@end

static NSString * const UserProfileCellIdefity = @"NSUserProfileCell";
static NSString * const SettingCellIdefity = @"SettingCell";
static NSString * const LoginOutIdefity = @"LoginOutCell";

@implementation NSUserViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserProfileCell *cell = (NSUserProfileCell *)[settingPageTable viewWithTag:125];
    NSMutableDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    [cell.userIcon setDDImageWithURLString:userInfo[@"userIcon"] placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    cell.nickName = userInfo[@"userName"];
    cell.number = userInfo[@"desc"];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureAppearance];

}


-(void)configureAppearance
{
    /**
     *  是导航栏吧白色，解决前面透明的跳入显示不正确
     */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //nav
    self.title = @"设置";
    //LocalizedStr(@"me");
//    self.showBackBtn = YES;
    
    //settingPaegTable
    settingPageTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    settingPageTable.dataSource = self;
    settingPageTable.delegate = self;
    settingPageTable.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    [self.view addSubview:settingPageTable];
    //messageNotificationSwitch
    messageNotifictionSwitch = [[UISwitch alloc] init];
    messageNotifictionSwitch.tintColor = [UIColor hexColorFloat:@"ffd00b"];
    
    //constraints
    [settingPageTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 10;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? 4: 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserProfileCell * userProfileCell = [tableView dequeueReusableCellWithIdentifier:UserProfileCellIdefity];
    UITableViewCell * settingCell = [tableView dequeueReusableCellWithIdentifier:SettingCellIdefity];
    UITableViewCell * loginOutCell = [tableView dequeueReusableCellWithIdentifier:LoginOutIdefity];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
   
    if (section == 0) {
        if (!userProfileCell ) {
            userProfileCell = [[NSUserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserProfileCellIdefity];
            userProfileCell.tag = 125;
        }
        NSMutableDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        [userProfileCell.userIcon setDDImageWithURLString:userInfo[@"userIcon"] placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
        if (userInfo[@"userName"]) {
            userProfileCell.nickName = userInfo[@"userName"];
        }else{
            userProfileCell.nickName = @"";
        }
        
        if (userInfo[@"desc"]) {
            userProfileCell.number = userInfo[@"desc"];
        }else{
            userProfileCell.number = @"您还没有描述哦";
        }
        
        return userProfileCell;
    }else if (section == 1){
        
        if (!settingCell) {
            settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingCellIdefity];
            settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * valueLabel = [[UILabel alloc] init];
            valueLabel.textAlignment = NSTextAlignmentRight;
            valueLabel.textColor = [UIColor hexColorFloat:@"181818"];
            [settingCell.contentView addSubview:valueLabel];
            
            valueLabel.tag = 100;
            valueLabel.hidden = YES;
            UISwitch * not = [[UISwitch alloc] init];
            not.onTintColor = [UIColor hexColorFloat:@"ffd00b"];
            not.on = YES;
            not.hidden = YES;
            not.tag = 101;
            [settingCell addSubview:not];
            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //constraints
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(settingCell.contentView.mas_right).with.offset(-15);
                make.centerY.equalTo(settingCell.mas_centerY);
            }];
        
            [not mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(settingCell.contentView.mas_right).with.offset(-15);
                make.centerY.equalTo(settingCell.mas_centerY);
            }];
            
        }
        UILabel * valueLabel = (UILabel *)[settingCell viewWithTag:100];
        UISwitch * not = (UISwitch *)[settingCell viewWithTag:101];
        if (row == 0) {
            settingCell.accessoryType = UITableViewCellAccessoryNone;
            index = indexPath;
            settingCell.textLabel.text = @"清理缓存";
//            LocalizedStr(@"prompt_clearCache");
            valueLabel.hidden = NO;
            valueLabel.text = [Memory getCacheSize];
            
        }else if (row == 1){
            settingCell.textLabel.text = @"消息通知";
            //LocalizedStr(@"prompt_newMessageNotifation");
            settingCell.accessoryType = UITableViewCellAccessoryNone;
            
            not.hidden = NO;
            
        } else if (row == 2) {
            //            settingCell.textLabel.text = @"关于我们";
            //             LocalizedStr(@"prompt_rating");
            
            settingCell.textLabel.text = @"修改密码";
            
        } else if (row == 3){
            
            settingCell.textLabel.text = @"关于我们";
            //            settingCell.textLabel.text = @"修改密码";
            
        }

        return settingCell;
        
    }else if (section == 2){
        if (!loginOutCell) {
            loginOutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoginOutIdefity];
            
        }
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
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        NSUserProfileViewController * userProfileInfoVC = [[NSUserProfileViewController alloc] init];
        [self.navigationController pushViewController:userProfileInfoVC animated:YES];
        
    }else if (section == 1){
        if (row == 0) {
            [Memory clearCache];
            [[NSToastManager manager] showtoast:@"已成功清理缓存"];
            UITableViewCell * settingCell = [settingPageTable cellForRowAtIndexPath:indexPath];
            UILabel * cacheSize = (UILabel *)[settingCell viewWithTag:100];
            cacheSize.text = [Memory getCacheSize];
        } else if (row == 2){
            
            NSModifyPwdViewController *modifyPwdVC = [[NSModifyPwdViewController alloc] init];
            [self.navigationController pushViewController:modifyPwdVC animated:YES];
        } else if (row == 3){
            NSAboutUsViewController *aboutUsVC = [[NSAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }else {
            
        }
    
    }else if(section == 2){
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

@end
