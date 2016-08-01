//
//  HUImagePickerViewController.m
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUImagePickerRootViewController.h"
#import "HUImagePickerCell.h"
#import "HUPhotoHelper.h"
#import "HUImagePickerViewController.h"

static const CGFloat kSpacing = 2.0;

@interface HUImagePickerRootViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    NSMutableDictionary *_selectedIndexPaths;
    NSMutableArray *_selectedImages;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation HUImagePickerRootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView reloadData];
}

- (instancetype)initWithAssetCollection:(id)assetCollection {
    self = [self init];
    _assetCollection = assetCollection;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedIndexPaths = [NSMutableDictionary dictionary];
        _selectedImages = [NSMutableArray array];
        _images = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraRollHandler:) name:kDidFetchCameraRollSucceedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteImage:) name:@"DeleteImageNotification" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeleteImageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidFetchCameraRollSucceedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(didFinishedPick)];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:HUImagePickerCell.nib forCellWithReuseIdentifier:HUImagePickerCell.reuserIdentifier];
    
    [self startFetchPhotosWithCollection:_assetCollection];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startFetchPhotosWithCollection:(id)collection {
    __weak __typeof(self) wself = self;
    [HUPhotoHelper fetchAssetsInAssetCollection:collection resultHandler:^(NSArray *images, NSString *albumTitle) {
        __strong __typeof(self) sself = wself;
        sself.title = albumTitle;
        sself.images = images;
        [sself.collectionView reloadData];
    }];
}

- (void)cameraRollHandler:(NSNotification *)notif {
    [self startFetchPhotosWithCollection:notif.object];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kSpacing;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    return _collectionView;
}

#pragma mark - Collection view data source 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HUImagePickerCell reuserIdentifier] forIndexPath:indexPath];
    cell.imageView.image = _images[indexPath.row];
    
    if (_selectedIndexPaths[@(indexPath.row)]) {
        cell.didSelected = YES;
    }
    else {
        cell.didSelected = NO;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HUImagePickerCell *cell = (HUImagePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_selectedIndexPaths[@(indexPath.row)]) {
        [_selectedIndexPaths removeObjectForKey:@(indexPath.row)];
        cell.didSelected = NO;
    }
    else {
        NSArray *allValues = _selectedIndexPaths.allValues;
        if (allValues.count >= self.maxCount) {
            NSLog(@"已到达最大数量了");
            return;
        }

        [_selectedIndexPaths setObject:indexPath forKey:@(indexPath.row)];
        cell.didSelected = YES;
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width-6)/4;
    return CGSizeMake(width, width);
}

#pragma mark - private

- (void)didFinishedPick {
    
    NSArray *allValues = _selectedIndexPaths.allValues;
    if (allValues.count > 0) {
        [_selectedImages removeAllObjects];
        for (NSIndexPath *indexPath in allValues) {
            [_selectedImages addObject:_images[indexPath.row]];
        }
    }
   
    HUImagePickerViewController *navigationVc = (HUImagePickerViewController *)self.navigationController;
    if ([navigationVc.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImages:)]) {
        [navigationVc.delegate imagePickerController:navigationVc didFinishPickingImages:_selectedImages];
    }  
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)maxCount {
    HUImagePickerViewController *navigationVc = (HUImagePickerViewController *)self.navigationController;
    return navigationVc.maxAllowSelectedCount;
}

- (BOOL)didSelectedAtIndexPath:(NSIndexPath *)indexPath withSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    if (!selectedIndexPath) return NO;
    
    return indexPath.row == selectedIndexPath.row;
}

- (void)didDeleteImage:(NSNotification *)notify {
    UIImage *image = notify.object;
    NSInteger index = [_images indexOfObject:image];
    [_selectedImages removeObject:image];
    [_selectedIndexPaths removeObjectForKey:@(index)];
}

@end
