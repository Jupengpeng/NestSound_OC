//
//  NSSearchMusicTableView.h
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSSearchMusicTableView;

@protocol NSSearchMusicTableViewDelegate <NSObject>

- (void)searchMusicTableView:(NSSearchMusicTableView *)tableView withItemId:(long)itemID;

- (void)searchLyricTableView:(NSSearchMusicTableView *)tableView withItemId:(long)itemID;

@end

@interface NSSearchMusicTableView : UITableView

@property (nonatomic,strong) NSMutableArray * DataAry;

@property (nonatomic, weak) id<NSSearchMusicTableViewDelegate> delegate1;

@end
