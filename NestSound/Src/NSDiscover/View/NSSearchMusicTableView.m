//
//  NSSearchMusicTableView.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSearchMusicTableView.h"
#import "NSNewMusicTableViewCell.h"
#import "NSMyMusicModel.h"

@interface NSSearchMusicTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation NSSearchMusicTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.rowHeight = 80;
    }
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _DataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
    }
    cell.myMusicModel = _DataAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMyMusicModel *model = _DataAry[indexPath.row];
    if (tableView.tag == 1) {
//        - (void)searchMusicTableView:(NSSearchMusicTableView *)tableView;
//        
//        - (void)searchLyricTableView:(NSSearchMusicTableView *)tableView;
        
        NSMyMusicModel *model = _DataAry[indexPath.row];
        
        if ([self.delegate1 respondsToSelector:@selector(searchMusicTableView:withItemId:)]) {
            
            [self.delegate1 searchMusicTableView:self withItemId:model.itemId];
        }
        
    } else if (tableView.tag == 2) {
        
        if ([self.delegate1 respondsToSelector:@selector(searchLyricTableView:withItemId:)]) {
            
            [self.delegate1 searchLyricTableView:self withItemId:model.itemId];
        }
        
    }
}

@end






