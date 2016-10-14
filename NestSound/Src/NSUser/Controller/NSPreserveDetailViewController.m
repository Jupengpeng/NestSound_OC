//
//  NSPreserveDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveDetailViewController.h"
#import "NSPreserveWorkInfoCell.h"
#import "NSPreserveDetailListModel.h"
@interface NSPreserveDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate>
{
    NSString *preserveId;
    long sortId;
    UITableView *preserveDetailTab;
    NSProductModel * productModel;
    NSPersonModel  * personModel;
    NSPreserveResultModel *resultModel;
}
@property (nonatomic, strong) UIImageView *oneImageView;
@end
static NSString *const preserveDetailCellIdentifier = @"preserveDetailCellIdentifier";
@implementation NSPreserveDetailViewController
-(instancetype)initWithPreserveID:(NSString *)preserveID_ sortID:(long)sortID_
{
    if (self = [super init]) {
        preserveId = preserveID_;
        sortId     = sortID_;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPreserveDetailUI];
    [self fetchPreserveDetailData];
}
- (void)fetchPreserveDetailData {
    
    self.requestType = NO;
    
    self.requestParams = @{@"token":LoginToken,@"id":preserveId};
    
    self.requestURL = preserveDetailUrl;
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        NSPreserveDetailListModel *preserveDetailModel = (NSPreserveDetailListModel *)parserObject;
        productModel = preserveDetailModel.productList.productModel;
        personModel = preserveDetailModel.personList.personModel;
        resultModel = preserveDetailModel.preserveResultModel;
        [preserveDetailTab reloadData];
    }
}
- (void)setupPreserveDetailUI {
    
    self.title = @"保全申请";
    
    preserveDetailTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    
    preserveDetailTab.dataSource = self;
    
    preserveDetailTab.delegate = self;
    
    preserveDetailTab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    preserveDetailTab.backgroundColor = KBackgroundColor;
    
    [self.view addSubview:preserveDetailTab];
    
    
    _oneImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    _oneImageView.hidden = YES;
    
    _oneImageView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_oneImageView];
}
- (void)handlePreserveStatus:(UIButton *)sender {
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:@"http://pic.yinchao.cn/dongliyaogun001.png"];
    photo.srcImageView = _oneImageView;
    [photos addObject:photo];
    browser.photos = photos;
    browser.currentPhotoIndex = sender.tag;
    [browser show];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles = @[@"保全用户信息",@"保全人姓名",@"手机号",@"证件号码",@"保全身份"];
//    NSArray *titles2 = @[@"保全人姓名",@"手机号",@"证件号码",@"保全身份"];
    
    UITableViewCell * userMessageCell = [tableView dequeueReusableCellWithIdentifier:preserveDetailCellIdentifier];
    UITableViewCell * preserveStatusCell = [[UITableViewCell alloc] init];
    NSPreserveWorkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSPreserveWorkInfoCellId"];
    if (indexPath.section == 1) {
        if (!cell) {
             cell = [[NSPreserveWorkInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSPreserveWorkInfoCellId"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupDataWithProductModel:productModel];
        return cell;
    } else  if (indexPath.section == 0){
        if (!userMessageCell) {
            userMessageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:preserveDetailCellIdentifier];
            userMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel * leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:15];
        [userMessageCell.contentView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = [UIColor lightGrayColor];
        [userMessageCell.contentView addSubview:rightLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(userMessageCell.contentView.mas_left).offset(15);
            
            make.width.mas_equalTo(100);
            
            make.centerY.equalTo(userMessageCell.mas_centerY);
        }];
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(leftLabel.mas_left).offset(90);
            
            make.right.equalTo(userMessageCell.contentView.mas_right).offset(-15);
            
            make.centerY.equalTo(userMessageCell.mas_centerY);
            
        }];
        if (!indexPath.section) {
            switch (indexPath.row) {
                case 1:
                    rightLabel.text = personModel.userName;
                    break;
                case 2:
                    rightLabel.text = personModel.userPhone;
                    break;
                case 3:
                    rightLabel.text = personModel.userIDNo;
                    break;
                case 4:
                {
                    switch (personModel.userIdentity) {
                        case 1:
                            rightLabel.text = @"作曲者";
                            break;
                        case 2:
                            rightLabel.text = @"作词者";
                            break;
                        case 3:
                            rightLabel.text = @"作曲者,作词者";
                            break;
                        default:
                            break;
                    }
                }
                default:
                    break;
            }
        }
        if (!indexPath.section) {
            leftLabel.text = titles[indexPath.row];
            
        } else {
            leftLabel.text = titles[indexPath.row];
            
        }
        if (!indexPath.section&&!indexPath.row) {
            leftLabel.textColor = [UIColor lightGrayColor];
            rightLabel.hidden = YES;
        } else {
            leftLabel.textColor = [UIColor hexColorFloat:@"181818"];
            rightLabel.hidden = NO;
        }
        return userMessageCell;
    } else {
        
        preserveStatusCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *preserveState = [UIButton buttonWithType:UIButtonTypeSystem];
        
        preserveState.frame = CGRectMake(15, 10, ScreenWidth - 30, 40);
        
        preserveState.layer.cornerRadius = 20;
        
        preserveState.layer.masksToBounds = YES;
        switch (resultModel.status) {
            case 1:
                [preserveState setTitle:@"查看证书" forState:UIControlStateNormal];
                preserveState.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
                break;
            case 2:
                [preserveState setTitle:@"申请中..." forState:UIControlStateNormal];
                preserveState.backgroundColor = [UIColor lightGrayColor];
                break;
            case 3:
            {
                [preserveState setTitle:@"申请失败" forState:UIControlStateNormal];
                preserveState.backgroundColor = [UIColor lightGrayColor];
                TTTAttributedLabel *messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 + 20, 60, ScreenWidth/2, 40)];
                messageLabel.font = [UIFont systemFontOfSize:13];
                messageLabel.textColor = [UIColor lightGrayColor];
                messageLabel.textAlignment = NSTextAlignmentCenter;
                messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
                messageLabel.numberOfLines = 0;
                messageLabel.lineSpacing = 3;
                messageLabel.delegate = self;
                messageLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
                [messageLabel setText:@"您的保全订单申请失败,请联系客服:0571-86693441" afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
                 {
                     //设置可点击文字的范围
                     NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"0571-86693441" options:NSCaseInsensitiveSearch];
                     
                     //设定可点击文字的的大小
                     UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:13];
                     CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                     
                     if (font) {
                         
                         //设置可点击文本的大小
                         [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                         
                         //设置可点击文本的颜色
                         [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor hexColorFloat:@"539ac2"] CGColor] range:boldRange];
                         
                         CFRelease(font);
                         
                     }
                     return mutableAttributedString;
                 }];
                [messageLabel addLinkToURL:nil withRange:NSMakeRange(17, 13)];
                [preserveStatusCell.contentView addSubview:messageLabel];
                UIImageView *tipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/4, CGRectGetMidY(messageLabel.frame) - 8, 16, 16)];
                tipImgView.image = [UIImage imageNamed:@"2.2_preserveFailed"];
                [preserveStatusCell.contentView addSubview:tipImgView];
                break;
        }
            default:
                break;
        }
        
        [preserveState setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [preserveState addTarget:self action:@selector(handlePreserveStatus:) forControlEvents:UIControlEventTouchUpInside];
        
        [preserveStatusCell.contentView addSubview:preserveState];
        
        return preserveStatusCell;
    }
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        return 185;
    } else {
        if (resultModel.status == 3) {
            return 120;
        } else {
            return 60;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0571-86693441"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
