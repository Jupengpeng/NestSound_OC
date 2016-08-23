//
//  NSTemplateTableViewCell.h
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSTemplateTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UITextField *bottomTF;
@property (nonatomic,copy) NSString *templateLyric;
@end
