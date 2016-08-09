//
//  NSSelectLyricsViewController.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/9.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSelectLyricsViewController.h"
#import "NSRollView.h"
@interface NSSelectLyricsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *lyricsArray;
@end

@implementation NSSelectLyricsViewController
- (NSArray *)lyricsArray {
    if (!_lyricsArray) {
        self.lyricsArray = [NSArray array];
    }
    return _lyricsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI {
    self.lyricsArray = [self.lyrics componentsSeparatedByString:@"\n"];
    
    WS(wSelf);
    self.view.userInteractionEnabled = YES;
    
    self.view.backgroundColor = [UIColor hexColorFloat:@"181818"];
    //pop按钮
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_pop"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        [wSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [self.view addSubview:popBtn];
    
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.top.equalTo(self.view.mas_top).offset(32);
        
        make.width.mas_equalTo(30);
    }];
    
    //标题
    NSRollView *songName = [[NSRollView alloc] initWithFrame:CGRectMake(50, 32, ScreenWidth-120, 30)];
    
    songName.text = [NSString stringWithFormat:@"%@    ",self.lyricTitle];
    
    [self.view addSubview:songName];
    
    //分享
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"下一步" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        
    }];
    
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.centerY.equalTo(popBtn.mas_centerY);
        
        //        make.top.equalTo(self.view.mas_top).offset(32);
        
        make.width.mas_equalTo(55);
    }];
    
    UITableView *lyricTab = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(songName.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(songName.frame)) style:UITableViewStylePlain];
    
    lyricTab.backgroundColor = [UIColor clearColor];
    
    lyricTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    lyricTab.delegate = self;
    
    lyricTab.dataSource = self;
    
    [self.view addSubview:lyricTab];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [lyricTab setTableFooterView: noLineView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.lyricsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *lyricCellIdenfity = @"lyricCell";
    
    UITableViewCell * lyricCell = [tableView dequeueReusableCellWithIdentifier:lyricCellIdenfity];
    
    if (!lyricCell) {
        lyricCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyricCellIdenfity];
        
        UILabel *lyricLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 0)];
        lyricLabel.text = self.lyricsArray[indexPath.row];
        lyricLabel.font = [UIFont systemFontOfSize:15];
        lyricLabel.numberOfLines = 0;
        lyricLabel.textColor = [UIColor whiteColor];
        lyricLabel.textAlignment = NSTextAlignmentCenter;
        lyricLabel.backgroundColor = [UIColor clearColor];
        [lyricCell addSubview:lyricLabel];
        NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat height = [self.lyricsArray[indexPath.row] boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:fontDic context:nil].size.height;
        CGRect frame = lyricLabel.frame;
        frame.size.height = height;
        lyricLabel.frame = frame;
        lyricCell.backgroundColor = [UIColor clearColor];
    }
    return lyricCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGFloat height = [self.lyricsArray[indexPath.row] boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:fontDic context:nil].size.height;
    
    return height + 10;
}
#pragma mark - UITableViewDelegate
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
