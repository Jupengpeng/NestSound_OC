//
//  NSUserViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserViewController.h"
#import "NSUserProfileCell.h"

@interface NSUserViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    UITableView * settingPageTable;
    
    

}
@end

static NSString * const UserProfileCellIdefity = @"NSUserProfileCell";


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
//            switch (<#expression#>) {
//                case <#constant#>:
//                    <#statements#>
//                    break;
//                    
//                default:
//                    break;
//            }
//            
//            break;
        }
            
        case 2:
        {
            
            break;
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
    
    
}

@end
