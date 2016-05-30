//
//  NSSearchMusicTableView.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSearchMusicTableView.h"
#import "NSNewMusicTableViewCell.h"

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
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        
        NSLog(@"点击了歌曲的第%zd个cell",indexPath.row);
    } else if (tableView.tag == 2) {
        
        NSLog(@"点击了歌词的第%zd个cell",indexPath.row);
    }
}

@end






