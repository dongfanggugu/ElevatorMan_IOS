//
// Created by changhaozhang on 2017/6/14.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface MaintAnnotation : NSObject <BMKAnnotation>

- (id)initWithLat:(CLLocationDegrees)lat andLng:(CLLocationDegrees)lng;

@property (strong, nonatomic) NSDictionary *info;

@property (strong, nonatomic) NSArray *arrayInfo;

@end