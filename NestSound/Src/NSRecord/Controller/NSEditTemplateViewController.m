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
#import "NSPlayMusicTool.h"
@interface NSEditTemplateViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    NSString *templateTitle;
    
    NSString *templateContent;
    
    UITableView *templateTableView;
    
    NSArray *templateArr;
    
    NSString *playUrl;
}
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *musicItem;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UISlider *progressBar;
@property (nonatomic, strong) UILabel *totaltime;
@property (nonatomic, strong) UILabel *playtime;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@end
static NSString  * const templateCellIdifity = @"templateCell";
@implementation NSEditTemplateViewController
- (instancetype)initWithTemplateTitle:(NSString *)title templateContent:(NSString *)content  playUrl:(NSString *)url{
    if (self = [super init]) {
        
        templateTitle = title;
        
        templateContent = content;
        
        playUrl = url;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.userInteractionEnabled = YES;
    templateArr = [templateContent componentsSeparatedByString:@"\n"];
    
    [self setupEditTemplateUI];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self endPlaying];
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
            if (cell.bottomTF.text.length) {
                [contentArr addObject:[NSString stringWithFormat:@"%@",cell.bottomTF.text]];
            }
            
        }
    }
    content = [contentArr componentsJoinedByString:@"\n"];
    if (!content.length) {
        [[NSToastManager manager] showtoast:@"请填写歌词"];
        return;
    }
    [dict setValue:title forKey:@"lyricName"];
    
    [dict setValue:content forKey:@"lyric"];
    
    NSPublicLyricViewController *publicLyricVC = [[NSPublicLyricViewController alloc] initWithLyricDic:dict withType:YES];
    
    [self.navigationController pushViewController:publicLyricVC animated:YES];
}
#pragma mark - setupUI
- (void)setupEditTemplateUI {
    self.title = @"模版";
    int cutHeight;
    if (playUrl.length) {
        cutHeight = 50;
    } else {
        cutHeight = 0;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(saveTemplate)];
    
    self.view.backgroundColor = KBackgroundColor;
    
    templateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-cutHeight) style:UITableViewStylePlain];
    
    templateTableView.delegate = self;
    
    templateTableView.dataSource = self;
    
    templateTableView.autoAdaptKeyboard = YES;
    
    templateTableView.alwaysBounceVertical = YES;
    
    templateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [templateTableView registerClass:[NSTemplateTableViewCell class] forCellReuseIdentifier:templateCellIdifity];
    
    [self.view addSubview:templateTableView];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [templateTableView setTableFooterView:noLineView];
    
    if (playUrl.length) {
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 114, ScreenWidth, 50)];
        
        bottomView.userInteractionEnabled = YES;
        
        [self.view addSubview:bottomView];
        
        //播放暂停
        self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        _playOrPauseBtn.frame = CGRectMake(5, 5, 40, 40);
        
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"2.0_template_pause"] forState:UIControlStateNormal];
        //    [playOrPauseBtn setImage:[UIImage imageNamed:@"2.0_playSongs_highlighted"] forState:UIControlStateHighlighted];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"2.0_template_play"] forState:UIControlStateSelected];
        //    [playOrPauseBtn setImage:[UIImage imageNamed:@"2.0_pause_highlighted"] forState:UIControlStateSelected|UIControlStateHighlighted];
        
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView addSubview:_playOrPauseBtn];
        
        [_playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(10);
            
//            make.bottom.equalTo(self.view.mas_bottom).offset(-5);
            make.centerY.equalTo(bottomView.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(40, 40));
            
        }];
        
        //播放时间
        self.playtime = [[UILabel alloc] init];
        
        _playtime.textColor = [UIColor lightGrayColor];
        
        _playtime.font = [UIFont systemFontOfSize:10];
        
        _playtime.text = @"00:00";
        
        [bottomView addSubview:_playtime];
        
        [_playtime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.playOrPauseBtn.mas_right).offset(10);
            
            make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
            
        }];
        
        //总时间
        self.totaltime = [[UILabel alloc] init];
        
        _totaltime.textColor = [UIColor lightGrayColor];
        
        _totaltime.font = [UIFont systemFontOfSize:10];
        
        _totaltime.text = @"00:00";
        
        [bottomView addSubview:_totaltime];
        
        [_totaltime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.view.mas_right).offset(-10);
            
            make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
            
        }];
        
        //进度条
        self.progressBar = [[UISlider alloc] init];
        
        [_progressBar setThumbImage:[UIImage imageNamed:@"2.0_playSongs_dot"] forState:UIControlStateNormal];
        
        _progressBar.minimumTrackTintColor = [UIColor hexColorFloat:@"ffce00"];
        
        _progressBar.maximumTrackTintColor = KBackgroundColor;
        
        _progressBar.minimumValue = 0;
        
        [_progressBar addTarget:self action:@selector(progressBarSlither:) forControlEvents:UIControlEventValueChanged];
        
        //    self.progressBar = progressBar;
        
        [self.view addSubview:_progressBar];
        
        [_progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.playtime.mas_right).offset(10);
            
            make.right.equalTo(self.totaltime.mas_left).offset(-10);
            
            make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
            
        }];
    }
}
- (void)playOrPauseBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [self playMusicUrl:playUrl];
        
    } else {
        
        [self removeTimer];
        [self.player pause];
        
    }
}
//progress
- (void)progressBarSlither:(UISlider *)progressBar {
    
    CMTime ctime = CMTimeMake(progressBar.value, 1);
    
    [self.musicItem seekToTime:ctime];
    
    self.playtime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)self.progressBar.value / 60, (NSInteger)progressBar.value % 60];
}
//播放音乐
- (void)playMusicUrl:(NSString *)musicUrl {
    
    CHLog(@"--------musicUrl = %@",musicUrl);
    WS(wSelf);
    self.player = [NSPlayMusicTool playMusicWithUrl:musicUrl block:^(AVPlayerItem *musicItem) {
        
        wSelf.musicItem = musicItem;
        
    }];
    [self playMusicWithUrl:musicUrl];
    
    CMTime duration = self.player.currentItem.asset.duration;
    
    CGFloat seconds = CMTimeGetSeconds(duration);
    
    self.progressBar.maximumValue = seconds;
    
    self.totaltime.text = [NSString stringWithFormat:@"%02d:%02d",(int)seconds / 60, (int)seconds % 60];
    
    self.playOrPauseBtn.selected = YES;
    
    if (!self.timer) {
        
        [self addTimer];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
    
}
//播放音乐
- (void)playMusicWithUrl:(NSString *)musicUrl{
    
    
    if (!self.player) {
        
        self.musicItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:musicUrl]];
        
        self.player = [AVPlayer playerWithPlayerItem:self.musicItem];
        
    }
    
    [self.player play];
    
}
- (void)endPlaying {
    
    self.playOrPauseBtn.selected = NO;
    [self removeTimer];
    [self stopMusic];
}
//停止音乐
- (void)stopMusic {
    
    if (self.player||self.musicItem) {
        self.musicItem = nil;
        self.player = nil;
    }
}

- (void)addTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(actionTiming) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)actionTiming {
    
    self.progressBar.value ++;
    
    CMTime ctime = self.musicItem.currentTime;
    UInt64 currentTimeSec = ctime.value/ctime.timescale;
    self.progressBar.value = currentTimeSec;
    
    self.playtime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)self.progressBar.value / 60, (NSInteger)self.progressBar.value % 60];
}

- (void)removeTimer {
    
    [self.timer invalidate];
    
    self.timer = nil;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return templateArr.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    // 通过不同标识创建cell实例
    NSTemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[NSTemplateTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.tag = indexPath.row + 100;
    
    cell.bottomTF.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!indexPath.row) {
        
        cell.topLabel.text = [NSString stringWithFormat:@"歌名:%@",templateTitle];
        
    } else {
        
        cell.templateLyric = templateArr[indexPath.row-1];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat height = [templateArr[indexPath.row-1] boundingRectWithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:dic context:nil].size.height;
        
        if (height > 40) {
            
            return 70;
            
        } else {
            
            return 30 + height;
        }
        
    } else {
        
        return 60;
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
