//
// Created by changhaozhang on 2017/6/9.
//

#import "HouseRepairManagerController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HouseTitleView.h"

@interface HouseRepairManagerController () <BMKMapViewDelegate, HouseTitleViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@end

@implementation HouseRepairManagerController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"怡墅维修"];
    [self initNavRightWithText:@"查看订单"];
    [self initView];
}

- (void)initView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _mapView.delegate = self;

    _mapView.zoomLevel = 15;

    [self.view addSubview:_mapView];

    //头部视图
    HouseTitleView *titleView = [HouseTitleView viewFromNib];

    titleView.frame = CGRectMake(0, 64, self.screenWidth, 44);

    titleView.delegate = self;

    [self.view addSubview:titleView];

}

#pragma mark - HouseTitleViewDelegate

/**
 * 未处理
 */
- (void)onClickNeed {

}

/**
 * 处理中
 */
- (void)onClickSave {
}

/**
 * 已处理
 */
- (void)onClickFinish {
}

/**
 *已过期
 */
- (void)onClickRevoke {
}

@end