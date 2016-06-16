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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureAppearance];
}


-(void)configureAppearance
{
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //nav
    self.title = LocalizedStr(@"me");
//    self.showBackBtn = YES;
    
    //settingPaegTable
    settingPageTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    settingPageTable.dataSource = self;
    settingPageTable.delegate = self;
    
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
    switch (section) {
        case 0:
            return 1;
           
        case 1:
            
            return 4;
           
        case 2:
            
            return 1;
            
            
        default:
            break;
    }
    return 0;
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
            
        }
        userProfileCell.iconURL = @"http://img5.duitang.com/uploads/item/201406/26/20140626154222_Niydx.thumb.700_0.jpeg";
        
        userProfileCell.nickName = @"hjay";
        userProfileCell.number = @"please call me hjay";
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
            settingCell.textLabel.text = LocalizedStr(@"prompt_newMessageNotifation");
            settingCell.accessoryType = UITableViewCellAccessoryNone;
            
            not.hidden = NO;
            
        }else if (row == 2){
            settingCell.textLabel.text = @"去评分";
//            LocalizedStr(@"prompt_rating");
        
        }else if (row == 3){
            settingCell.textLabel.text = @"用户反馈";
//            LocalizedStr(@"prompt_userFeedback");

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
            UITableViewCell * settingCell = [settingPageTable cellForRowAtIndexPath:indexPath];
            UILabel * cacheSize = (UILabel *)[settingCell viewWithTag:101];
            cacheSize.text = [Memory getCacheSize];
        }else if (row == 1){
            
            
        }else if (row == 2){
            
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1056101413"]];
            
        }else if (row == 3){
        NSUserFeedbackViewController * feedBackVC = [[NSUserFeedbackViewController alloc] initWithType:@"feedBack"];
        [self.navigationController pushViewController:feedBackVC animated:YES];
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
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:loginOutURL]) {
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:@"user"];
            [user synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }

}

@end
