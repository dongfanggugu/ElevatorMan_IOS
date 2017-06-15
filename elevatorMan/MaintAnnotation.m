//
// Created by changhaozhang on 2017/6/14.
//

#import "MaintAnnotation.h"

@interface  MaintAnnotation ()

@property (assign, nonatomic) CLLocationDegrees latitude;

@property (assign, nonatomic) CLLocationDegrees longitude;

@end

@implementation MaintAnnotation

- (id)initWithLat:(CLLocationDegrees)lat andLng:(CLLocationDegrees)lng
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
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_latitude, _longitude);

    return coor;
}

@end