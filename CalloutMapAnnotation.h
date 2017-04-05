//
//  CalloutMapAnnotation.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#ifndef CalloutMapAnnotation_h
#define CalloutMapAnnotation_h

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface CalloutMapAnnotation : NSObject<BMKAnnotation>

@property (nonatomic) CLLocationDegrees latitude;

@property (nonatomic) CLLocationDegrees longitude;

@property (strong, nonatomic) NSMutableDictionary *info;


- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lng;


@end


#endif /* CalloutMapAnnotation_h */
