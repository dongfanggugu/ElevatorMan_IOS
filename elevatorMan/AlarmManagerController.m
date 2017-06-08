//
//  AlarmManagerController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "AlarmManagerController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "AlarmTitleView.h"
#import "AlarmBottomView.h"

@interface AlarmManagerController () <BMKMapViewDelegate, AlarmTitleViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@end

@implementation AlarmManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"紧急救援"];
    [self initNavRightWithText:@"查看历史"];
    [self initView];
}

- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 15;
    
    [self.view addSubview:_mapView];
    
    //头部视图
    AlarmTitleView *titleView = [AlarmTitleView viewFromNib];
    
    titleView.frame = CGRectMake(0, 64, self.screenWidth, 44);
    
    titleView.delegate = self;
    
    [self.view addSubview:titleView];
    
    //底部视图
    AlarmBottomView *bottomView = [AlarmBottomView viewFromNib];
    
    bottomView.frame = CGRectMake(0, self.screenHeight - 180, self.screenWidth, 180);
    
    [self.view addSubview:bottomView];
}

#pragma mark - AlarmTitleViewDelegate

- (void)onClickNeed
{
    
}

- (void)onClickSave
{
    
}

- (void)onClickFinish
{
    
}

- (void)onClickRevoke
{
    
}

@end
