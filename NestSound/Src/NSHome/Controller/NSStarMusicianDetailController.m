//
//  NSStarMusicianDetailController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianDetailController.h"
#import "NSStarMusicianModel.h"
#import "NSStarMusicianTopCell.h"
#import "NSStarMusicianBottomCell.h"
#import "NSPlayMusicViewController.h"
#import "NSPlayMusicTool.h"

@interface NSStarMusicianDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_clickedButton;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSStarMusicianModel *musicianModel;

@property (nonatomic,strong) NSMutableArray *songArray;

@property (nonatomic, strong) AVPlayer *player;


@end

@implementation NSStarMusicianDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSPlayMusicTool pauseMusicWithName:nil];
    [NSPlayMusicTool stopMusicWithName:nil];
}

- (void)setupUI{
    
    self.title = self.name;
    
    [self.view addSubview:self.tableView];

    WS(weakSelf);
    [self.tableView addDDPullToRefreshWithActionHandler:^{
       
        if (!weakSelf) {

        }else{
            [weakSelf fetchDetailDataWithIsLoadingMore:NO];
        }
    }];
    [self.tableView.pullToRefreshView startAnimating];
    [self fetchDetailDataWithIsLoadingMore:NO];
    
    
}

- (void)fetchDetailDataWithIsLoadingMore:(BOOL)isLoadingMore{
    
    [self.tableView.pullToRefreshView startAnimating];

    self.requestType = NO;
    self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                           @"uid":self.uid};
    self.requestURL = musicianDetailUrl;
    
}

- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        
    }else{
        if ([operation.urlTag isEqualToString:musicianDetailUrl]) {
         
            self.musicianModel = (NSStarMusicianModel *)parserObject;
            
            if (self.songArray.count) {
                [self.songArray removeAllObjects];
            }
            for (NSWorklistModel *workModel in self.musicianModel.worklistData.workList) {
                [self.songArray addObject:@(workModel.workId)];
            }
            
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        }
        
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 0) {
        NSString *contentStr  = [NSString stringWithFormat:@"%@",self.musicianModel.musicianData.musicianModel.musicianDescription];
//        @"2010年发表单曲《空》收录在大石原唱音乐自选集发表作品:电视剧“我的经济适用男“片尾曲放开爱、戚薇电视剧”爱情自有天意“插曲《小小世界》、娄艺潇电视剧”爱的多米诺“片头曲《爱的多米诺》、阿悄戚薇《失窃之物》专辑主打歌《失窃之物》、box专辑《路》收录《双面人》钟纯研、单曲《@所有怀疑我的人》。";
        CGFloat contentHeight = [NSTool getHeightWithContent:contentStr width:ScreenWidth - 30 font:[UIFont systemFontOfSize:12.0f] lineOffset:0];

        return 110 + contentHeight;
    }
    else{
        if (indexPath.row == 0) {
            return 38;
        }
        else{
        return 80;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.musicianModel.worklistData.workList.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 2)];
        headerView.backgroundColor = [UIColor hexColorFloat:@"efeff4"];
        return headerView;
    }
    else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSStarMusicianTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSStarMusicianTopCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.musicianModel = self.musicianModel.musicianData.musicianModel;
        return cell;
    }
    else{
        
        if(indexPath.row == 0){
            static NSString *cellID = @"cellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"作品列表";
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.textColor = [UIColor hexColorFloat:@"7a7a7a"];
            return cell;
        }
        else {
            NSStarMusicianBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSStarMusicianBottomCellID"];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
            
            cell.clickBlock = ^(UIButton *clickButton,NSWorklistModel *workListModel){
                if (_clickedButton!=clickButton) {
                    _clickedButton.selected = NO;
                    _clickedButton = clickButton;
                    _clickedButton.selected = YES;
                }else{
                    clickButton.selected = !clickButton.selected;
                    _clickedButton = clickButton;
                }
                /**
                 *  取消上一个点击状态
                 */
                if (clickButton.selected) {

                    if (!self.player) {
                        [NSPlayMusicTool pauseMusicWithName:nil];
                        self.player = [NSPlayMusicTool playMusicWithUrl:workListModel.mp3 block:^(AVPlayerItem *item) {}];
                    } else {
                        self.player = [NSPlayMusicTool playMusicWithUrl:workListModel.mp3 block:^(AVPlayerItem *item) {}];
                    }
                } else {
                    [NSPlayMusicTool pauseMusicWithName:nil];

                    //        self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
                }
            };
            
            if (self.musicianModel.worklistData.workList.count) {
                NSWorklistModel *workListModel = self.musicianModel.worklistData.workList[indexPath.row - 1];
                cell.musicianModel = workListModel;

            }

            
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    

}

#pragma mark - lazy init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor hexColorFloat:@"efeff4"];
        [_tableView registerClass:[NSStarMusicianTopCell class] forCellReuseIdentifier:@"NSStarMusicianTopCellID"];
        [_tableView registerClass:[NSStarMusicianBottomCell class] forCellReuseIdentifier:@"NSStarMusicianBottomCellID"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)songArray{
    if (!_songArray) {
        _songArray = [NSMutableArray array];
    }
    return _songArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
