//
//  NSDownView.m
//  NestSound
//
//  Created by 鞠鹏 on 2017/2/10.
//  Copyright © 2017年 yinchao. All rights reserved.
//

#import "NSDownView.h"

@interface NSDownView ()
{
    NSDownViewVolumeBlock _accompanyBlock;
    NSDownViewVolumeBlock _recordBlock;
    
    UILabel *_accomBackLabel;
    
    UILabel *_recordBackLabel;
    
    UISlider *_accomSlider;
    UISlider *_recordSlider;
}


@end

@implementation NSDownView

- (instancetype)initWithFrame:(CGRect)frame accompanyBlock:(NSDownViewVolumeBlock)accompanyBlock recordBlock:(NSDownViewVolumeBlock)recordBlock{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        _accompanyBlock = accompanyBlock;
        _recordBlock = recordBlock;
        
    }
    
    return self;
    
}

- (void)setupUI{
    
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"音量调节";
    label.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:label];
    
    UILabel *accomLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 35, 15)];
    accomLabel.textColor = [UIColor hexColorFloat:@"646464"];
    accomLabel.font = [UIFont systemFontOfSize:15.0f];
    accomLabel.text = @"伴奏";
    [self addSubview:accomLabel];
    
    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, 35, 15)];
    recordLabel.textColor = [UIColor hexColorFloat:@"646464"];
    recordLabel.font = [UIFont systemFontOfSize:15.0f];
    recordLabel.text = @"人声";
    [self addSubview:recordLabel];
    
    UISlider *accomSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accomLabel.frame)+15, CGRectGetMinY(accomLabel.frame), ScreenWidth - 140, 15)];
    accomSlider.tintColor = [UIColor hexColorFloat:kAppBaseYellowValue];
    accomSlider.maximumValue = 100;
    [accomSlider addTarget:self action:@selector(changeAccomVolume:) forControlEvents:UIControlEventTouchUpInside];
    [accomSlider addTarget:self action:@selector(accomVolumeChanged:) forControlEvents:UIControlEventValueChanged];
    accomSlider.value = 50;
    _accomSlider = accomSlider;
    [self addSubview:accomSlider];
    
    UISlider *recordSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accomLabel.frame)+15, CGRectGetMinY(recordLabel.frame), ScreenWidth - 140, 15)];
    recordSlider.tintColor = [UIColor hexColorFloat:kAppBaseYellowValue];
    [recordSlider addTarget:self action:@selector(changeRecordVolume:) forControlEvents:UIControlEventTouchUpInside];
    [recordSlider addTarget:self action:@selector(recordVolumeChanged:) forControlEvents:UIControlEventValueChanged];
    recordSlider.maximumValue = 100;
    recordSlider.value = 50;
    _recordSlider = recordSlider;
    [self addSubview:recordSlider];

    
    
   _accomBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accomSlider.frame) + 15, 55, 35, 15)];
    _accomBackLabel.textColor = [UIColor hexColorFloat:@"646464"];
    _accomBackLabel.font = [UIFont systemFontOfSize:14.0f];
    _accomBackLabel.text = @"50";

    [self addSubview:_accomBackLabel];
    
    _recordBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recordSlider.frame) + 15, 95, 35, 15)];
    _recordBackLabel.textColor = [UIColor hexColorFloat:@"646464"];
    _recordBackLabel.font = [UIFont systemFontOfSize:14.0f];
    _recordBackLabel.text = @"50";

    [self addSubview:_recordBackLabel];
    

}

-  (void)changeAccomVolume:(UISlider *)slider{
    
    
    if (_accompanyBlock) {
        _accompanyBlock(slider.value);
    }
}

- (void)accomVolumeChanged:(UISlider *)slider{
    _accomBackLabel.text = [NSString stringWithFormat:@"%.0f",slider.value];

}

-  (void)changeRecordVolume:(UISlider *)slider{
    if (_recordBlock) {
        _recordBlock(slider.value);
    }
}

- (void)recordVolumeChanged:(UISlider *)slider{
    
    _recordBackLabel.text = [NSString stringWithFormat:@"%.0f",slider.value];

    
}


- (void)setBothVolume:(CGFloat)volume{
    
    _accomSlider.value = 50;
    _recordSlider.value = 50;
    _accomBackLabel.text = [NSString stringWithFormat:@"%.0f",volume];
    _recordBackLabel.text = [NSString stringWithFormat:@"%.0f",volume];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
