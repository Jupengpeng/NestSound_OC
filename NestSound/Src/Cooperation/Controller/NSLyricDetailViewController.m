//
//  NSLyricDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricDetailViewController.h"
#import "NSLyricView.h"
@interface NSLyricDetailViewController ()
{
    NSLyricView *lyricView;
}
@end

@implementation NSLyricDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetupLyricDetailView];
}
#pragma mark - setupUI
- (void)SetupLyricDetailView {
    
    self.title = @"选择歌词";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"使用" style:UIBarButtonItemStylePlain target:self action:@selector(useLyricClick)];
    
    lyricView = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenHeight - 20)];
    lyricView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    lyricView.lyricText.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    
    lyricView.lyricText.text = @"Terminating app due to uncaught exception Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Invalid update: invalid number of rows in section 1.  The number of rows contained in an existing section after the update (2) must be equal to the number of rows contained in that section before the update (2), plus or minus the number of rows inserted or deleted from that section (0 inserted, 2 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).'";
    
    lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:lyricView];
}
- (void)useLyricClick{

    self.lyricBlock(@"lyricTitle",1);
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}
//- (void)returnLyricWithBlock:(returnLyric)block {
//    self.lyricBlock = block;
//}
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
