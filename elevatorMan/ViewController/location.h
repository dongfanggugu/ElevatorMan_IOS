//
//  location.h
//  elevatorMan
//
//  Created by Cove on 15/6/29.
//
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface location : NSObject

@property (nonatomic, strong)BMKUserLocation *userLocation;
//@property (nonatomic)CLLocationCoordinate2D currentLocation;

- (void)startLocationService;
+ (instancetype)sharedLocation;
- (CLLocationDistance)handleDistance:(CLLocationCoordinate2D)coor;



@end
