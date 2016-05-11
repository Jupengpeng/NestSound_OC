//
//  CLLocationManager+NSLocation.h
//  MarketMan
//
//  Created by yandi on 15/8/26.
//  Copyright (c) 2016年 yinchao All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface NSLocation : NSObject
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *street;
@property (nonatomic,copy) NSString *country;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *district;
@property (nonatomic,copy) NSString *formatAddress;
@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,strong) NSDictionary *addressDictionary;
@end

@interface CLLocationManager (NSLocation)
<
CLLocationManagerDelegate
>
+ (void)obtainLocation:(void(^)(NSLocation *location))locationBlock force:(BOOL)force;
@end
