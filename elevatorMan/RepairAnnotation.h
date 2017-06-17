//
// Created by changhaozhang on 2017/6/17.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>


@interface RepairAnnotation : NSObject <BMKAnnotation>

- (id)initWithLat:(CLLocationDegrees)lat andLng:(CLLocationDegrees)lng;

@property (strong, nonatomic) NSDictionary *info;

@end