//
//  NSActivityCollectionCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityCollectionCell.h"
#import "NSActivityListModel.h"
@interface NSActivityCollectionCell ()
{
    UIImageView * titlePage;
    UILabel * dateLabel;
    UILabel * stateLabel;
}

@end

@implementation NSActivityCollectionCell

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configureUIAppearance];
    }
    return self;
}
#pragma  mark configureUIAppearance
-(void)configureUIAppearance
{
    //titlePage
    titlePage = [[UIImageView alloc] init];
    titlePage.layer.cornerRadius = 10;
    [self addSubview:titlePage];
    
    //dateLab
    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = [UIColor hexColorFloat:@"ffffff"];
    [self addSubview:dateLabel];
    
    //stateLab
    stateLabel = [[UILabel alloc] init];
    stateLabel.font  = [UIFont systemFontOfSize:15];
    stateLabel.textColor = [UIColor hexColorFloat:@"ffffff"];
    [self addSubview:stateLabel];
    

}

#pragma mark
-(void)layoutSubviews
{
    [super layoutSubviews];
    //constaints
    
    //titlepage
    [titlePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    //statelable
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8);
    }];
    
    //dateLable
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stateLabel.mas_right).with.offset(15);
        make.centerY.equalTo(stateLabel.mas_centerY);
    }];
    
    
}

#pragma mark setter & getter
-(void)setActivityModel:(NSActivity *)activityModel
{
    _activityModel = activityModel;
    
    [titlePage setDDImageWithURLString:_activityModel.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_back"]];
    NSString * dateStr = [NSString stringWithFormat:@"%@ ~ %@",[date datetoMonthStringWithDate:_activityModel.beginDate],[date datetoMonthStringWithDate:_activityModel.endDate]];
    dateLabel.text = dateStr;

    if (_activityModel.status == 1) {
        stateLabel.text = @"正在进行中";
//        NSLocalizedString(@"promot_activityIng", @"");
//        LocalizedStr(@"promot_activityIng");
        
    }else  if(_activityModel.status == 2){
        stateLabel.text = @"已结束";
//        NSLocalizedString(@"promot_activityed", @"");
//        LocalizedStr(@"promot_activityed");
        dateLabel.hidden = YES;
    
    }else{
    
    }
}
@end
