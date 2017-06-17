//
// Created by changhaozhang on 2017/6/17.
//

#import "RepairAnnotation.h"

@interface RepairAnnotation ()

@property (assign, nonatomic) CLLocationDegrees latitude;

@property (assign, nonatomic) CLLocationDegrees longitude;

@end


@implementation RepairAnnotation

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