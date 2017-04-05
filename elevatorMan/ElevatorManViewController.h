//
//  ElevatorManViewController.h
//  elevatorMan
//
//  Created by Cove on 15/4/1.
//
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface ElevatorManViewController : UIViewController<BMKMapViewDelegate>
{
    IBOutlet BMKMapView* _mapView;
    //BMKLocationService* _locService;
}
@end
