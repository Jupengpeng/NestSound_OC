//
//  ThemeActivityController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//




#import "NSThemeActivityController.h"
#import "MainTouchTableTableView.h"
#import "MYSegmentView.h"
#import "NSThemeTopicTopView.h"
#import "NSThemeCommentController.h"
@interface NSThemeActivityController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TTTAttributedLabelDelegate>
{
    CGFloat _topViewHeight;
}
@property (nonatomic,strong) MainTouchTableTableView *mainTableView;

@property (nonatomic,strong) NSThemeTopicTopView *topView;

@property (nonatomic, strong) MYSegmentView * RCSegView;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
/**
 *  上一个 tableView 是否可移动状态
 */
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@end

@implementation NSThemeActivityController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupUI];
}

- (void)setupUI{

    self.title = @"专题活动";
    [self.mainTableView addSubview:self.topView];
    [self.view addSubview: self.mainTableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
}

-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

/**
 *  视图尺寸变化
 */
- (void)updateUIFrames{

    CGFloat height = [NSTool getHeightWithContent:_topView.descriptionLabel.text width:_topView.width font:[UIFont systemFontOfSize:12.0f]lineOffset:3.0f];
    
    _topViewHeight = height + 270 - 32 ;
    
    _mainTableView.contentInset = UIEdgeInsetsMake(_topViewHeight,0, 0, 0);
    _topView.topView.height = 150 - 32 + height;
    _topView.height = _topViewHeight;

}


-(UIView *)setPageViewControllers
{
    if (!_RCSegView) {
        
        NSThemeCommentController *leftController=[[NSThemeCommentController alloc]init];
        NSThemeCommentController *rightController =[[NSThemeCommentController alloc]init];


        
        NSArray *controllers=@[leftController,rightController];
        
        NSArray *titleArray =@[@"最新",@"最热"];
        
        MYSegmentView * rcs=[[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) controllers:controllers titleArray:titleArray ParentController:self lineWidth:ScreenWidth/2 lineHeight:3.];
        
        _RCSegView = rcs;
    }
    return _RCSegView;
}
#pragma mark UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */

    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    CGFloat tabOffsetY = [_mainTableView rectForSection:0].origin.y;
    //    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (yOffset>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
    
    
    /**
     * 处理头部视图
     */
    if(yOffset < -_topViewHeight) {
        
        CGRect f = self.topView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.y= yOffset;
        
        //改变头部视图的fram
        self.topView.frame= f;

    }
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenHeight-64;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加pageView
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {

    /**
     *  头部
     */
    if (label.tag == kTopViewLabelTag) {
        
        [_topView setupDataWithData:nil descriptionIsFoldOn:!_topView.isFoldOn];
        [self updateUIFrames];
    }
    
    
}
#pragma mark lazy init

- (MainTouchTableTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[MainTouchTableTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.contentInset = UIEdgeInsetsMake(270,0, 0, 0);
        _topViewHeight = 270;
//        _mainTableView.backgroundColor = [UIColor clearColor];
    }
    
    return _mainTableView;
}

- (NSThemeTopicTopView *)topView{
    if (!_topView) {
        _topView = [[NSThemeTopicTopView alloc] initWithFrame:CGRectMake(0, - 270, ScreenWidth, 270)];
        _topView.descriptionLabel.delegate = self;
        [_topView setupDataWithData:nil descriptionIsFoldOn:NO];
    }
    return _topView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
