//
//  NSDraftBoxViewController.m
//  NestSound
//
//  Created by Apple on 16/5/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDraftBoxViewController.h"

@interface NSDraftBoxViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@end

@implementation NSDraftBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];


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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.textLabel.text = @"哈哈";
    
    return cell;
}







@end






