//
//  ElevatorManViewController.m
//  elevatorMan
//
//  Created by Cove on 15/4/1.
//
//

#import "ElevatorManViewController.h"
#import "AppDelegate.h"
#import "HttpClient.h"
#import "location.h"

//static SystemSoundID soundID;
//static NSMutableDictionary *dataDic;

@interface ElevatorManViewController ()

@end

@implementation ElevatorManViewController



- (void)dealloc
{
    if (_mapView) {
        _mapView = nil;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [[location sharedLocation] startLocationService];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
   // _locService.delegate = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 13.0f;
    
    
    //设置菜单按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    //设置title
    self.title = @"电梯易管家";
    
    
    //添加位置更新通知
    if([self respondsToSelector:@selector(getUserLocationUpdate:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserLocationUpdate:)name:@"userLocationUpdate" object:nil];
    }


}

- (void)getUserLocationUpdate:(NSNotification *)notification
{
 
    [_mapView updateLocationData:[notification.userInfo objectForKey:@"userLocation"]];

}




- (IBAction)followUserLocation:(id)sender {
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    [[location sharedLocation] startLocationService];
    
    _mapView.showsUserLocation = YES;
}


@end