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
#import "NSUserPageViewController.h"
#import "NSSettingViewController.h"
#import "NSLoginViewController.h"
#import "NSFansViewController.h"
#import "NSNewMusicViewController.h"
#import "NSInspirationListViewController.h"
#import "NSCollectionListViewController.h"
#import "NSToolbarButton.h"
#import "NSUserDataModel.h"
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
    
    NSString *userDataUrl;
    
    NSString *newFansDataUrl;
    
    UserModel *_userModel;
    
    UIView *redTipView;

}
@property (nonatomic,strong) NSArray *toolBarArr;
@property (nonatomic,strong) NSMutableArray *numsArr;
@end

static NSString * const UserProfileCellIdefity = @"NSUserProfileCell";
static NSString * const SettingCellIdefity = @"SettingCell";
static NSString * const toolBarCellIdefity = @"toolBarCell";

@implementation NSUserViewController
- (NSArray *)toolBarArr {
    if (!_toolBarArr) {
        self.toolBarArr = [NSArray array];
    }
    return _toolBarArr;
}
- (NSMutableArray *)numsArr {
    if (!_numsArr) {
        self.numsArr = [NSMutableArray arrayWithCapacity:4];
    }
    return _numsArr;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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
    
//    [self fetchUserData];
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
    } else {
        
        [self fetchUserData];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!JUserID) {
        [self.tabBarController setSelectedIndex:0];
        page = 0;
    }
}
-(void)fetchUserData
{
    self.requestType = YES;
    if (JUserID) {
        NSDictionary * dic = @{@"uid":JUserID,@"token":LoginToken};
        NSString * str = [NSTool encrytWithDic:dic];
        userDataUrl = [userCenterURL stringByAppendingString:str];
        self.requestURL = userDataUrl;
    }
    
}
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:userDataUrl]) {
                NSUserDataModel * userData = (NSUserDataModel *)parserObject;
                
                _userModel = userData.userDataModel.userModel;
                
                [self.numsArr addObject:@(userData.userOtherModel.workNum)];
                [self.numsArr addObject:@(userData.userOtherModel.lyricsNum)];
                [self.numsArr addObject:@(userData.userOtherModel.focusNum)];
                [self.numsArr addObject:@(userData.userOtherModel.fansNum)];
                if (userData.userOtherModel.pushFocusNum) {
                    redTipView.hidden = NO;
                }
                [settingPageTable reloadData];
            }
            
        } else {
            
        }
    }
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
        return 1;
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
    UITableViewCell * toolBarCell = [tableView dequeueReusableCellWithIdentifier:toolBarCellIdefity];
    
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (!userProfileCell ) {
                userProfileCell = [[NSUserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserProfileCellIdefity];
                //            userProfileCell.selectionStyle = UITableViewCellSelectionStyleNone;
                userProfileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            userProfileCell.userModel = _userModel;
//
            return userProfileCell;
        } else {
            
            if (!toolBarCell) {
                toolBarCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:toolBarCellIdefity];
                toolBarCell.tag = 166;
            }
            self.toolBarArr = @[@"歌曲",@"歌词",@"关注",@"粉丝"];
            CGFloat W = ScreenWidth / _toolBarArr.count;
            
            for (int i = 0; i < _toolBarArr.count; i++) {
                
                UILabel  *toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(W*i, 10, W, 20)];
                
                toolbarLabel.textColor = [UIColor hexColorFloat:@"666666"];
                
                toolbarLabel.textAlignment = NSTextAlignmentCenter;
                
                toolbarLabel.font = [UIFont systemFontOfSize:12];
                if (self.numsArr.count) {
                    toolbarLabel.text = [NSString stringWithFormat:@"%@",self.numsArr[i]];
                }
                if (i == 2) {
                    redTipView = [[UIView alloc] initWithFrame:CGRectMake(4 * W-10, 10, 6, 6)];
                    
                    redTipView.backgroundColor = [UIColor redColor];
                    
                    redTipView.layer.cornerRadius = 3;
                    
                    redTipView.hidden = YES;
                    
                }
                NSToolbarButton *toolbarBtn = [[NSToolbarButton alloc] initWithFrame:CGRectMake(W * i, 0, W, 60)];
                
                toolbarBtn.tag = 230 + i;
                
                [toolbarBtn setTitle:_toolBarArr[i] forState:UIControlStateNormal];
                
                [toolbarBtn setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"e3e3e3"] renderSize:toolbarBtn.size] forState:UIControlStateSelected];
                [toolbarBtn setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:toolbarBtn.size] forState:UIControlStateNormal];
                
                [toolbarBtn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [toolBarCell addSubview:toolbarBtn];
                [toolBarCell addSubview:toolbarLabel];
                [toolBarCell addSubview:redTipView];
                if (i != 0) {
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(W * i, 0, 1, 60)];
                    
                    line.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
                    
                    [toolBarCell addSubview:line];
                }
                
            }
        }
        return toolBarCell;
        
    } else if (indexPath.section == 1){
        
        if (!settingCell) {
            settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingCellIdefity];
            settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            
        }
        settingCell.textLabel.text = stringArr[indexPath.row];
        settingCell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];

//        }

        return settingCell;
        
    }else if (indexPath.section == 2){

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
            NSInspirationListViewController *inspirationListVC = [[NSInspirationListViewController alloc] init];
            [self.navigationController pushViewController:inspirationListVC animated:YES];
            
        } else if (row == 1) {
            NSCollectionListViewController *collectionListVC = [[NSCollectionListViewController alloc] init];
            [self.navigationController pushViewController:collectionListVC animated:YES];
            
        } else if (row == 2) {
            NSPreserveListViewController *preserveListVC = [[NSPreserveListViewController alloc] init];
            [self.navigationController pushViewController:preserveListVC animated:YES];
        }
        
    
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
  
    }
    
}
- (void)toolbarBtnClick:(UIButton *)toolbarBtn {
//    UIButton *lastButton = [backgoundView viewWithTag:self.btnTag];
//    lastButton.selected = NO;
//    toolbarBtn.selected = YES;
    switch (toolbarBtn.tag - 230) {
            
        case 0: {
            NSNewMusicViewController * hotMusicVC = [[NSNewMusicViewController alloc] initWithType:@"music" andIsLyric:NO];
            [self.navigationController pushViewController:hotMusicVC animated:YES];
            
            break;
        }
        case 1: {
            NSNewMusicViewController * hotMusicVC = [[NSNewMusicViewController alloc] initWithType:@"lyric" andIsLyric:YES];
            [self.navigationController pushViewController:hotMusicVC animated:YES];
            break;
        }
        case 2: {
            NSFansViewController * myFocusVC = [[NSFansViewController alloc] initWithUserID:JUserID _isFans:NO isWho:Myself];
            [self.navigationController pushViewController:myFocusVC animated:YES];
            
            break;
        }
        case 3: {
            NSFansViewController * myFansVC = [[NSFansViewController alloc] initWithUserID:JUserID _isFans:YES isWho:Myself];
            [self.navigationController pushViewController:myFansVC animated:YES];
            redTipView.hidden = YES;
            break;
        }
        default:
            
            
            break;
    }
}



@end
