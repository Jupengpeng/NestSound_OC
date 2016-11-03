//
//  NSLyricDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricDetailViewController.h"
#import "NSCooperationLyricListModel.h"
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
    
    lyricView.lyricText.textColor = [UIColor darkGrayColor];
    
    lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.paragraphSpacing = 8;
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    lyricView.lyricText.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n作词:%@\n%@",self.lyricModel.title,self.lyricModel.author,self.lyricModel.lyric] attributes:attributes];
    
    [self.view addSubview:lyricView];
}
- (void)useLyricClick{

    self.lyricBlock(self.lyricModel.title,self.lyricModel.lyricId);
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
