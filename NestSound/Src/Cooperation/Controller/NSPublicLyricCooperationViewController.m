//
//  NSPublicLyricCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPublicLyricCooperationViewController.h"
#import "NSSelectLyricListViewController.h"
#import "NSLyricDetailViewController.h"
static NSString *illustrateStr = @"· 默认合作期限为15天,您可以在所有合作作品中选取一首作为采纳作品,如超期或期限内没有满意作品,则视为合作结束\n\n· 删除合作需求,他人将无法进行合作,但已合作完成的作品不会被删除\n\n· 您的歌词作品在发起合作后,将无法进行修改";
@interface NSPublicLyricCooperationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UITextView *demandTextView;
    UILabel *placeHolderLabel;
    UITableView *publicCooperationTab;
    long lyricItemId;
}
@end

@implementation NSPublicLyricCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPublicLyricCooperationView];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    NSLyricDetailViewController *lyricDetailVC = [[NSLyricDetailViewController alloc] init];
    
//    [lyricDetailVC returnLyricWithBlock:^(NSString *lyricTitle, NSString *lyricId) {
//        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
//        
//        UITableViewCell *cell = [publicCooperationTab cellForRowAtIndexPath:index];
//        
//        cell.textLabel.textColor = [UIColor blackColor];
//        
//        cell.textLabel.text = lyricTitle;
//    }];
    
    
}
#pragma mark - Network Requests and Data Handling
- (void)publicClick {
    if (!demandTextView.text.length) {
        [[NSToastManager manager] showtoast:@"请填写合作期望"];
        return;
    } else if (!lyricItemId){
        [[NSToastManager manager] showtoast:@"请选择合作歌词"];
        return;
    }
    self.requestType = NO;
    self.requestParams = @{@"uid":JUserID,@"requirement":demandTextView.text,@"itemid":@(lyricItemId),@"token":LoginToken};
    self.requestURL = publicCooperationUrl;
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:publicCooperationUrl]) {
            if ([parserObject.message isEqualToString:@"操作成功"]) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [[NSToastManager manager] showtoast:parserObject.message];
            }
            
        }
    }
}
- (void)setupPublicLyricCooperationView {
    
    self.title = @"发布合作";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publicClick)];
    
    publicCooperationTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    publicCooperationTab.backgroundColor = KBackgroundColor;
    
    publicCooperationTab.dataSource = self;
    
    publicCooperationTab.delegate = self;
    
    [self.view addSubview:publicCooperationTab];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * publicCellIdenfity = @"publicCell";
    UITableViewCell * publicCell = [tableView dequeueReusableCellWithIdentifier:publicCellIdenfity];
    if (!publicCell) {
        publicCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:publicCellIdenfity];
        publicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        //comment textView
        demandTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, ScreenWidth, 200)];
        demandTextView.delegate = self;
//        comment.selectedRange = NSMakeRange(0,15);
        [publicCell addSubview:demandTextView];
        //placeHolder
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth, 20)];
        placeHolderLabel.font = [UIFont systemFontOfSize:14];
        placeHolderLabel.text = @"简单说一下您的合作期望吧";
        placeHolderLabel.textColor = [UIColor hexColorFloat:@"dfdfdf"];
        placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        [publicCell addSubview:placeHolderLabel];
    } else if (indexPath.section == 1) {
        publicCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        publicCell.textLabel.textColor = [UIColor hexColorFloat:@"dfdfdf"];
        publicCell.textLabel.text = @"选择参加合作的歌词作品";
        publicCell.textLabel.font = [UIFont systemFontOfSize:14];
    } else {
        UILabel *illustrate = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth/2, 20)];
        illustrate.text = @"说明";
        illustrate.font = [UIFont systemFontOfSize:14];
        [publicCell addSubview:illustrate];
        
        UILabel *explain = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, ScreenWidth - 30, 120)];
        explain.text = illustrateStr;
        explain.numberOfLines = 0;
        explain.font = [UIFont systemFontOfSize:12];
        explain.textColor = [UIColor lightGrayColor];
        [publicCell addSubview:explain];
    }
    
    return publicCell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSSelectLyricListViewController *selectLyricListVC = [[NSSelectLyricListViewController alloc] init];
        selectLyricListVC.lyricBlock = ^(NSString *lyricTitle,long lyricId) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
            
            UITableViewCell *cell = [publicCooperationTab cellForRowAtIndexPath:index];
            
            cell.textLabel.textColor = [UIColor blackColor];
            lyricItemId = lyricId;
            cell.textLabel.text = lyricTitle;
        };
        [self.navigationController pushViewController:selectLyricListVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return 220;
    } else if (indexPath.section == 1) {
        return 44;
    } else {
        return 150;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 1 : 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 5 : 0.2;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [demandTextView resignFirstResponder];
}
#pragma mark textViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    placeHolderLabel.hidden = YES;
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        placeHolderLabel.hidden = NO;
    }else{
        placeHolderLabel.hidden = YES ;
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
