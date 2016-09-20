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
#import "NSPreserveListViewController.h"
#import "NSUserMessageViewController.h"
#import "NSUserPageViewController.h"
#import "NSSettingViewController.h"
#import "NSLoginViewController.h"
#import "NSToolbarButton.h"
@interface NSUserViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSIndexPath * index;
    
    UITableView * settingPageTable;
    
    UISwitch * messageNotifictionSwitch;
    
    int page;

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
    if (!JUserID) {
        [self.tabBarController setSelectedIndex:0];
        page = 0;
    }else{
        
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureAppearance];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    ++page;
    if (JUserID == nil&&page ==1) {
      NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
    //    UIImage *image1 = [self imageByApplyingAlpha:alpha image:kDefaultImage];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!JUserID) {
        [self.tabBarController setSelectedIndex:0];
        page = 0;
    }
    /**
     *  是导航栏吧白色，解决前面透明的跳入显示不正确
     */
    
    
    
}

-(void)configureAppearance
{
    /**
     *  是导航栏吧白色，解决前面透明的跳入显示不正确
     */
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
//    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //nav
//    self.title = @"我";
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
        if (indexPath.row) {
            return 60;
        } else {
            return 70;
        }
    }
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
        return 0.01;
//    }
//    return 10;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section == 0 ? 2: 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *stringArr = @[@"灵感纪录",@"我的收藏",@"我的保全",@"个人资料",@"推荐给好友",@"设置"];
    NSArray *imageArr = @[@"2.2_inspiration",@"2.2_collection",@"2.2_preserve",@"2.2_userData",@"2.2_recommend",@"2.2_setting"];
    
    NSUserProfileCell * userProfileCell = [tableView dequeueReusableCellWithIdentifier:UserProfileCellIdefity];
    UITableViewCell * settingCell = [tableView dequeueReusableCellWithIdentifier:SettingCellIdefity];
    UITableViewCell * loginOutCell = [tableView dequeueReusableCellWithIdentifier:LoginOutIdefity];
    
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (!userProfileCell ) {
                userProfileCell = [[NSUserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserProfileCellIdefity];
                //            userProfileCell.selectionStyle = UITableViewCellSelectionStyleNone;
                userProfileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        } else {
            if (!loginOutCell) {
                loginOutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoginOutIdefity];
                NSArray *toolBarArr = @[@"歌曲",@"歌词",@"关注",@"粉丝"];
                CGFloat W = ScreenWidth / toolBarArr.count;
                
                for (int i = 0; i < toolBarArr.count; i++) {
                    
                    UILabel  *toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(W*i, 10, W, 20)];
                    
                    toolbarLabel.textColor = [UIColor hexColorFloat:@"666666"];
                    
                    toolbarLabel.textAlignment = NSTextAlignmentCenter;
                    
                    toolbarLabel.font = [UIFont systemFontOfSize:12];
                    
                    toolbarLabel.tag = 159 + i;
                    
                    NSToolbarButton *toolbarBtn = [[NSToolbarButton alloc] initWithFrame:CGRectMake(W * i, 0, W, 60)];
                    
                    //
                    [toolbarBtn setTitle:toolBarArr[i] forState:UIControlStateNormal];
                    
                    [toolbarBtn setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"e3e3e3"] renderSize:toolbarBtn.size] forState:UIControlStateSelected];
                    [toolbarBtn setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:toolbarBtn.size] forState:UIControlStateNormal];
                    
                    toolbarBtn.tag = i + 230;
                    
                    [toolbarBtn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [loginOutCell addSubview:toolbarBtn];
                    [loginOutCell addSubview:toolbarLabel];
                    if (i != 0) {
                        
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(W * i, 0, 1, 60)];
                        
                        line.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
                        
                        [loginOutCell addSubview:line];
                    }
//                    if (i==0) {
//                        //                        self.btnTag = toolbarBtn.tag;
//                        toolbarBtn.selected = YES;
//                    }
                }
            }
        }
        return loginOutCell;
        
    } else if (indexPath.section == 1){
        
        if (!settingCell) {
            settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingCellIdefity];
            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            settingCell.detailTextLabel.tag = 100;
//            UILabel * valueLabel = [[UILabel alloc] init];
//            valueLabel.textAlignment = NSTextAlignmentRight;
//            valueLabel.textColor = [UIColor hexColorFloat:@"181818"];
//            [settingCell.contentView addSubview:valueLabel];
//            
//            valueLabel.tag = 100;
//            valueLabel.hidden = YES;
//            
//            //constraints
//            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(settingCell.contentView.mas_right).with.offset(-15);
//                make.centerY.equalTo(settingCell.mas_centerY);
//            }];
        
//            [not mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(settingCell.contentView.mas_right).with.offset(-15);
//                make.centerY.equalTo(settingCell.mas_centerY);
//            }];
            
        }
//        UILabel * valueLabel = (UILabel *)[settingCell viewWithTag:100];
        settingCell.textLabel.text = stringArr[indexPath.row];
        settingCell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
//        UISwitch * not = (UISwitch *)[settingCell viewWithTag:101];
//        if (row == 0) {
//            
//            settingCell.textLabel.text = @"个人信息";
//            
//        } else if (row == 1) {
//            
//            settingCell.textLabel.text = @"保全信息";
//            
//        } else if (row == 2) {
//            settingCell.accessoryType = UITableViewCellAccessoryNone;
//            index = indexPath;
//            settingCell.textLabel.text = @"清理缓存";
////            LocalizedStr(@"prompt_clearCache");
//            valueLabel.hidden = NO;
//            valueLabel.text = [Memory getCacheSize];
//            
//        }else if (row == 3){
//            settingCell.textLabel.text = @"消息通知";
//            //LocalizedStr(@"prompt_newMessageNotifation");
//            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            
////            not.hidden = NO;
//            
//        } else if (row == 4) {
//            //            settingCell.textLabel.text = @"关于我们";
//            //             LocalizedStr(@"prompt_rating");
//            
//            settingCell.textLabel.text = @"修改密码";
//            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        } else if (row == 5){
//            
//            settingCell.textLabel.text = @"关于我们";
//            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }

        return settingCell;
        
    }else if (indexPath.section == 2){
//        if (!loginOutCell) {
//            loginOutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoginOutIdefity];
//            
//        }
//        loginOutCell.textLabel.text = @"退出登录";
////        LocalizedStr(@"prompt_loginOut");
//        loginOutCell.textLabel.textAlignment = NSTextAlignmentCenter;
//        
//        return loginOutCell;
        if (!settingCell) {
            settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingCellIdefity];
//            settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            settingCell.detailTextLabel.tag = 100;
        }
        settingCell.textLabel.text = stringArr[3 + indexPath.row];
        settingCell.imageView.image = [UIImage imageNamed:imageArr[3 + indexPath.row]];
    }
    return settingCell;
}

#pragma mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        NSUserPageViewController *userPageVC = [[NSUserPageViewController alloc] init];
        userPageVC.who = Myself;
        [self.navigationController pushViewController:userPageVC animated:YES];

        
    }else if (section == 1){
        if (row == 0) {
            NSUserMessageViewController *userMessageVC = [[NSUserMessageViewController alloc] initWithUserMessageType:EditMessageType];
            [self.navigationController pushViewController:userMessageVC animated:YES];
            
        } else if (row == 1) {
            NSPreserveListViewController *preserveListVC = [[NSPreserveListViewController alloc] init];
            [self.navigationController pushViewController:preserveListVC animated:YES];
            
        } else if (row == 2) {
            NSPreserveListViewController *preserveListVC = [[NSPreserveListViewController alloc] init];
            [self.navigationController pushViewController:preserveListVC animated:YES];
        }
//        else if (row == 3) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        } else if (row == 4){
//            
//            NSModifyPwdViewController *modifyPwdVC = [[NSModifyPwdViewController alloc] init];
//            [self.navigationController pushViewController:modifyPwdVC animated:YES];
//        } else if (row == 5){
//            NSAboutUsViewController *aboutUsVC = [[NSAboutUsViewController alloc] init];
//            [self.navigationController pushViewController:aboutUsVC animated:YES];
//        }
        
    
    }else if(section == 2){
        if (row == 0) {
            NSUserProfileViewController * userProfileInfoVC = [[NSUserProfileViewController alloc] init];
            [self.navigationController pushViewController:userProfileInfoVC animated:YES];
            
        } else if (row == 1) {
            NSPreserveListViewController *preserveListVC = [[NSPreserveListViewController alloc] init];
            [self.navigationController pushViewController:preserveListVC animated:YES];
            
        } else if (row == 2) {
            NSSettingViewController * settingVC = [[NSSettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
        //logingOut
//        [self logintOut];
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
