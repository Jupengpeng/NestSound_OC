//
//  NSEditTemplateViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSEditTemplateViewController.h"
#import "NSTemplateTableViewCell.h"
#import "NSPublicLyricViewController.h"
@interface NSEditTemplateViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    NSString *templateTitle;
    
    NSString *templateContent;
    
    UITableView *templateTableView;
    
    NSArray *templateArr;
}
@end
static NSString  * const templateCellIdifity = @"templateCell";
@implementation NSEditTemplateViewController
- (instancetype)initWithTemplateTitle:(NSString *)title templateContent:(NSString *)content {
    if (self = [super init]) {
        
        templateTitle = title;
        
        templateContent = content;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    templateArr = [templateContent componentsSeparatedByString:@"\n"];
    
    [self setupEditTemplateUI];
}
-(void)saveTemplate {
    NSString *title,*content;
    NSMutableArray *contentArr = [NSMutableArray arrayWithCapacity:templateArr.count];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < templateArr.count; i++) {
        NSTemplateTableViewCell *cell = (NSTemplateTableViewCell *)[templateTableView viewWithTag:i + 100];
        if (i == 0) {
            title = cell.bottomTF.text;
        } else {
            [contentArr addObject:[NSString stringWithFormat:@"%@\n",cell.bottomTF.text]];
        }
    }
    content = [contentArr componentsJoinedByString:@","];
    [dict setValue:title forKey:@"lyricName"];
    
    [dict setValue:content forKey:@"lyric"];
    
    NSPublicLyricViewController *publicLyricVC = [[NSPublicLyricViewController alloc] initWithLyricDic:dict withType:YES];
    
    [self.navigationController pushViewController:publicLyricVC animated:YES];
}
#pragma mark - setupUI
- (void)setupEditTemplateUI {
    self.title = @"模版";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(saveTemplate)];
    
    self.view.backgroundColor = KBackgroundColor;
    
    templateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    
    templateTableView.delegate = self;
    
    templateTableView.dataSource = self;
    
    templateTableView.autoAdaptKeyboard = YES;
    
    templateTableView.alwaysBounceVertical = YES;
    
    templateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [templateTableView registerClass:[NSTemplateTableViewCell class] forCellReuseIdentifier:templateCellIdifity];
    
    [self.view addSubview:templateTableView];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [templateTableView setTableFooterView:noLineView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return templateArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSTemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:templateCellIdifity forIndexPath:indexPath];
    
    cell.tag = indexPath.row + 100;
    
    cell.bottomTF.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!indexPath.row) {
        
        cell.topLabel.text = [NSString stringWithFormat:@"歌名:%@",templateTitle];
    } else {
        
        cell.topLabel.text = templateArr[indexPath.row];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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