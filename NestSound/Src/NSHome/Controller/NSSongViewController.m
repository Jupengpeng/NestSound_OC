//
//  NSSongViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongViewController.h"
#import "NSSongListHeaderView.h"
#import "NSSongCell.h"
#import "NSPlayViewController.h"

@interface NSSongViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>{
    NSMutableArray * songAry;
    
    NSString * songListId;
    UITableView * songsTable;
    NSSongListHeaderView * header;

}


@end


@implementation NSSongViewController

static NSString * cellId = @"SongCell";


-(instancetype)initWithSongListId:(NSString *)listId
{
    self = [super init];
    if (!self) {
        self = [[NSSongViewController alloc] init];
        songListId = listId;
      
    }

    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];

    
    [self configureUIApperance];
}



-(void)configureUIApperance
{
    
    //title
    self.title = LocalizedStr(@"promot_song");
    
    //tableView
    songsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    songsTable.backgroundColor = [UIColor whiteColor];
    songsTable.delegate = self;
    songsTable.dataSource = self;
    songsTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    songsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //headerView
    header = [[NSSongListHeaderView alloc] init];
    songsTable.tableHeaderView = header;
    [self.view addSubview:songsTable];

}

#pragma mark tablView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return songAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * songCellIdentifer = @"NSSongCell";
    NSSongCell * songCell = [tableView dequeueReusableCellWithIdentifier:songCellIdentifer];
    if (!songCell) {
        songCell = [[NSSongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:songCellIdentifer];
        
    }
    
//    songCell.number = ;
//    songCell.authorName = ;
//    songCell.workName = ;
    
    return songCell;
}

#pragma mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSSongViewController * song = [[NSSongViewController alloc] initWithSongListId:@"itemid"];
    [self.navigationController pushViewController:song animated:YES];
    
    
}


@end
