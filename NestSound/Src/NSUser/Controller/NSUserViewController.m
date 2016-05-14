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

@interface NSUserViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
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
    settingPageTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    settingPageTable.dataSource = self;
    settingPageTable.delegate = self;
    
    [self.view addSubview:settingPageTable];
    
    messageNotifictionSwitch = [[UISwitch alloc] init];
    messageNotifictionSwitch.tintColor = [UIColor hexColorFloat:@"ffd00b"];
    
    
}

#pragma mark TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
            
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.section) {
        case 0:
        {
            NSUserProfileCell * userProfileCell = [tableView dequeueReusableCellWithIdentifier:UserProfileCellIdefity];
            
            return userProfileCell;
        
        }
            
        case 1:
        {
            UITableViewCell * settingCell = [tableView dequeueReusableCellWithIdentifier:SettingCellIdefity];
            
            switch (indexPath.row) {
                case 0:
                    settingCell.textLabel.text = LocalizedStr(@"");
                    break;
                case 1:
                {
                    settingCell.textLabel.text = LocalizedStr(@"");
                    [settingCell.contentView addSubview:messageNotifictionSwitch];
                    messageNotifictionSwitch.on = YES;
                    break;
                }
                case 2:
                    settingCell.textLabel.text = LocalizedStr(@"");
                    break;
                case 3:
                    settingCell.textLabel.text = LocalizedStr(@"");
                    break;
                    
                default:
                    break;
            }
            return settingCell;
            break;
        }
            
        case 2:
        {
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:LoginOutIdefity];
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = LocalizedStr(@"");
            
            return cell;
        }
            
            
        default:
            break;
    }
    
//    return cell;
    return nil;
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
            
        }else if (row == 1){
        
        }else if (row == 2){
        
        }else if (row == 3){
        
        }
    
    }else{
        
    }
    
}

@end
