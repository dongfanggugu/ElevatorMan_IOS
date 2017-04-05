//
//  location.m
//  elevatorMan
//
//  Created by Cove on 15/6/29.
//
//

#import "location.h"


@interface location()<BMKLocationServiceDelegate>

@property (nonatomic ,strong)BMKLocationService* locService;

@property (strong, nonatomic)CLLocationManager *locationManager;

@end

@implementation location


+ (instancetype)sharedLocation
{
    static location *_sharedLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      
                      _sharedLocation = [[location alloc] init];
                      
                  });
    
    return _sharedLocation;
}


- (void)startLocationService
{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:1.f];
    
     NSLog(@"location start");
    

    if (nil == self.locService)
    {
        NSLog(@"sevice is nil");
        self.locService = [[BMKLocationService alloc]init];
        
        self.locService.delegate = self;
        [self.locService startUserLocationService];

    }
    else
    {
        NSLog(@"sevice is not nil");
    }
    

}

- (CLLocationDistance)handleDistance:(CLLocationCoordinate2D)coor
{

    BMKMapPoint point1 = BMKMapPointForCoordinate(self.userLocation.location.coordinate);
    BMKMapPoint point2 = BMKMapPointForCoordinate(coor);
    return  BMKMetersBetweenMapPoints(point1,point2);
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {

    NSLog(@"location complete");
    //关闭定位
    [self.locService stopUserLocationService];
    self.locService.delegate = nil;
    self.locService = nil;
    
    self.userLocation = userLocation;
    
    
    //self.currentLocation = userLocation.location.coordinate;
    
    //self.currentLocation = coords;
    //通知更新位置
    //创建通知
    
    NSLog(@"before send notify");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:userLocation forKey:@"userLocation"];
    
    NSNotification *notification =[NSNotification notificationWithName:@"userLocationUpdate" object:nil userInfo:userInfo];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    NSLog(@"after send notify");
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@", userLocation.heading);
}

#pragma mark - test random
-(float) randomBetween:(float)smallerNum And:(float)largerNumber
{
    int precision = 100;
    float subtraction = largerNumber - smallerNum;
    subtraction = ABS(subtraction);
    subtraction *=precision;
    float randomNum = arc4random()%((int)subtraction+1);
    randomNum /= precision;
    float result = MIN(smallerNum, largerNumber)+randomNum;
    return result;
}


@end
