//
//  NSSearchUserCollectionView.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSearchUserCollectionView.h"
#import "NSSearchUserCollectionViewCell.h"

@interface NSSearchUserCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation NSSearchUserCollectionView

static NSString * const identifier = @"identifierCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        self.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
        
        self.delegate = self;
        
        self.dataSource = self;
        
        [self registerClass:[NSSearchUserCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSSearchUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
    return cell;
}



@end








