//
//  NSAccompanyListFilterView.m
//  NestSound
//
//  Created by yintao on 16/9/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#define kButtonBaseTag 200

#define  kOriginY  45
#define  kLeadPadding  15.0f
#define  kSpacePadding  10.0f
#define  kBottomPadding  15.0f
#define  kTagButtonWidth  (ScreenWidth - 2*kLeadPadding - 3*kSpacePadding)/4
#define  kTagButtonHeight  (kTagButtonWidth * 7/16.0f)

#import "NSAccompanyListFilterView.h"
#import "NSAccommpanyListModel.h"
@interface NSAccompanyListFilterView ()
{
    UIButton *_currentSortButton;
    UIButton *_currentCateButton;
    NSAccommpanyListModel *_listModel;
    NSSimpleCategoryModel *_categoryModel;
    NSInteger _sortIndex;
    NSInteger _categoryIndex;
    CGFloat _totalHeight;
    
    UIView *_superView;
}

@property (nonatomic,strong) UIView *tagMainView;


@end

@implementation NSAccompanyListFilterView

- (instancetype)initWithFrame:(CGRect)frame listModel:(NSAccommpanyListModel *)listModel
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        _listModel = listModel;
        self.clipsToBounds = YES;
        
        self.backgroundColor = [[UIColor hexColorFloat:@"181818"] colorWithAlphaComponent:0.3];
        
        self.tagMainView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tagMainView.clipsToBounds = YES;
        self.tagMainView.backgroundColor = [UIColor whiteColor];
//        self.tagMainView.frame = CGRectMake(0, 0, ScreenWidth, 230);
        [self addSubview:self.tagMainView];
        
        /**
         *  上边线
         */
        [self addSubview:[self createLineWithOriginY:0]];
        
        
        UILabel *title1Label = [self createLabelWithFrame:CGRectMake(15, 13, 40, 20) text:@"风格"];
        [self.tagMainView addSubview:title1Label];
        
        UILabel *line2 = [self createLineWithOriginY:0];
        [self.tagMainView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagMainView.mas_left);
            make.right.equalTo(self.tagMainView.mas_right);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(-170);
        }];
        
    
        UILabel *title2Label = [self createLabelWithFrame:CGRectZero text:@"筛选"];
        [self.tagMainView addSubview:title2Label];
        [title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagMainView.mas_left).offset(15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.tagMainView.mas_bottom).offset(- 170 + 33);
        }];
        
        

        UIButton *sortNewButton = [self createTagButtonWithFrame:CGRectZero title:@"最新" action:^(UIButton *btn) {
            [self chooseSortWithIndex:btn];
        }];
        sortNewButton.tag = 100;
        [self.tagMainView addSubview:sortNewButton];
        [sortNewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagMainView.mas_left).offset(15.0f);
            make.width.mas_equalTo(kTagButtonWidth);
            make.height.mas_equalTo(kTagButtonHeight);
            make.bottom.equalTo(self.tagMainView.mas_bottom).offset(-90.0f);
        }];

        
        UIButton *sortHotButton = [self createTagButtonWithFrame:CGRectZero title:@"最热" action:^(UIButton *btn) {
            [self chooseSortWithIndex:btn];
        }];
        [self.tagMainView addSubview:sortHotButton];
        sortHotButton.tag = 101;
        [sortHotButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sortNewButton.mas_right).offset(kSpacePadding);
            make.width.mas_equalTo(kTagButtonWidth);
            make.height.mas_equalTo(kTagButtonHeight);
            make.bottom.equalTo(self.tagMainView.mas_bottom).offset(-90.0f);
        }];
        
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 20 ;
            btn.layer.borderColor = [UIColor hexColorFloat:@"c1c1c1"].CGColor;
            btn.layer.borderWidth = 0.5f ;
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor hexColorFloat:kAppBaseYellowValue]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hexColorFloat:@"323232"] forState:UIControlStateNormal];
            [btn setTitle:@"确定" forState:UIControlStateNormal];
        } action:^(UIButton *btn) {
            [self confirmClick];
        }];
        [self.tagMainView addSubview:confirmButton];
        
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagMainView.mas_left).offset(15.0f);
            make.right.equalTo(self.tagMainView.mas_right).offset(-15.0f);
            make.height.mas_equalTo(40.0f);
            make.bottom.equalTo(self.tagMainView.mas_bottom).offset(-15.0f);
        }];
        
        
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        [self setupWithListModel:listModel];
        /**
         *  开始从最新开始
         */
        sortNewButton.selected = YES;
        _currentSortButton = sortNewButton;
        _sortIndex = 0 ;
        
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self dismiss];
}

#pragma mark - show & dismiss

- (void)showWithCompletion:(void (^)(BOOL finished))completion {
    if (!self.hidden) {
        [self dismiss];
        return;
    }
    if (self.superview) {
        _superView = self.superview;
    }
    if (_superView) {
        [_superView addSubview:self];
    }
    
    self.hidden = NO;

    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionLayoutSubviews  animations:^{
        self.tagMainView.height = _totalHeight;
    } completion:^(BOOL finished) {
        completion(YES);
    }];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:5.0f options:UIViewAnimationOptionLayoutSubviews  animations:^{
        self.tagMainView.height = 0.1;

    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

- (void)dismissWithCompletion:(void (^)(BOOL finished))completion{
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:5.0f options:UIViewAnimationOptionLayoutSubviews  animations:^{
        self.tagMainView.height = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        
    }];
}

#pragma mark - action
- (void)chooseSortWithIndex:(UIButton *)clickedButton{
    _currentSortButton.selected = NO;
    _currentSortButton = clickedButton;
    _currentSortButton.selected = YES;
    _sortIndex = clickedButton.tag - 100;
    if (self.sortBlock) {
        self.sortBlock(_sortIndex);
    }
}

- (void)chooseCategoryWithIndex:(UIButton *)clickedButton{
    _currentCateButton.selected = NO;
    _currentCateButton = clickedButton;
    _currentCateButton.selected = YES;
    
    NSInteger index = clickedButton.tag - kButtonBaseTag;
    
    NSSimpleCategoryModel *categoryModel = [_listModel.simpleCategoryList.simpleCategory objectAtIndex:(_listModel.simpleCategoryList.simpleCategory.count- 1 - index)];
    _categoryModel = categoryModel;
    _categoryIndex = index;
//    if (self.categoryBlock) {
//        self.categoryBlock(index,categoryModel);
//    }
}

- (void)confirmClick{
 
    if (self.confirmBlock) {
        self.confirmBlock(_sortIndex,_categoryIndex,_categoryModel);
    }
    [self dismiss];
}

- (void)setOriginalStateWithIndex:(NSInteger)index{
    [self chooseCategoryWithIndex:[self.tagMainView viewWithTag:(kButtonBaseTag + index)]];
    if (self.confirmBlock) {
        self.confirmBlock(_sortIndex,_categoryIndex,_categoryModel);
    }
}



- (void)setupWithListModel:(NSAccommpanyListModel *)listModel{
    /**
     *  数组逆序
     */
    if (!listModel.simpleCategoryList.simpleCategory.count) {
        return;
    }
    
    NSInteger remainder = listModel.simpleCategoryList.simpleCategory.count%4;
    NSInteger lineCount =  remainder?
    (1 + listModel.simpleCategoryList.simpleCategory.count/4) :
    listModel.simpleCategoryList.simpleCategory.count/4 ;
    
    NSMutableArray *neededArray = [[NSMutableArray alloc] initWithCapacity:10];
    NSArray *arr = [[listModel.simpleCategoryList.simpleCategory reverseObjectEnumerator] allObjects];
    [neededArray addObjectsFromArray:arr];
    NSInteger index = 0 ;
    for (NSInteger line = 0; line <lineCount; line ++) {
        for (NSInteger column = 0; column < ((line == lineCount - 1)?(!remainder?4:remainder)  : 4 );column ++ ) {
            index = line * 4 + column;
            NSSimpleCategoryModel *categoryModel = [neededArray objectAtIndex:index];
            
            UIButton *tagButton  = [self createTagButtonWithFrame:CGRectMake(kLeadPadding + (kTagButtonWidth + kSpacePadding) * column,  kOriginY + (kTagButtonHeight + kSpacePadding) * line, kTagButtonWidth, kTagButtonHeight) title:categoryModel.categoryName action:^(UIButton *btn) {
                [self chooseCategoryWithIndex:btn];
                
            }];
            
            tagButton.tag = kButtonBaseTag + index;
            [self.tagMainView addSubview:tagButton];
            if (index == 0) {
                [self chooseCategoryWithIndex:tagButton];
            }
        }
    }
    
    _totalHeight = CGRectGetMaxY([self.tagMainView viewWithTag:kButtonBaseTag + listModel.simpleCategoryList.simpleCategory.count - 1].frame) + 170 + 15;
    self.tagMainView.frame = CGRectMake(0, 0, ScreenWidth,
                                        0);
    
    self.hidden = YES;
}

/**
 *  factory method
 */

- (UIButton *)createTagButtonWithFrame:(CGRect)frame title:(NSString *)title action:(void(^)(UIButton *btn))actionBlock{
    UIButton *sortNewButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        if (frame.size.width) {
            btn.frame = frame;
        }
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 4 ;
        btn.layer.borderColor = [UIColor hexColorFloat:@"c1c1c1"].CGColor;
        btn.layer.borderWidth = 0.5f ;
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor hexColorFloat:kAppBaseYellowValue]] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor hexColorFloat:@"646464"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor hexColorFloat:@"323232"] forState:UIControlStateSelected];
        [btn setTitle:title forState:UIControlStateNormal];
    } action:^(UIButton *btn) {
        if (actionBlock) {
            actionBlock(btn);

        }
    }];
    return sortNewButton;
}


- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:frame];
    newLabel.font = [UIFont systemFontOfSize:14.0f];
    newLabel.textColor = [UIColor hexColorFloat:@"343434"];
    newLabel.text = text;
    
    return newLabel;
}

- (UILabel *)createLineWithOriginY:(CGFloat)originY {
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, ScreenWidth, 1)];
    lineLabel.backgroundColor = [UIColor hexColorFloat:kAppLineRgbValue];
    return lineLabel;
}

@end
