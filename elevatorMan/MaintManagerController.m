//
//  MaintManagerController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "MaintManagerController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ComMaintTitleView.h"

@interface MaintManagerController () <BMKMapViewDelegate, ComMaintTitleViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@end

@implementation MaintManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"E维保"];
    [self initNavRightWithText:@"维保历史"];
    [self initView];
}

- (void)onClickNavRight
{
}

- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 15;
    
    [self.view addSubview:_mapView];
    
    //头部视图
    ComMaintTitleView *titleView = [ComMaintTitleView viewFromNib];
    
    titleView.frame = CGRectMake(0, 64, self.screenWidth, 75);
    
    titleView.delegate = self;
    
    [self.view addSubview:titleView];
}

#pragma mark - AlarmTitleViewDelegate

- (void)onClickBtn1
{
    
}

- (void)onClickBtn2
{
    
}

- (void)onClickBtn3
{
    
}

- (void)onClickBtn4
{
    
}

@end
