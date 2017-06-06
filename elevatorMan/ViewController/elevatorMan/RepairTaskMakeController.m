//
//  RepairTaskMakeController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "RepairTaskMakeController.h"
#import "RepairTaskMakeView.h"
#import <BaiduMapAPI/BMapKit.h>

@interface RepairTaskMakeController ()

@property (strong, nonatomic) RepairTaskMakeView *taskView;

@end

@implementation RepairTaskMakeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"预约上门时间"];
    
    [self initView];
}

- (void)initView
{
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    [self.view addSubview:mapView];
    
    _taskView = [RepairTaskMakeView viewFromNib];
    
    CGRect frame = _taskView.frame;
    
    frame.origin.x = 0;
    
    frame.origin.y = self.screenHeight - frame.size.height;
    
    frame.size.width = self.screenWidth;
    
    _taskView.frame = frame;
    
    [self.view addSubview:_taskView];
}


@end
