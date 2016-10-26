//
//  NSPublicLyricCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPublicLyricCooperationViewController.h"
#import "NSSelectLyricListViewController.h"
@interface NSPublicLyricCooperationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate,NSSelectLyricListViewControllerDelegate>
{
    UITextView *demandTextView;
    UILabel *placeHolderLabel;
    UITableView *publicCooperationTab;
}
@end

@implementation NSPublicLyricCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPublicLyricCooperationView];
}
- (void)publicClick {
    
}
- (void)setupPublicLyricCooperationView {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(publicClick)];
    
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
        UILabel *illustrate = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth, 20)];
        illustrate.text = @"说明";
        [publicCell addSubview:illustrate];
        
        UILabel *explain = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth - 20, 100)];
        
    }
    
    return publicCell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSSelectLyricListViewController *selectLyricListVC = [[NSSelectLyricListViewController alloc] init];
        selectLyricListVC.delegate = self;
        [self.navigationController pushViewController:selectLyricListVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return 220;
    } else if (indexPath.section == 1) {
        return 44;
    } else {
        return 120;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 1 : 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 5 : 0.2;
}
#pragma mark - NSSelectLyricListViewControllerDelegate
- (void)selectLyric:(NSString *)lyricId withLyricTitle:(NSString *)LyricTitle {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    
    UITableViewCell *cell = [publicCooperationTab cellForRowAtIndexPath:index];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.text = LyricTitle;
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
