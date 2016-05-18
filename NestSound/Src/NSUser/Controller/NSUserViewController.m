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
static NSString * const userSettingCellIdefity = @"settingCell";

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
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
   
    if (section == 0) {
         NSUserProfileCell * userProfileCell = [tableView dequeueReusableCellWithIdentifier:UserProfileCellIdefity];
        
        return userProfileCell;
    }else if (section == 1){
        
        if (row == 0) {
            
        }else if (row == 1){
        
        }else if (row == 2){
        
        }else if (row == 3){
        
        }
        
        
        
    }else if (section == 2){
        
    }
    return nil;
}

#pragma mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
