//
//  NSSelectLyricsViewController.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/9.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSelectLyricsViewController.h"
#import "NSLyricTableViewCell.h"
#import "NSLyricPosterViewController.h"
#import "NSRollView.h"
@interface NSSelectLyricsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableViewCell *cell;
    NSInteger index;
}
@property (nonatomic, strong) NSArray *lyricsArray;
@property (nonatomic, strong) NSMutableArray *lyricPosterArr;
@property (nonatomic,strong) NSMutableArray *lyricIndexArr;
@end

static NSString *lyricCellIdenfity = @"lyricCell";

@implementation NSSelectLyricsViewController

- (NSArray *)lyricsArray {
    if (!_lyricsArray) {
        self.lyricsArray = [NSMutableArray array];
    }
    return _lyricsArray;
}
- (NSMutableArray *)lyricPosterArr {
    if (!_lyricPosterArr) {
        self.lyricPosterArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _lyricPosterArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI {
    
    
    
    if (self.lyricsArray.count == 1) {
        self.lyricsArray = [self.lyrics componentsSeparatedByString:@"\n"];

    } else {
        self.lyricsArray = [self.lyrics componentsSeparatedByString:@"\r\n"];
    }

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
        
        NSLyricPosterViewController *lyricPosterVC = [[NSLyricPosterViewController alloc] init];
        
        for (NSInteger i = 0; i < self.lyricPosterArr.count; i++) {
            for (NSInteger j = 1; j < self.lyricPosterArr.count - i ; j ++) {
                NSInteger comparNum = [self.lyricIndexArr[j]  integerValue];
                NSInteger currentNum = [self.lyricIndexArr[j - 1] integerValue];
                if (comparNum < currentNum) {
                    [self.lyricIndexArr exchangeObjectAtIndex:j - 1 withObjectAtIndex:j];
                    [self.lyricPosterArr exchangeObjectAtIndex:j - 1 withObjectAtIndex:j];
                }
            }
        }
        
        lyricPosterVC.lyricsArr = self.lyricPosterArr;
        
        lyricPosterVC.lyricTitle  = self.lyricTitle;
        
        lyricPosterVC.lyricAuthor = self.author;
        
        lyricPosterVC.posterImg = self.themeImg;
        
        [wSelf.navigationController pushViewController:lyricPosterVC animated:YES];
        
    }];
    
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.centerY.equalTo(popBtn.mas_centerY);
        
        make.width.mas_equalTo(55);
    }];
    
    UITableView *lyricTab = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(songName.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(songName.frame)) style:UITableViewStylePlain];
    
    lyricTab.backgroundColor = [UIColor clearColor];
    
    lyricTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    lyricTab.allowsMultipleSelection = YES;
    
    lyricTab.delegate = self;
    
    lyricTab.dataSource = self;
    
    [lyricTab registerClass:[NSLyricTableViewCell class] forCellReuseIdentifier:lyricCellIdenfity];
    
    [self.view addSubview:lyricTab];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [lyricTab setTableFooterView: noLineView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLyricTableViewCell *lyricCell = [tableView dequeueReusableCellWithIdentifier:lyricCellIdenfity forIndexPath:indexPath];
    
    
    
    lyricCell.rightLabel.text = self.lyricsArray[indexPath.row];
    
    NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};

    CGFloat height = [self.lyricsArray[indexPath.row] boundingRectWithSize:CGSizeMake(ScreenWidth-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:fontDic context:nil].size.height;
    
    CHLog(@"lable height %.f",height);
    
    
    CGRect frame = lyricCell.rightLabel.frame;
    
    frame.size.height = height;
    
    lyricCell.rightLabel.frame = frame;
    
    CHLog(@"lable new height %.f",lyricCell.rightLabel.height);
    
    lyricCell.selectionStyle = UITableViewCellSelectionStyleNone;

    /**
     *  已被点击的坐标
     */
    if ([self.lyricIndexArr containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        lyricCell.rightLabel.textColor = [UIColor whiteColor];
        lyricCell.backgroundColor = [UIColor colorWithRed:106.0/255 green:96.0/255 blue:84.0/255 alpha:1.0];
        lyricCell.leftImgView.hidden = NO;
    }else{
        lyricCell.rightLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
        lyricCell.backgroundColor = [UIColor clearColor];
        lyricCell.leftImgView.hidden = YES;
    }
    
    
    return lyricCell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    
    CGFloat height = [self.lyricsArray[indexPath.row] boundingRectWithSize:CGSizeMake(ScreenWidth-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:fontDic context:nil].size.height;
    
    return height + 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLyricTableViewCell *lyricCell = [tableView cellForRowAtIndexPath:indexPath];
    
    lyricCell.backgroundColor = [UIColor colorWithRed:106.0/255 green:96.0/255 blue:84.0/255 alpha:1.0];
    
    lyricCell.leftImgView.hidden = NO;
    
    lyricCell.rightLabel.textColor = [UIColor whiteColor];
    
    [self.lyricIndexArr addObject:[NSNumber numberWithInteger:indexPath.row]];
    
    [self.lyricPosterArr addObject:[NSString stringWithFormat:@"%@\n",self.lyricsArray[indexPath.row]]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLyricTableViewCell *lyricCell = [tableView cellForRowAtIndexPath:indexPath];
    
    lyricCell.rightLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
    
    lyricCell.leftImgView.hidden = YES;
    
    lyricCell.backgroundColor = [UIColor clearColor];
    
    [self.lyricIndexArr removeObject:[NSNumber numberWithInteger:indexPath.row]];
    
    [self.lyricPosterArr removeObject:[NSString stringWithFormat:@"%@\n",self.lyricsArray[indexPath.row]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma lazy init

- (NSMutableArray *)lyricIndexArr{
    if (!_lyricIndexArr) {
        _lyricIndexArr = [NSMutableArray array];
    }
    return _lyricIndexArr;
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
