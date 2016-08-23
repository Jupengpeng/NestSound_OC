//
//  NSRhymeViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRhymeViewController.h"

@interface NSRhymeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *textArr;
@end

@implementation NSRhymeViewController

static NSString *cellIdentifier = @"rhymeCell";

- (NSArray *)textArr {
    if (!_textArr) {
        self.textArr = [NSArray array];
    }
    return _textArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRhymeViewUI];
    
}
- (void)setupRhymeViewUI {
    
    NSString *text = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"韵脚" ofType:@"txt"] encoding: NSUTF8StringEncoding error: NULL];
    
    self.textArr = [text componentsSeparatedByString:@"\n\n"];
    
    self.title = @"韵脚";
    
    UITableView *rhymeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    
    rhymeTableView.delegate = self;
    
    rhymeTableView.dataSource = self;
    
    [rhymeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        
    [self.view addSubview:rhymeTableView];
    
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return self.textArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *rhymeCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    rhymeCell.textLabel.numberOfLines = 0;
    rhymeCell.textLabel.font = [UIFont systemFontOfSize:15];
    rhymeCell.textLabel.text = self.textArr[indexPath.section];
    
    return rhymeCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    
    CGFloat height = [self.textArr[indexPath.section] boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:dic context:nil].size.height;
    if (height >= 150) {
       return height + 40;
    } else {
        return height + 20;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
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
