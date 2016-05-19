//
//  NSDraftBoxViewController.m
//  NestSound
//
//  Created by Apple on 16/5/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDraftBoxViewController.h"
#import "NSDraftBoxTableViewCell.h"

@interface NSDraftBoxViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@end

@implementation NSDraftBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    self.title = @"草稿箱";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_tableView];

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 16;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    NSDraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSDraftBoxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.textLabel.text = @"草稿箱";
    
    return cell;
}







@end






