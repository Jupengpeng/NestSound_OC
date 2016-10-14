//
//  NSPreserveApplyController.m
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#define kUrlScheme      @"wx10b95b65884a92c0" // 这个是你定义的 URL Scheme，支付宝、微信支付、银联和测试模式需要。


#import "NSPreserveApplyController.h"
#import "NSPreserveWorkInfoCell.h"
#import "NSPreserveUserCell.h"
#import "NSH5ViewController.h"
#import "NSUserMessageViewController.h"
#import "NSPreserveTypeView.h"
#import "NSPreservePayCell.h"
#import "NSMusicSayChargeModel.h"
#import "Pingpp.h"
#import "NSPreserveApplyModel.h"
@interface NSPreserveApplyController ()<UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate>
{
    UILabel *_totalPrice;
    BOOL _uerIsChosen;
    /**
     *  保全身份
     */
    UIButton *_typeButton;
    UIButton *_choosenPayButton;
    
    NSArray *_titlesArray;
    //价格数组
    NSArray *_typePriceArray;
    //type 可保全类型
    NSString *_type;
    //申请用实际保全类型
    NSString *_applyType;
    UIButton *_submitButton;
    NSPreservePersonInfoModel *_personInfoModel;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSUserMessageViewController *userMsgController;

@property (nonatomic,strong) NSPreserveTypeView *typeView;

@property (nonatomic,strong) UIButton *rmvViewBtn;

@property (nonatomic,copy) NSString *orderNo;

@property (nonatomic,strong) NSPreserveApplyModel *applyModel;


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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)setupUI{
    self.title = @"保全申请";
    self.view.backgroundColor = [UIColor hexColorFloat:@"f3f2f3"];
    
    

    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    TTTAttributedLabel *tipLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, footerView.height - 11 - 25, ScreenWidth - 20, 11)];
    //    tipLabel.font = [UIFont systemFontOfSize:11.0f];
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    [linkAttributes setValue:(__bridge id)[UIColor hexColorFloat:@"afafaf"].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:11];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    [linkAttributes setValue:(__bridge id)font forKey:(NSString *)kCTFontAttributeName];
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:@"提交申请即表示认同《音巢保全免责声明》" attributes:linkAttributes];
    tipLabel.attributedText = attributedStr;
    [linkAttributes setValue:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    tipLabel.linkAttributes = linkAttributes;
    
    
    NSRange linkRange = [tipLabel.text rangeOfString:@"《音巢保全免责声明》"];
    tipLabel.textColor = [UIColor hexColorFloat:@"afafaf"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    tipLabel.delegate = self;
    
    [tipLabel addLinkToURL:nil withRange:linkRange];
    [footerView addSubview:tipLabel];
    
    
    
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.frame = CGRectMake(10, footerView.height - 96 , ScreenWidth -20, 45);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn setTitle:@"提交申请" forState:UIControlStateNormal];
        btn.clipsToBounds = YES;
        [btn setTitleColor:[UIColor hexColorFloat:@"323232"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 45/2.0f;
        btn.backgroundColor = [UIColor hexColorFloat:kAppBaseYellowValue];
    } action:^(UIButton *btn) {
        [self fechOrderNo];
        btn.enabled = NO;
    }];
    [footerView addSubview:_submitButton];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = footerView;
    
    

    
    
    
    
    [self fetchPreserveInfoData];
    
}

#pragma mark HTTP request method


- (void)feedbackPaySuccessWithCode:(NSString *)statusStr{
    self.requestType = NO;
    self.requestParams = @{@"orderNo":self.orderNo,
                           @"status":statusStr,
                           @"token":LoginToken};
    
    
    self.requestURL = paiedSuccessUrl;
}


- (void)fetchPreserveInfoData{
    
    self.requestType = NO;
    
    self.requestParams = @{@"id":[NSString stringWithFormat:@"%ld",self.itemUid],
                           @"sort_id":self.sortId,
                           @"uid":JUserID,
                           @"token":LoginToken};
    
    self.requestURL = getPreserveInfoUrl;
}

- (void)fechOrderNo{
    
    self.requestType = NO;
    self.requestParams = @{@"uid":JUserID,
                           @"itemid":[NSString stringWithFormat:@"%ld",self.itemUid],
                           @"type":self.sortId,
                           @"cType":_applyType,
                           @"cUsername":_personInfoModel.cUserName,
                           @"cCardId":_personInfoModel.cCardId,
                           @"cPhone":_personInfoModel.cPhone,
                           @"token":LoginToken};
    
    self.requestURL = getOrderNoUrl;
}


- (void)fetchGoodCharge{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%d", a];
    NSDictionary* dict = @{
                           //                           @"channel" : self.channel,
                           @"orderNo":self.orderNo,
                           @"token":LoginToken};
    self.requestType = NO;
    self.requestParams = dict;
    self.requestURL = getGoodChargeUrl;
}


/**
 *  overwrite data method
 */

- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        
    }else{
        if ([operation.urlTag isEqualToString:paiedSuccessUrl]) {
            if (parserObject.code == 200 ){
                CHLog(@"支付回调recordNo ：%@",self.orderNo);
                //                [[NSToastManager manager] showtoast:[NSString stringWithFormat:@"支付订单%@成功回调成功",self.orderNo]];
                _submitButton.enabled = YES;
                
            }
            
        }else if ([operation.urlTag isEqualToString:getGoodChargeUrl]){
            NSMusicSayChargeModel *chargeModel = (NSMusicSayChargeModel *)parserObject;
            [Pingpp createPayment:chargeModel.chargeDict
                   viewController:self
                     appURLScheme:kUrlScheme
                   withCompletion:^(NSString *result, PingppError *error) {
                       CHLog(@"completion block: %@", result);
                       
                       if (error == nil) {
                           NSLog(@"PingppError is nil");
                           /**
                            *  支付成功，回调
                            */
                           [self feedbackPaySuccessWithCode:@"8"];
                           [[NSToastManager manager] showtoast:@"支付成功"];
                           
                       } else {
                           CHLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                           [self feedbackPaySuccessWithCode:@"4"];
                           
                           [[NSToastManager manager] showtoast:[error getMsg]];
                       }
                       //                       [[NSToastManager manager] showtoast:result];
                   }];
            
        }else if ([operation.urlTag isEqualToString:getOrderNoUrl]){
            NSBaseModel *baseModel = (NSBaseModel *)parserObject;
            self.orderNo = [baseModel.data objectForKey:@"mp3URL"];
            [[NSToastManager manager] showtoast:[NSString stringWithFormat:@"生成订单号%@",self.orderNo]];
            
            [self fetchGoodCharge];
        }else if ([operation.urlTag isEqualToString:getPreserveInfoUrl]){
            
            self.applyModel = (NSPreserveApplyModel *)parserObject;
            _typePriceArray = [NSArray arrayWithArray:self.applyModel.orderPrice];
            if (self.applyModel.personInfo.cUserName.length) {
                _uerIsChosen = YES;
                
            }else{
                _uerIsChosen = NO;
            }
            
            NSArray *titles = [NSArray array];
            _type = self.applyModel.productInfo.type;
            if([_type isEqualToString:@"1"]){
                titles = @[@"曲作者"];
                _applyType = @"1";
            }else if ([_type isEqualToString:@"2"]){
                titles = @[@"词作者"];
                _applyType = @"2";
            }else if ([_type isEqualToString:@"3"]){
                titles = @[@"词作者,曲作者",@"词作者",@"曲作者"];
                _applyType = @"3";
            }
            _titlesArray = [titles mutableCopy];
            [self.view addSubview:self.typeView];
            [self.view insertSubview:self.rmvViewBtn belowSubview:self.typeView];
            
            _personInfoModel = self.applyModel.personInfo;
            [self.tableView reloadData];
        }
        
        
    }
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
            if (_typePriceArray.count) {
                _totalPrice.text = [_typePriceArray objectAtIndex:[_applyType intValue] -1];
                
            }
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
        
        if ([_type isEqualToString:@"3"]) {
            UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_more"]];
            arrow.x = ScreenWidth - arrow.width - 10;
            arrow.centerY = 20;
            [footerView addSubview:arrow];
            
        }
        _typeButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(ScreenWidth - 125, 0, 100, 40);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight ;
            [btn setTitleColor:[UIColor hexColorFloat:@"323232"] forState:UIControlStateNormal ];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            if (_titlesArray.count) {
                [btn setTitle:_titlesArray.firstObject forState:UIControlStateNormal];
                
            }
            if ([_type isEqualToString:@"3"]) {
                btn.enabled = YES;
            }else{
                btn.enabled = NO;
            }
        } action:^(UIButton *btn) {
            CGRect footerRect = [self.tableView convertRect:footerView.frame toView:self.view];
            self.typeView.y = footerRect.origin.y;
            [self.typeView show];
            self.rmvViewBtn.height = ScreenHeight;
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
            if (self.applyModel) {
                cell.productInfoModel = self.applyModel.productInfo;
                
            }
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
                    [addButton setImage:[UIImage imageNamed:@"addUserInfo"] forState:UIControlStateNormal];
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
                cell.personModel = _personInfoModel;
                return cell;
            }
        }
        default:
        {
            
            NSPreservePayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSPreservePayCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.chooseBlock = ^(UIButton *choosenButton){
                _choosenPayButton.selected = NO;
                _choosenPayButton = choosenButton;
                _choosenPayButton.selected = YES;
            };
            
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.typeView dismissNow];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight -1 - 64) style:UITableViewStylePlain];
        [_tableView registerClass:[NSPreserveWorkInfoCell class] forCellReuseIdentifier:@"NSPreserveWorkInfoCellId"];
        [_tableView registerClass:[NSPreserveUserCell class] forCellReuseIdentifier:@"NSPreserveUserCellId"];
        [_tableView registerClass:[NSPreservePayCell class] forCellReuseIdentifier:@"NSPreservePayCellId"];
        //        _tableView.backgroundColor=[UIColor whiteColor];
        //        _tableView.separatorColor = [UIColor hexColorFloat:@"f5f5f5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSUserMessageViewController *)userMsgController{
    
    WS(weakSelf);
    if (!_userMsgController) {
        _userMsgController = [[NSUserMessageViewController alloc] initWithUserMessageType:EditMessageType];
        _userMsgController.fillInBlock = ^(NSDictionary *personDict){
            
            _personInfoModel.cUserName = personDict[@"bq_username"];
            _personInfoModel.cCardId = personDict[@"bq_creditID"];
            _personInfoModel.cPhone = personDict[@"bq_phone"];
            _uerIsChosen = YES;
            //            _uerIsChosen = !_uerIsChosen;
            [weakSelf.tableView reloadData];
        };
    }
    return _userMsgController;
}

- (NSPreserveTypeView *)typeView{
    if (!_typeView && [_type isEqualToString:@"3"]) {
        
        _typeView = [[NSPreserveTypeView alloc] initWithFrame:CGRectMake(ScreenWidth - 125, 0, 100, 0) titlesArr:_titlesArray];
        _typeView.chooseTypeBlock = ^(NSString *typeStr,NSInteger typeId){
            
            [_typeButton setTitle:typeStr forState:UIControlStateNormal];
            self.rmvViewBtn.height = 0;
            
            _applyType = [NSString stringWithFormat:@"%d",3-typeId];
            
            
//            [[NSToastManager manager] showtoast:[NSString stringWithFormat:@"选择了%@",_applyType]];
            _totalPrice.text = [_typePriceArray objectAtIndex:[_applyType intValue] -1];
            
            
        };
    }
    return _typeView;
}

- (UIButton *)rmvViewBtn{
    if (!_rmvViewBtn) {
        _rmvViewBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame= CGRectMake(0, 0, ScreenWidth, 0);
            //            btn.backgroundColor = [UIColor lightGrayColor];
        } action:^(UIButton *btn) {
            [self.typeView disMiss];
            btn.height = 0;
        }];
    }
    return _rmvViewBtn;
}

@end
