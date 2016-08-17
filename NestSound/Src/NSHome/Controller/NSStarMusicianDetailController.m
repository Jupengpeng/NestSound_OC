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
@interface NSStarMusicianDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NSStarMusicianDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI{
    
    [self.view addSubview:self.tableView];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *contentStr  = @"2010年发表单曲《空》收录在大石原唱音乐自选集发表作品:电视剧“我的经济适用男“片尾曲放开爱、戚薇电视剧”爱情自有天意“插曲《小小世界》、娄艺潇电视剧”爱的多米诺“片头曲《爱的多米诺》、阿悄戚薇《失窃之物》专辑主打歌《失窃之物》、box专辑《路》收录《双面人》钟纯研、单曲《@所有怀疑我的人》。";
        CGFloat contentHeight = [NSTool getHeightWithContent:contentStr width:ScreenWidth - 30 font:[UIFont systemFontOfSize:12.0f] lineOffset:0];

        return 120 + contentHeight;
    }
    else{
        if (indexPath.row == 0) {
            return 38;
        }
        else{
        return 110;
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
        return 8;
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
        
        cell.musicianModel = [[NSStarMusicianModel alloc] init];
        
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
            cell.musicianModel = [[NSStarMusicianModel alloc] init];
            
            
            return cell;
        }
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
