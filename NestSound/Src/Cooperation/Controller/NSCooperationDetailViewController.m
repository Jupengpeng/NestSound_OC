//
//  NSCooperationDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationDetailViewController.h"
#import "NSCooperateDetailMainCell.h"
@interface NSCooperationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _showMoreComment;
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
            return self.msgArray.count >= 3 ? 3 :self.msgArray.count ;
        }
            break;
        default:{
            return self.coWorksArray.count;
        }
            break;
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSCooperateDetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCooperateDetailMainCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell showDataWithModel:nil completion:^(CGFloat height) {
        
    }];
        
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45) style:UITableViewStyleGrouped];
        [_tableView registerClass:[NSCooperateDetailMainCell class] forCellReuseIdentifier:@"NSCooperateDetailMainCellId"];
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
