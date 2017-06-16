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
#import "AlarmHistoryController.h"
#import "MaintAnnotationView.h"
#import "MaintAnnotation.h"

@interface AlarmManagerController () <BMKMapViewDelegate, AlarmTitleViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) AlarmTitleView *titleView;

@property (strong, nonatomic) NSMutableArray *arrayAlarm;

@property (strong, nonatomic) NSMutableArray *arrayReceived;

@property (strong, nonatomic) NSMutableArray *arrayProcess;

@property (strong, nonatomic) NSMutableArray *arrayFinished;

@property (strong, nonatomic) NSMutableArray *arrayCancel;

@property (strong, nonatomic) AlarmBottomView *bottomView;

@property (strong, nonatomic) NSMutableDictionary *dicAnnView;

@end

@implementation AlarmManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"紧急救援"];
    [self initNavRightWithText:@"查看历史"];
    [self initView];
    [self getAlarms];
}

- (void)onClickNavRight
{
    AlarmHistoryController *controller = [[AlarmHistoryController alloc] init];

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
    _titleView = [AlarmTitleView viewFromNib];

    _titleView.frame = CGRectMake(0, 64, self.screenWidth, 44);

    _titleView.delegate = self;

    [self.view addSubview:_titleView];

    //底部视图
    _bottomView = [AlarmBottomView viewFromNib];

    _bottomView.frame = CGRectMake(0, self.screenHeight - 180, self.screenWidth, 180);

    _bottomView.hidden = YES;

    [self.view addSubview:_bottomView];
}

- (NSMutableDictionary *)dicAnnView
{
    if (!_dicAnnView)
    {
        _dicAnnView = [NSMutableDictionary dictionary];
    }

    return _dicAnnView;
}

- (NSMutableArray *)arrayAlarm
{
    if (!_arrayAlarm)
    {
        _arrayAlarm = [NSMutableArray array];
    }

    return _arrayAlarm;
}

- (NSMutableArray *)arrayReceived
{
    if (!_arrayReceived)
    {
        _arrayReceived = [NSMutableArray array];
    }

    return _arrayReceived;
}

- (NSMutableArray *)arrayProcess
{
    if (!_arrayProcess)
    {
        _arrayProcess = [NSMutableArray array];
    }

    return _arrayProcess;
}

- (NSMutableArray *)arrayFinished
{
    if (!_arrayFinished)
    {
        _arrayFinished = [NSMutableArray array];
    }

    return _arrayFinished;
}

- (NSMutableArray *)arrayCancel
{
    if (!_arrayCancel)
    {
        _arrayCancel = [NSMutableArray array];
    }

    return _arrayCancel;
}

- (void)getAlarms
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;
    params[@"history"] = @"0";

    [[HttpClient sharedClient] post:@"getAlarmListByBranchId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.arrayAlarm removeAllObjects];
        [self.arrayAlarm addObjectsFromArray:responseObject[@"body"]];
        [self splitAlarm];
    }];
}

- (void)splitAlarm
{
    for (NSDictionary *alarm in self.arrayAlarm)
    {
        BOOL cancel = [alarm[@"isMisinformation"] boolValue];
        if (cancel)
        {
            [self.arrayCancel addObject:alarm];
        }
        else
        {
            NSInteger state = [alarm[@"state"] integerValue];

            if (0 == state)
            {
                [self.arrayReceived addObject:alarm];
            }
            else if (1 == state || 2 == state)
            {
                [self.arrayProcess addObject:alarm];
            }
            else
            {
                [self.arrayFinished addObject:alarm];
            }
        }
    }

    [self showTitleCount];
    [self markOnMap:self.arrayReceived];
}

- (void)showTitleCount
{
    NSString *received = [NSString stringWithFormat:@"待处理(%ld)", self.arrayReceived.count];
    [_titleView.btnNeed setTitle:received forState:UIControlStateNormal];

    NSString *process = [NSString stringWithFormat:@"救援中(%ld)", self.arrayProcess.count];
    [_titleView.btnSave setTitle:process forState:UIControlStateNormal];

    NSString *finish = [NSString stringWithFormat:@"已完成(%ld)", self.arrayFinished.count];
    [_titleView.btnFinish setTitle:finish forState:UIControlStateNormal];

    NSString *cancel = [NSString stringWithFormat:@"已撤销(%ld)", self.arrayCancel.count];
    [_titleView.btnRevoke setTitle:cancel forState:UIControlStateNormal];
}

- (void)markOnMap:(NSArray *)array
{
    _bottomView.hidden = YES;
    [_mapView removeAnnotations:[_mapView annotations]];

    for (NSInteger i = 0;
            i < array.count;
            i++)
    {
        NSDictionary *alarm = array[i];

        MaintAnnotation *ann = [[MaintAnnotation alloc] initWithLat:[alarm[@"lat"] floatValue] andLng:[alarm[@"lng"] floatValue]];

        ann.info = alarm;

        [_mapView addAnnotation:ann];
    }
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    MaintAnnotation *ann = (MaintAnnotation *) annotation;

    MaintAnnotationView *annView = (MaintAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:[MaintAnnotationView identifier]];

    if (!annView)
    {
        annView = [[MaintAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[MaintAnnotationView identifier]];
    }

    annView.info = ann.info;

    self.dicAnnView[ann.info[@"alarmId"]] = annView;

    return annView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [self resetAnnViewImage];

    MaintAnnotationView *annView = (MaintAnnotationView *) view;

    annView.image = [UIImage imageNamed:@"icon_project.png"];

    if (_bottomView.hidden)
    {
        _bottomView.hidden = NO;
    }

    _bottomView.lbProject.text = annView.info[@"communityName"];

    _bottomView.lbLift.text = [NSString stringWithFormat:@"%@号楼%@单元", annView.info[@"buildingCode"], annView.info[@"unitCode"]];

    _bottomView.lbProperty.text = [NSString stringWithFormat:@"地址:%@", annView.info[@"communityAddress"]];

    _bottomView.lbDate.text = [NSString stringWithFormat:@"报警时间:%@", annView.info[@"alarmTime"]];

    BOOL cancel = [annView.info[@"isMisinformation"] boolValue];

    if (cancel)
    {
        _bottomView.lbState.text = @"报警已经撤销";
    }
    else
    {
        NSInteger state = [annView.info[@"state"] integerValue];
        _bottomView.lbState.text = [self getStateDes:state];
    }
}

- (NSString *)getStateDes:(NSInteger)state
{
    switch (state)
    {
        case 0:
            return @"报警已接收";

        case 1:
            return @"报警已经指派";

        case 2:
            return @"工人已到达现场进行救援";

        case 3:
            return @"救援已经完成";

        case 5:
            return @"物业已经确认救援完成";
    }

    return @"";
}

- (void)resetAnnViewImage
{
    for (MaintAnnotationView *view in self.dicAnnView.allValues)
    {
        view.image = [UIImage imageNamed:@"icon_com_project.png"];
    }
}

#pragma mark - AlarmTitleViewDelegate

- (void)onClickNeed
{
    [self markOnMap:self.arrayReceived];
}

- (void)onClickSave
{
    [self markOnMap:self.arrayProcess];
}

- (void)onClickFinish
{
    [self markOnMap:self.arrayFinished];
}

- (void)onClickRevoke
{
    [self markOnMap:self.arrayCancel];
}

@end
