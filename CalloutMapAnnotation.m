//
//  CalloutMapAnnotation.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#import <Foundation/Foundation.h>
#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation()

@end

@implementation CalloutMapAnnotation

- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lng
{
    if (self = [super init])
    {
        self.latitude = lat;
        self.longitude = lng;
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}
@end
