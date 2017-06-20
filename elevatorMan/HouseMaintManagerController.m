//
// Created by changhaozhang on 2017/6/9.
//

#import "HouseMaintManagerController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HouseTitleView.h"
#import "RepairAnnotation.h"
#import "RepairAnnotationView.h"
#import "OrderMaintListController.h"
#import "MaintResultShowController.h"
#import "MaintInfoController.h"
#import "MaintDetailController.h"

typedef NS_ENUM(NSInteger, FiltState)
{
    Filt_Be,
    Filt_Ing,
    Filt_Ed,
    Filt_Over
};

@interface HouseMaintManagerController () <BMKMapViewDelegate, HouseTitleViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) NSDictionary *dicMaint;

@property (strong, nonatomic) HouseTitleView *titleView;

@property (weak, nonatomic) RepairAnnotationView *curAnnView;

@property (assign, nonatomic) FiltState filtState;

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
    _filtState = Filt_Be;
    [self markOnMap:_dicMaint[@"weiChuLi"]];
}

- (void)markOnMap:(NSArray *)array
{
    [_mapView removeAnnotations:[_mapView annotations]];

    for (NSInteger i = 0; i < array.count; i++)
    {
        NSMutableDictionary *annInfo = [NSMutableDictionary dictionary];

        annInfo[@"category"] = @"maint";

        NSDictionary *info = array[i];
        RepairAnnotation *ann = nil;

        if (Filt_Be == _filtState)
        {
            annInfo[@"type"] = @"order";
            ann = [[RepairAnnotation alloc] initWithLat:[info[@"villaInfo"][@"lat"] floatValue] andLng:[info[@"villaInfo"][@"lng"] floatValue]];
        }
        else
        {
            annInfo[@"type"] = @"task";
            ann = [[RepairAnnotation alloc] initWithLat:[info[@"maintOrderInfo"][@"villaInfo"][@"lat"] floatValue]
                                                 andLng:[info[@"maintOrderInfo"][@"villaInfo"][@"lng"] floatValue]];
        }

        annInfo[@"data"] = info;
        ann.info = annInfo;

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
    if ([annotation isKindOfClass:[RepairAnnotation class]])
    {
        RepairAnnotation *ann = (RepairAnnotation *) annotation;

        RepairAnnotationView *annView = (RepairAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:[RepairAnnotationView identifier]];

        if (!annView)
        {
            annView = [[RepairAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:[RepairAnnotationView identifier]];
        }

        annView.info = ann.info;

        __weak typeof(self) weakSelf = self;

        [annView setOnClickDetail:^(NSArray *arrayInfo) {

            if (weakSelf.curAnnView)
            {
                [weakSelf.curAnnView hideInfoView];
                weakSelf.curAnnView.selected = NO;
                weakSelf.curAnnView = nil;
            }

            if (Filt_Be == weakSelf.filtState)
            {
                MaintDetailController *controller = [[MaintDetailController alloc] init];
                controller.orderInfo = ann.info[@"data"];
                controller.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                MaintInfoController *controller = [[MaintInfoController alloc] init];
                controller.maintInfo = ann.info[@"data"];
                controller.mode = MaintTaskMode_Show;
                controller.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
        }];

        return annView;
    }

    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    RepairAnnotationView *annView = (RepairAnnotationView *) view;

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
        _curAnnView.selected = NO;
        _curAnnView = nil;
    }
}


#pragma mark - HouseTitleViewDelegate

/**
 * 未处理
 */
- (void)onClickNeed
{
    _filtState = Filt_Be;
    [self markOnMap:self.dicMaint[@"weiChuLi"]];
}

/**
 * 处理中
 */
- (void)onClickSave
{
    _filtState = Filt_Ing;
    [self markOnMap:self.dicMaint[@"chuLiZhong"]];
}

/**
 * 已处理
 */
- (void)onClickFinish
{
    _filtState = Filt_Ed;
    [self markOnMap:self.dicMaint[@"yiChuLi"]];
}

/**
 *已过期
 */
- (void)onClickRevoke
{
    _filtState = Filt_Over;
    [self markOnMap:self.dicMaint[@"yiChaoQi"]];
}
@end