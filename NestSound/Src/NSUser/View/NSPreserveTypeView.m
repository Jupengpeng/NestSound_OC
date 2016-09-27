//
//  NSPreserveTypeView.m
//  NestSound
//
//  Created by yintao on 16/9/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveTypeView.h"

@interface NSPreserveTypeView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titlesaArray;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NSPreserveTypeView

- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr{
    self = [super initWithFrame:frame];
    if (self) {
        _titlesaArray = titlesArr;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.bounces = NO;
        [self addSubview:self.tableView];
        
//         阴影的透明度
        self.layer.shadowOpacity = 0.5f;
        
//        阴影的圆角
        
        self.layer.shadowRadius = 2.f;
        
//        阴影偏移量
        
        self.layer.shadowOffset = CGSizeMake(0,4);
//        self.clipsToBounds = YES;

    }
    return self;
}

- (void)show{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.height = 40 *_titlesaArray.count;
        self.tableView.height = 40 *_titlesaArray.count;
    }];
    
}

- (void)disMiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.height = 0;
        self.tableView.height = 0;

    }];
}

- (void)dismissNow{
    self.height = 0;
    self.tableView.height = 0;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titlesaArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *content;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        content = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, cell.width, cell.height)];
        content.textColor = [UIColor hexColorFloat:@"323232"];
        content.font = [UIFont systemFontOfSize:14.0f];
        [cell addSubview:content];
    }

    content.text = _titlesaArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.chooseTypeBlock) {
        self.chooseTypeBlock(_titlesaArray[indexPath.row],indexPath.row);
        
    }
    [self disMiss];
}

@end
