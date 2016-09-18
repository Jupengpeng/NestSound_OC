//
//  NSPreserveApplyController.m
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveApplyController.h"
#import "NSPreserveWorkInfoCell.h"
@interface NSPreserveApplyController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_totalPrice;
    BOOL _uerIsChosen;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NSPreserveApplyController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"保全申请";
    self.view.backgroundColor = [UIColor hexColorFloat:@"f3f2f3"];

    [self.view addSubview:self.tableView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ScreenHeight -64 - 11 - 25, ScreenWidth - 20, 11)];
    tipLabel.font = [UIFont systemFontOfSize:11.0f];
    tipLabel.text = @"提交申请即表示认同《音巢保全免责声明》";
    tipLabel.textColor = [UIColor hexColorFloat:@"afafaf"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.frame = CGRectMake(10, ScreenHeight - 96 - 64, ScreenWidth -20, 45);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn setTitle:@"提交申请" forState:UIControlStateNormal];
        btn.clipsToBounds = YES;
        [btn setTitleColor:[UIColor hexColorFloat:@"323232"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 45/2.0f;
        btn.backgroundColor = [UIColor hexColorFloat:kAppBaseYellowValue];
    } action:^(UIButton *btn) {
        
    }];
    [self.view addSubview:submitButton];
    
}

#pragma mark -  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
            
        default:
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }else if(section == 2){
        return 72;
    }else{
        return 0;
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if(section == 1){
        return 10;
    }else{
        return 0;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    switch (section) {
        case 1:
        {
            headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 12)];
            titleLabel.textColor = [UIColor hexColorFloat:@"afafaf"];
            titleLabel.font = [UIFont systemFontOfSize:13.0f];
            titleLabel.text = @"保全用户信息";
            [headerView addSubview:titleLabel];
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 39, ScreenWidth - 10, 0.5)];
            line.backgroundColor = [UIColor hexColorFloat:@"f3f2f3"];
            [headerView addSubview:line];

        }
            break;
        case 2:
        {
            headerView.frame = CGRectMake(0, 0, ScreenWidth, 72);
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 12)];
            titleLabel.textColor = [UIColor hexColorFloat:@"afafaf"];
            titleLabel.font = [UIFont systemFontOfSize:13.0f];
            titleLabel.text = @"支付信息";
            [headerView addSubview:titleLabel];
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 39, ScreenWidth - 10, 1)];
            line.backgroundColor = [UIColor hexColorFloat:@"f3f2f3"];
            [headerView addSubview:line];
            
            
            UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 50, 14)];
            tagLabel.font = [UIFont systemFontOfSize:14.0f];
            tagLabel.textColor = [UIColor hexColorFloat:@"646464"];
            tagLabel.text = @"总价：";
            [headerView addSubview:tagLabel];
            
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 48, ScreenWidth - 55, 15.0f)];
            priceLabel.textColor = [UIColor hexColorFloat:@"fc4c52"];
            priceLabel.font = [UIFont systemFontOfSize:15.0f];
            _totalPrice = priceLabel;
            _totalPrice.text = @"￥3.00";
            [headerView addSubview:priceLabel];
        }
            break;
        default:
        {
        }
            break;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
    if (section == 0) {
        footerView.height = 10.0f;
    }else if(section == 1){
        footerView.height = 10.0f;
    }else{
    }
    
    footerView.backgroundColor = [UIColor hexColorFloat:@"f3f2f3"];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }
    else if (indexPath.section == 1){
        return 50;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            NSPreserveWorkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSPreserveWorkInfoCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setupData];
            return cell;
        }
        case 1:
        {
            if (!_uerIsChosen) {
                static NSString *cellId = @"AddCellId";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 20)];
                [addButton setImage:[UIImage createImageWithColor:[UIColor hexColorFloat:kAppBaseYellowValue]] forState:UIControlStateNormal];
                [addButton setTitle:@"添加个人信息" forState:UIControlStateNormal];
                addButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
                [addButton setTitleColor:[UIColor hexColorFloat:@"4a4a4a"] forState:UIControlStateNormal];
                addButton.userInteractionEnabled = NO;
                [cell addSubview:addButton];
                return cell;
            }else{
                
            }
        }
        default:
        {
            static NSString *cellId = @"PayCellId";

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            return cell;
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (!_uerIsChosen) {
                
            }else{
                return;
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - lazy init 

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight -1) style:UITableViewStylePlain];
        [_tableView registerClass:[NSPreserveWorkInfoCell class] forCellReuseIdentifier:@"NSPreserveWorkInfoCellId"];
//        _tableView.backgroundColor=[UIColor whiteColor];
//        _tableView.separatorColor = [UIColor hexColorFloat:@"f5f5f5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
