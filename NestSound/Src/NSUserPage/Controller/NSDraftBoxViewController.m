//
//  NSDraftBoxViewController.m
//  NestSound
//
//  Created by Apple on 16/5/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDraftBoxViewController.h"
#import "NSDraftBoxTableViewCell.h"

@interface NSDraftBoxViewController () <UITableViewDelegate, UITableViewDataSource, NSDraftBoxTableViewCellDelegate> {
    
    UITableView *_tableView;
}

@end

@implementation NSDraftBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"草稿箱";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _tableView.rowHeight = 65;
    
    [self.view addSubview:_tableView];

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 16;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"draftboxCell";
    
    NSDraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSDraftBoxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}


- (void)draftBoxTableViewCell:(NSDraftBoxTableViewCell *)draftBoxCell withSendBtn:(UIButton *)sendBtn {
    
    NSIndexPath *index = [_tableView indexPathForCell:draftBoxCell];
    NSLog(@"%@",index);
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        [tableView setEditing:NO animated:YES];
    }
}



@end






