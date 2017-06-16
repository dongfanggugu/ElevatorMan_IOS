//
// Created by changhaozhang on 2017/6/9.
//

#import "HouseMaintManagerController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HouseTitleView.h"
#import "MaintAnnotation.h"
#import "MaintAnnotationView.h"
#import "OrderMaintListController.h"

@interface HouseMaintManagerController () <BMKMapViewDelegate, HouseTitleViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) NSDictionary *dicMaint;

@property (strong, nonatomic) HouseTitleView *titleView;

@property (weak, nonatomic) MaintAnnotationView *curAnnView;

@end

@implementation HouseMaintManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"怡墅维保"];
    [self initNavRightWithText:@"查看订单"];
    [self initView];
    [self getMaint];
}

- (void)onClickNavRight
{
    OrderMaintListController *controller = [[OrderMaintListController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _mapView.delegate = self;

    _mapView.zoomLevel = 10;

    [self.view addSubview:_mapView];

    //头部视图
    _titleView = [HouseTitleView viewFromNib];

    _titleView.frame = CGRectMake(0, 64, self.screenWidth, 44);

    _titleView.delegate = self;

    [self.view addSubview:_titleView];

}

- (void)getMaint
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;

    [[HttpClient sharedClient] post:@"getMaintOrderProcessByBranchIdOnState" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dicMaint = responseObject[@"body"];
        [self markMaint];
    }];
}

- (void)markMaint
{
    [self showTitleCount];
    [self markOnMap:_dicMaint[@"weiChuLi"]];
}

- (void)markOnMap:(NSArray *)array
{
    [_mapView removeAnnotations:[_mapView annotations]];
    for (NSInteger i = 0; i < array.count; i++)
    {
        NSDictionary *info = array[i];

        MaintAnnotation *ann = [[MaintAnnotation alloc] initWithLat:[info[@"villaInfo"][@"lat"] floatValue] andLng:[info[@"villaInfo"][@"lng"] floatValue]];

        ann.info = info;

        [_mapView addAnnotation:ann];
    }
}

- (void)showTitleCount
{
    NSString *received = [NSString stringWithFormat:@"未处理(%ld)", [self.dicMaint[@"weiChuLi"] count]];
    [_titleView.btnNeed setTitle:received forState:UIControlStateNormal];

    NSString *process = [NSString stringWithFormat:@"处理中(%ld)", [self.dicMaint[@"chuLiZhong"] count]];
    [_titleView.btnSave setTitle:process forState:UIControlStateNormal];

    NSString *finish = [NSString stringWithFormat:@"已处理(%ld)", [self.dicMaint[@"yiChuLi"] count]];
    [_titleView.btnFinish setTitle:finish forState:UIControlStateNormal];

    NSString *overTime = [NSString stringWithFormat:@"已过期(%ld)", [self.dicMaint[@"yiChaoQi"] count]];
    [_titleView.btnRevoke setTitle:overTime forState:UIControlStateNormal];
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MaintAnnotation class]])
    {
        MaintAnnotation *ann = (MaintAnnotation *) annotation;

        MaintAnnotationView *annView = (MaintAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:[MaintAnnotationView identifier]];

        if (!annView)
        {
            annView = [[MaintAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:[MaintAnnotationView identifier]];
        }


        __weak typeof(self) weakSelf = self;

        [annView setOnClickDetail:^(NSArray *arrayInfo) {

        }];
        annView.arrayInfo = ann.arrayInfo;

        return annView;
    }

    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    MaintAnnotationView *annView = (MaintAnnotationView *) view;

    if (_curAnnView)
    {
        if (_curAnnView == annView)
        {
            return;
        }

        [_curAnnView hideInfoView];

        [annView showInfoView];

        _curAnnView = annView;
    }
    else
    {
        [annView showInfoView];
        _curAnnView = annView;
    }

}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (_curAnnView)
    {
        [_curAnnView hideInfoView];
        _curAnnView = nil;
    }
}


#pragma mark - HouseTitleViewDelegate

/**
 * 未处理
 */
- (void)onClickNeed
{
    [self markOnMap:self.dicMaint[@"weiChuLi"]];
}

/**
 * 处理中
 */
- (void)onClickSave
{
    [self markOnMap:self.dicMaint[@"chuLiZhong"]];
}

/**
 * 已处理
 */
- (void)onClickFinish
{
    [self markOnMap:self.dicMaint[@"yiChuLi"]];
}

/**
 *已过期
 */
- (void)onClickRevoke
{
    [self markOnMap:self.dicMaint[@"yiChaoQi"]];
}
@end