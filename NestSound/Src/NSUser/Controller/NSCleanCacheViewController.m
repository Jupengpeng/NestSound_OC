//
//  NSCleanCacheViewController.m
//  NestSound
//
//  Created by yintao on 2016/12/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCleanCacheViewController.h"

@interface NSCleanCacheViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *cleanCacheTab;
}
@end

@implementation NSCleanCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCleanCacheViewController];
}
- (void)setupCleanCacheViewController {
    self.title = @"清除缓存";
    
    cleanCacheTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    cleanCacheTab.delegate = self;
    
    cleanCacheTab.dataSource = self;
    
    cleanCacheTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self.view addSubview:cleanCacheTab];
    
//    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
//    
//    [cleanCacheTab setTableFooterView:noLineView];
    
    [cleanCacheTab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.right.equalTo(self.view);
        
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cleanCacheCell";
    NSArray *textStrs = @[@"清除歌曲缓存",@"清除其他数据缓存"];
    CGFloat otherData;
    otherData = [self filePath];
    NSArray *detailStrs = @[@"45M",[NSString stringWithFormat:@"%.fM",otherData]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = textStrs[indexPath.row];
    cell.detailTextLabel.text = detailStrs[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!indexPath.row) {
        [[NSToastManager manager] showtoast:@"清除歌曲缓存"];
    } else {
       [self clearFile];
    }
    [[NSToastManager manager] showtoast:@"清除成功"];
    cell.detailTextLabel.text = @"0M";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
-(float )filePath {
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
// 清理缓存

- (void)clearFile {
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
  
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];

    NSLog ( @"cachpath = %@" , cachPath);

    for ( NSString * p in files) {

        NSError * error = nil ;
     
        NSString * path = [cachPath stringByAppendingPathComponent :p];
     
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
  
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
  
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}

-(void)clearCachSuccess {
    
    [cleanCacheTab reloadData];
//    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];//刷新
//    
//    [cleanCacheTab reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    
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
