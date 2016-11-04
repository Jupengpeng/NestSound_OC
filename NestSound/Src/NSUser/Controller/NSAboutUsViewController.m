//
//  NSAboutUsViewController.m
//  NestSound
//
//  Created by 李龙飞 on 16/7/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAboutUsViewController.h"
#import "NSUserFeedbackViewController.h"
#define KColor_Background [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1]
@interface NSAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NSAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
//    self.edgesForExtendedLayout = YES;
    self.view.backgroundColor = KColor_Background;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 50, 40, 100, 100)];
    logoImgView.image = [UIImage imageNamed:@"LOGO"];
    [headerView addSubview:logoImgView];
    
    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 60, CGRectGetMaxY(logoImgView.frame) + 10, 120, 20)];
    appName.text = @"音巢音乐";
    appName.textAlignment = NSTextAlignmentCenter;
    appName.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:appName];
    
    UILabel *edition = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 60, CGRectGetMaxY(appName.frame), 120, 30)];
    edition.text = [NSString stringWithFormat:@"版本:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    edition.textAlignment = NSTextAlignmentCenter;
    edition.textColor = [UIColor hexColorFloat:@"ffd00b"];
    edition.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:edition];
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    
    UITableView *aboutUsTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    aboutUsTab.delegate = self;
    aboutUsTab.dataSource = self;
    aboutUsTab.scrollEnabled = NO;
    aboutUsTab.backgroundColor = KColor_Background;
    [self.view addSubview:aboutUsTab];
    aboutUsTab.tableHeaderView = headerView;
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    aboutUsTab.tableFooterView = noLineView;
    
    UILabel *weChatLabel = [[UILabel alloc] init];
    weChatLabel.font = [UIFont systemFontOfSize:13];
    weChatLabel.textColor = [UIColor hexColorFloat:@"ffd00b"];
    weChatLabel.userInteractionEnabled = YES;
    weChatLabel.textAlignment = NSTextAlignmentCenter;
    weChatLabel.attributedText = [attributedString getMutableAttributedString:@"微信公众号: easycompose" textColor:[UIColor lightGrayColor] length:6];
    [self.view addSubview:weChatLabel];
    [weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-80);
        make.left.right.equalTo(self.view).with.offset(0);
    }];
    
    UILabel *qqLabel = [[UILabel alloc] init];
    qqLabel.font = [UIFont systemFontOfSize:13];
    qqLabel.textColor = [UIColor hexColorFloat:@"ffd00b"];
    qqLabel.userInteractionEnabled = YES;
    qqLabel.textAlignment = NSTextAlignmentCenter;
    qqLabel.attributedText = [attributedString getMutableAttributedString:@"QQ交流群: 552392444" textColor:[UIColor lightGrayColor] length:6];
    [self.view addSubview:qqLabel];
    [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-100);
        make.left.right.equalTo(self.view).with.offset(0);
    }];
    
    UILabel *copyRight = [[UILabel alloc] init];
    copyRight.text = @"Copyright © 2015-2016 Yintao.All Right Reserved";
    copyRight.font = [UIFont systemFontOfSize:12];
    copyRight.textAlignment = NSTextAlignmentCenter;
    copyRight.textColor = [UIColor lightGrayColor];
    [self.view addSubview:copyRight];
    [copyRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-20);
        make.left.right.equalTo(self.view).with.offset(0);
    }];
    
    UILabel *company = [[UILabel alloc] init];
    company.text = @"杭州音淘网络科技有限公司 版权所有";
    company.textAlignment = NSTextAlignmentCenter;
    company.textColor = [UIColor lightGrayColor];
    company.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:company];
    [company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-40);
        make.left.right.equalTo(self.view).with.offset(0);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArr = @[@"评分",@"意见反馈"];
    static NSString * aboutUsCellIdenfity = @"aboutUsCell";
    UITableViewCell * aboutUsCell = [tableView dequeueReusableCellWithIdentifier:aboutUsCellIdenfity];
    //    NSInteger section= indexPath.section;
    if (!aboutUsCell) {
        aboutUsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aboutUsCellIdenfity];
        aboutUsCell.textLabel.text = titleArr[indexPath.row];
        aboutUsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return aboutUsCell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1056101413"]];
            break;
        case 1:
        {
                NSUserFeedbackViewController * feedBackVC = [[NSUserFeedbackViewController alloc] initWithType:@"feedBack"];
                [self.navigationController pushViewController:feedBackVC animated:YES];
        }
            break;
        default:
            break;
    }
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
