//
//  NSPreserveApplyController.m
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveApplyController.h"
#import "NSPreserveWorkInfoCell.h"
#import "NSPreserveUserCell.h"
#import "NSH5ViewController.h"
#import "NSUserMessageViewController.h"
#import "NSPreserveTypeView.h"
@interface NSPreserveApplyController ()<UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate>
{
    UILabel *_totalPrice;
    BOOL _uerIsChosen;
    /**
     *  保全身份
     */
    UIButton *_typeButton;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSUserMessageViewController *userMsgController;

@property (nonatomic,strong) NSPreserveTypeView *typeView;

@end

@implementation NSPreserveApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    [self setupUI];
//    _uerIsChosen = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.typeView disMiss];
}

- (void)setupUI{
    self.title = @"保全申请";
    self.view.backgroundColor = [UIColor hexColorFloat:@"f3f2f3"];

    [self.view addSubview:self.tableView];
    
    TTTAttributedLabel *tipLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, ScreenHeight -64 - 11 - 25, ScreenWidth - 20, 11)];
//    tipLabel.font = [UIFont systemFontOfSize:11.0f];
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    [linkAttributes setValue:(__bridge id)[UIColor hexColorFloat:@"afafaf"].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:11];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    [linkAttributes setValue:(__bridge id)font forKey:(NSString *)kCTFontAttributeName];
    tipLabel.attributedText = [[NSAttributedString alloc] initWithString:@"提交申请即表示认同《音巢保全免责声明》" attributes:linkAttributes];
    [linkAttributes setValue:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    tipLabel.linkAttributes = linkAttributes;



    NSRange linkRange = [tipLabel.text rangeOfString:@"《音巢保全免责声明》"];
    tipLabel.textColor = [UIColor hexColorFloat:@"afafaf"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    tipLabel.delegate = self;

    [tipLabel addLinkToURL:nil withRange:linkRange];
    [self.view addSubview:tipLabel];



    
//    [tipLabel setText:@"提交申请即表示认同《音巢保全免责声明》" afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
//     {
//         
//         
//         //设定可点击文字的的大小
//         UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:11];
//         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
//         
//         if (font) {
//             
//             //设置可点击文本的大小
//             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:linkRange];
//             
//             //设置可点击文本的颜色
//             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor hexColorFloat:@"afafaf"] CGColor] range:linkRange];
//             
//             CFRelease(font);
//             
//         }
//         //         }
//         return mutableAttributedString;
//     }];
    
    
    
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
    
    [self.view addSubview:self.typeView];
    self.typeView.chooseTypeBlock = ^(NSString *typeStr,NSInteger typeId){
      
        [_typeButton setTitle:typeStr forState:UIControlStateNormal];
        
    };
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
        return 50;
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
            
            
            if (_uerIsChosen) {
                UIButton *editbutton= [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
                    btn.frame = CGRectMake(ScreenWidth - 50, 0, 50, 40);
                    [btn setTitleColor:[UIColor hexColorFloat:@"323232"] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
                    [btn setTitle:@"编辑" forState:UIControlStateNormal];
                } action:^(UIButton *btn) {
                    [self.navigationController pushViewController:self.userMsgController animated:YES];

                }];
                [headerView addSubview:editbutton];
            }

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
        footerView.height = 50.0f;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, 40)];
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 14)];
        titleLabel.text = @"保全身份";
        titleLabel.textColor = [UIColor hexColorFloat:@"323232"];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [contentView addSubview:titleLabel];
        [footerView addSubview:contentView];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_more"]];
        arrow.x = ScreenWidth - arrow.width - 10;
        arrow.centerY = 20;
        [footerView addSubview:arrow];
        
        _typeButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(ScreenWidth - 125, 0, 100, 40);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight ;
            [btn setTitleColor:[UIColor hexColorFloat:@"323232"] forState:UIControlStateNormal ];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [btn setTitle:@"词作者,曲作者" forState:UIControlStateNormal];
        } action:^(UIButton *btn) {
            CGRect footerRect = [self.tableView convertRect:footerView.frame toView:self.view];
            self.typeView.y = footerRect.origin.y;
            [self.typeView show];
        }];
        [footerView addSubview:_typeButton];

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
        if (!_uerIsChosen) {
            return 50;
        }else{
            return 140;
        }
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
            cell.preserveDate.hidden = YES;
            cell.preserveCode.hidden = YES;
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
                    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 20)];
                    [addButton setImage:[UIImage createImageWithColor:[UIColor hexColorFloat:kAppBaseYellowValue]] forState:UIControlStateNormal];
                    [addButton setTitle:@"添加个人信息" forState:UIControlStateNormal];
                    [addButton setImage:[UIImage imageNamed:@"2.0_coach_round_selected "] forState:UIControlStateNormal];
                    addButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
                    [addButton setTitleColor:[UIColor hexColorFloat:@"4a4a4a"] forState:UIControlStateNormal];
                    addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
                    addButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
                    addButton.userInteractionEnabled = NO;
                    [cell addSubview:addButton];
                }
 
                return cell;
            }else{
                NSPreserveUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSPreserveUserCellId"];cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setupData];
                return cell;
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
                [self.navigationController pushViewController:self.userMsgController animated:YES];

            }else{
                return;
            }
            
        }
    }

}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if (url.absoluteString.length) {
        NSH5ViewController *h5Controller = [[NSH5ViewController alloc] init];
        h5Controller.h5Url = url.absoluteString;
        [self.navigationController pushViewController:h5Controller animated:YES];
        
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
        [_tableView registerClass:[NSPreserveUserCell class] forCellReuseIdentifier:@"NSPreserveUserCellId"];
//        _tableView.backgroundColor=[UIColor whiteColor];
//        _tableView.separatorColor = [UIColor hexColorFloat:@"f5f5f5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSUserMessageViewController *)userMsgController{
    
    WS(weakSelf);
    if (!_userMsgController) {
        _userMsgController = [[NSUserMessageViewController alloc] initWithUserMessageType:EditMessageType];
        _userMsgController.fillInBlock = ^(id object){
//            _uerIsChosen = YES;
            _uerIsChosen = !_uerIsChosen;
            [weakSelf.tableView reloadData];
        };
    }
    return _userMsgController;
}

- (NSPreserveTypeView *)typeView{
    if (!_typeView) {
        NSArray *titles = @[@"词作者,曲作者",@"词作者",@"曲作者"];
        _typeView = [[NSPreserveTypeView alloc] initWithFrame:CGRectMake(ScreenWidth - 125, 0, 100, 0) titlesArr:titles];
        
    }
    return _typeView;
}

@end
