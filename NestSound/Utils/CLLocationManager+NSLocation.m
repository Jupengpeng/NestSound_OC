//
//  CLLocationManager+NSLocation.m
//  MarketMan
//
//  Created by yandi on 15/8/26.
//  Copyright (c) 2016年 yinchao All rights reserved.
//

#import <objc/runtime.h>
#import "AppDelegate+NSAdditions.h"
#import "CLLocationManager+NSLocation.h"

@implementation NSLocation

#pragma mark -getter or setter
- (NSString *)city {
    return [self.addressDictionary objectForKey:@"City"]?:@"";
}

- (NSString *)street {
    return [self.addressDictionary objectForKey:@"Street"]?:@"";
}

- (NSString *)country {
    return [self.addressDictionary objectForKey:@"Country"]?:@"";
}

- (NSString *)province {
    return [self.addressDictionary objectForKey:@"State"]?:@"";
}

- (NSString *)district {
    return [self.addressDictionary objectForKey:@"SubLocality"]?:@"";
}
@end

@interface CLLocationManager (LocationVar)
@property (nonatomic,strong) CLGeocoder *coder;
@property (nonatomic,strong) NSLocation *cachedLoc;
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,copy) void(^cachedBlock)(NSLocation *loc);
@property (nonatomic,assign) CLAuthorizationStatus cachedAuthStatus;
@end


@implementation CLLocationManager (NSLocation)
static char *coderKey;
static char *cachedLocKey;
static char *cachedBlockKey;
static char *cachedAuthStatusKey;

+ (void)obtainLocation:(void(^)(NSLocation *location))locationBlock force:(BOOL)force {
    static CLLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CLLocationManager alloc] init];
        manager.delegate = manager;
    });
    
    if (force) {
        
        manager.cachedBlock = locationBlock;
        [manager obtainLocationAuthorization];
    } else {
        if (manager.cachedLoc) {
            
            locationBlock(manager.cachedLoc);
        } else {
            
            manager.cachedBlock = locationBlock;
            [manager obtainLocationAuthorization];
        }
    }
}

- (void)obtainLocationAuthorization {
    if (![CLLocationManager locationServicesEnabled]) {
        
        [self showAuthAlert];
    } else {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied) {
            
            [self showAuthAlert];
            if (self.cachedBlock) {
                
                self.cachedBlock(nil);
                self.cachedBlock = nil;
            }
        } else {
            if ([AppDelegate systemVer] >= 8.0) {
                
                if (status == kCLAuthorizationStatusNotDetermined) {
                    
                    [self requestWhenInUseAuthorization];
                }
                [self startUpdatingLocation];
            } else {
                
                [self startUpdatingLocation];
            }
        }
        self.cachedAuthStatus = status;
    }
}

#pragma mark -getter & setter
- (CLGeocoder *)coder {
    if (!objc_getAssociatedObject(self, &coderKey)) {
        CLGeocoder *aCoder = [[CLGeocoder alloc] init];
        objc_setAssociatedObject(self, &coderKey, aCoder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return aCoder;
    }
    return objc_getAssociatedObject(self, &coderKey);
}

- (void)setCachedLoc:(NSLocation *)cachedLoc {
    objc_setAssociatedObject(self, &cachedLocKey, cachedLoc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLocation *)cachedLoc {
    return objc_getAssociatedObject(self, &cachedLocKey);
}

- (void)setCachedBlock:(void (^)(NSLocation *))cachedBlock {
    objc_setAssociatedObject(self, &cachedBlockKey, cachedBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(NSLocation *))cachedBlock {
    return objc_getAssociatedObject(self, &cachedBlockKey);
}

- (void)setCachedAuthStatus:(CLAuthorizationStatus)cachedAuthStatus {
    objc_setAssociatedObject(self, &cachedAuthStatusKey, @(cachedAuthStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLAuthorizationStatus)cachedAuthStatus {
    return [objc_getAssociatedObject(self, &cachedAuthStatusKey) intValue];
}

#pragma mark -showAuthAlert
- (void)showAuthAlert {
    [[[UIAlertView alloc] initWithTitle:
                               LocalizedStr(@"prompt_locationService")
                                message:LocalizedStr(@"prompt_locationGuide")
                               delegate:nil
                      cancelButtonTitle:LocalizedStr(@"prompt_known")
                      otherButtonTitles:nil, nil] show];
}

#pragma mark -showLocErrAlert 
- (void)showLocErrAlert {
    [[[UIAlertView alloc] initWithTitle:LocalizedStr(@"prompt_locationFailure")
                               message:LocalizedStr(@"prompt_locationObtainAgain")
                              delegate:nil
                     cancelButtonTitle:LocalizedStr(@"prompt_known")
                     otherButtonTitles:nil, nil] show];
}

#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    __weak typeof(self) wSelf = self;
    [self.coder reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!wSelf) {
            return ;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        if (!error) {
            
            [sSelf stopUpdatingLocation];
            CLPlacemark *placemark = placemarks.lastObject;
            sSelf.cachedLoc = [[NSLocation alloc] init];
            sSelf.cachedLoc.location = placemark.location.coordinate;
            sSelf.cachedLoc.addressDictionary = placemark.addressDictionary;
            sSelf.cachedLoc.formatAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] firstObject];
            
            @synchronized(sSelf.class) {
                
                if (sSelf.cachedBlock) {
                    
                    sSelf.cachedBlock(sSelf.cachedLoc);
                    sSelf.cachedBlock = nil;
                }
            }
        } else {
            
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
                
                 [sSelf showAuthAlert];
            } else {
                
                [sSelf showLocErrAlert];
            }
            if (sSelf.cachedBlock) {
                
                sSelf.cachedBlock(nil);
                sSelf.cachedBlock = nil;
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.cachedAuthStatus != status) {
        if (status == kCLAuthorizationStatusDenied) {
            
            [manager stopUpdatingLocation];
            [self showLocErrAlert];
            if (self.cachedBlock) {
                
                self.cachedBlock(nil);
                self.cachedBlock = nil;
            }
        } else {
            
            [manager startUpdatingLocation];
        }
        self.cachedAuthStatus = status;
    }
}
@end
