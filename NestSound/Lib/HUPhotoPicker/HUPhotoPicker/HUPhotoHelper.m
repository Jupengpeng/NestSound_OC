//
//  HUPhotoHelper.m
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUPhotoHelper.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAsset.h>
#import "HUAlbum.h"

 NSString *const kDidFetchCameraRollSucceedNotification = @"kDidFetchCameraRollSucceedNotification";

static const char *kIOQueueLable = "com.jewelz.assetqueue";

@interface HUPhotoHelper () {
    NSMutableArray *_photos;
    
}

@property (nonatomic, copy) FetchPhotoSucceed resutBlock;
@property (nonatomic, copy) FetchAlbumSucceed albumBlock;
@property (nonatomic) dispatch_queue_t ioQueue;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;


@end

@implementation HUPhotoHelper

+ (instancetype)sharedInstance {
    static HUPhotoHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [HUPhotoHelper new];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create(kIOQueueLable, DISPATCH_QUEUE_CONCURRENT);
        if (!IS_IOS8_LATER) {
            self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        }
        
    }
    return self;
}

+ (void)fetchAlbums:(FetchAlbumSucceed)result {
    HUPhotoHelper *helper = [HUPhotoHelper sharedInstance];
    helper.albumBlock = result;
    [helper getallAlbums];
}

+ (void)fetchAssetsInAssetCollection:(id)assetCollection resultHandler:(FetchPhotoSucceed)result {
    HUPhotoHelper *helper = [HUPhotoHelper sharedInstance];
    helper.resutBlock = result;
    [helper enumerateAssetsInAssetCollection:assetCollection original:NO];
}

- (id)cameraRoll {
    if (IS_IOS8_LATER) 
        return [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {

            [[NSNotificationCenter defaultCenter] postNotificationName:kDidFetchCameraRollSucceedNotification object:group];
        }
        
    } failureBlock:^(NSError *error) {
        CHLog(@"Group not found!");
    }];
    return nil;
}

- (void)getallAlbums {
    NSMutableArray *albums = [NSMutableArray array];
    self.allCollections = [NSMutableArray array];
    
    if (IS_IOS8_LATER) {
        dispatch_async(_ioQueue, ^{
            // 获得所有的自定义相簿
            PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            // 遍历所有的自定义相簿
            for (PHAssetCollection *assetCollection in assetCollections) {
                [_allCollections addObject:assetCollection];
                [albums addObject:[self enumerateAlbum:assetCollection]];
            }
            // 获得相机胶卷
            PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
            if (cameraRoll){
                [_allCollections addObject:cameraRoll];
                [albums addObject:[self enumerateAlbum:cameraRoll]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (self.albumBlock) {
                    self.albumBlock(albums);
                }
                
            });
        });

    }
    else {
    
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group) {
                
                [_allCollections addObject:group];
                [albums addObject:[self enumerateAlbum:group]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (self.albumBlock) {
                    self.albumBlock(albums);
                }
                
            });
            
        } failureBlock:^(NSError *error) {
            CHLog(@"Group not found!");
        }];

        
       
    }
    
    
    
}

- (HUAlbum *)enumerateAlbum:(id )assetCollection {
    HUAlbum *album = [[HUAlbum alloc] init];
    if (IS_IOS8_LATER) {
        PHAssetCollection *assetC = (PHAssetCollection *)assetCollection;
        CHLog(@"相簿名:%@", assetC.localizedTitle);
        album.title = assetC.localizedTitle;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        // 获得某个相簿中的所有PHAsset对象
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetC options:nil];
        album.imageCount = assets.count;
        PHAsset *asset = [assets firstObject];
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            CHLog(@"album：%@", result);
            
            album.album = (UIImage *)result;
            
        }];
        
    }
    else {
        ALAssetsGroup *group = (ALAssetsGroup *)assetCollection;
        album.title = [group valueForProperty:ALAssetsGroupPropertyName];
        album.imageCount = group.numberOfAssets;
        album.album = [UIImage imageWithCGImage:group.posterImage];
        
    }
   
    return album;
    
}


/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(id)assetCollection original:(BOOL)original {
    __block NSString *localizedTitle = nil;
    __block NSMutableArray *images = nil;
    dispatch_async(_ioQueue, ^{
        if (IS_IOS8_LATER) {
            PHAssetCollection *assetC = (PHAssetCollection *)assetCollection;
            CHLog(@"相簿名:%@", assetC.localizedTitle);
            localizedTitle = assetC.localizedTitle;
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            // 同步获得图片, 只会返回1张图片
            options.synchronous = YES;

                // 获得某个相簿中的所有PHAsset对象
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetC options:nil];
            images = [NSMutableArray arrayWithCapacity:assets.count];
            
            for (PHAsset *asset in assets) {
                // 是否要原图
                CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
                // 从asset中获得图片
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (result) {
                        
                        [images addObject:(UIImage *)result];
                    }
                    
                }];
            }
                
                
           
        }
        else {
            
            ALAssetsGroup *group = (ALAssetsGroup *)assetCollection;
            localizedTitle = [group valueForProperty:ALAssetsGroupPropertyName];
            images = [NSMutableArray arrayWithCapacity:group.numberOfAssets];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
                    [images addObject:[UIImage imageWithCGImage:result.thumbnail]];
                }
                
            }];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (self.resutBlock) {
                self.resutBlock(images,localizedTitle);
            }
        });
        
    });
}



@end
