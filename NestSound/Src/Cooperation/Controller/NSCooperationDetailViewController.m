//
//  NSCooperationDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationDetailViewController.h"
#import "NSCooperateDetailMainCell.h"
#import "NSCommentListModel.h"
#import "NSCommentTableViewCell.h"
@interface NSCooperationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NSCommentTableViewCellDelegate,TTTAttributedLabelDelegate>
{
    BOOL _showMoreComment;
    
    CGFloat _lyricViewHeight;
}

@property (nonatomic,strong) UITableView *tableView;

//留言数组
@property (nonatomic,strong) NSMutableArray *msgArray;

//合作作品数组
@property (nonatomic,strong) NSMutableArray *coWorksArray;


@end

@implementation NSCooperationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupUI];
    [self processDataLogic];
    [self createData];
}

- (void)createData{
    
    for (NSInteger i= 0; i < 4; i ++) {
        NSCommentModel *commentModel = [[NSCommentModel alloc] init];

        [self.msgArray addObject:commentModel];
    }
    
    
    
}

- (void)setupUI{
    
    self.title = self.detailTitle;
    
    [self.view addSubview:self.tableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
}


- (void)processDataLogic{
    
    if (self.msgArray.count > 3) {
        _showMoreComment = YES;
    }else{
        _showMoreComment = NO;
    }
        
    
}
#pragma mark - <UITableViewDelegate,UITableDatasourse>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return _showMoreComment ? 3 :self.msgArray.count ;
        }
            break;
        default:{
            return self.coWorksArray.count;
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return _lyricViewHeight;
        }
            break;
        case 1:{
            return 50 ;
        }
            break;
        default:{
            return 50;
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 0.01;
        }
            break;
        case 1:{
            return 40;
        }
            break;
        default:{
            return 40;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return 0.01;
        }
            break;
        case 1:{
            return _showMoreComment ? 40 : 0.01;
        }
            break;
        default:{
            return 0.01;
        }
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        NSCooperateDetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCooperateDetailMainCellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell showDataWithModel:nil completion:^(CGFloat height) {
            CHLog(@"height  %f" ,height);
            
            _lyricViewHeight = height;
        }];
        
        
        return cell;
    }else if (indexPath.section == 1){
        NSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCommentTableViewCellId"];
        
        if (cell == nil) {
            
            cell = [[NSCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSCommentTableViewCellId"];
            
            cell.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentModel = self.msgArray[indexPath.row];
        cell.commentLabel.delegate = self;
        
        return cell;
    }else{
        NSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCommentTableViewCellId"];
        
        if (cell == nil) {
            
            cell = [[NSCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSCommentTableViewCellId"];
            
            cell.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentModel = self.msgArray[indexPath.row];
        cell.commentLabel.delegate = self;
        
        return cell;
    }

}

#pragma  mark - NSCommentTableViewCellDelegate


#pragma mark - ,TTTAttributedLabelDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 45 - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor hexColorFloat:@"f4f4f4"];
        [_tableView registerClass:[NSCooperateDetailMainCell class] forCellReuseIdentifier:@"NSCooperateDetailMainCellId"];
        [_tableView registerClass:[NSCommentTableViewCell class] forCellReuseIdentifier:@"NSCommentTableViewCellId"];
    }
    return _tableView;
}


- (NSMutableArray *)msgArray{
    if (!_msgArray) {
        _msgArray = [NSMutableArray array];
    }
    return _msgArray;
}

- (NSMutableArray *)coWorksArray{
    if (!_coWorksArray) {
        _coWorksArray = [NSMutableArray array];
    }
    return _coWorksArray;
}

@end
