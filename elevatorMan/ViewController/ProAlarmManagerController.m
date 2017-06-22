//
//  ProAlarmManagerController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/4.
//
//

#import <Foundation/Foundation.h>
#import "ProAlarmManagerController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HttpClient.h"
#import "location.h"
#import "ChatController.h"

#define TABLE_ALARM 10001
#define TABLE_WORKER 10002

#pragma mark - WorkerCell

@interface WorkerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (weak, nonatomic) IBOutlet UILabel *lbState;


@end

@implementation WorkerCell


@end


#pragma mark - ProAlarmCell

@interface ProAlarmCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbState;

@end

@implementation ProAlarmCell


@end

#pragma mark - ProAlarmManagerController


@interface ProAlarmManagerController () <UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableAlarm;

@property (weak, nonatomic) IBOutlet UITableView *tableWorker;

@property (strong, nonatomic) NSMutableArray *arrayAlarm;

@property (strong, nonatomic) NSMutableArray *arrayWorker;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) NSDictionary *curAlarm;

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (strong, nonatomic) NSMutableArray *arrayMarker;

@property (nonatomic, weak) id <BMKOverlay> overLayer;


@end

@implementation ProAlarmManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"救援管理"];
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_bbs"]];
}

- (void)initData
{
    _arrayAlarm = [NSMutableArray array];
    _arrayWorker = [NSMutableArray array];
    _arrayMarker = [NSMutableArray array];
    [self getAlarmList];
}

- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomEnabled = YES;
    _mapView.zoomLevel = 15;

    _tableAlarm.bounces = NO;
    _tableAlarm.delegate = self;
    _tableAlarm.dataSource = self;
    _tableAlarm.tag = TABLE_ALARM;

    _tableWorker.bounces = NO;
    _tableWorker.delegate = self;
    _tableWorker.dataSource = self;
    _tableWorker.tag = TABLE_WORKER;
}

#pragma mark - Network Request

- (void)getAlarmList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"unfinished" forKey:@"scope"];

    __weak ProAlarmManagerController *weakSelf = self;

    [[HttpClient sharedClient] post:@"getAlarmListByUserId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.arrayAlarm removeAllObjects];
        [weakSelf.arrayAlarm addObjectsFromArray:[responseObject objectForKey:@"body"]];
        if (0 == weakSelf.arrayAlarm.count)
        {
            [self showMsgAlert:@"暂无正在进行中的报警"];
            weakSelf.tableAlarm.hidden = YES;
            weakSelf.tableWorker.hidden = YES;
            weakSelf.btnConfirm.hidden = YES;
        }
        else
        {

            weakSelf.tableAlarm.hidden = NO;
            weakSelf.tableWorker.hidden = NO;
            weakSelf.btnConfirm.hidden = YES;

            [weakSelf.tableAlarm reloadData];

            [weakSelf.tableAlarm selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self setAlarmSelectInfo:0];
        }

    }];
}

- (void)getAlarmInfo:(NSString *)alarmId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:alarmId forKey:@"alarmId"];

    __weak ProAlarmManagerController *weakSelf = self;

    [[HttpClient sharedClient] view:self.view post:@"getRepairListByAlarmId" parameter:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.arrayWorker removeAllObjects];
        [weakSelf.arrayWorker addObjectsFromArray:[responseObject objectForKey:@"body"]];
        [self markMap];
        [weakSelf.tableWorker reloadData];

        if (weakSelf.arrayWorker.count > 0)
        {
            [weakSelf.tableWorker selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self setWorkerSelectInfo:0];
        }

    }];
}

#pragma makr - mark worker and alarm

- (void)markMap
{
    [_mapView removeAnnotations:[_mapView annotations]];

    for (NSInteger i = 0;
            i < _arrayWorker.count;
            i++)
    {
        CLLocationCoordinate2D workerCoor;
        NSDictionary *workerInfo = _arrayWorker[i];
        workerCoor.latitude = [[workerInfo objectForKey:@"lat"] floatValue];
        workerCoor.longitude = [[workerInfo objectForKey:@"lng"] floatValue];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = workerCoor;
        annotation.title = @"worker";
        [_arrayMarker addObject:annotation];
    }

    [_mapView addAnnotations:_arrayMarker];


    //标记报警
    CLLocationCoordinate2D alarmCoor;
    alarmCoor.latitude = [[[_curAlarm objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
    alarmCoor.longitude = [[[_curAlarm objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];


    BMKPointAnnotation *alarmAnnotation = [[BMKPointAnnotation alloc] init];
    alarmAnnotation.coordinate = alarmCoor;
    alarmAnnotation.title = @"alarm";
    [_mapView addAnnotation:alarmAnnotation];
    [_mapView showAnnotations:[NSArray arrayWithObjects:alarmAnnotation, nil] animated:YES];

}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (TABLE_ALARM == tableView.tag)
    {

        NSLog(@"count:%ld", _arrayAlarm.count);
        return _arrayAlarm.count;
    }
    else if (TABLE_WORKER == tableView.tag)
    {
        return _arrayWorker.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (TABLE_ALARM == tableView.tag)
    {
        NSDictionary *alarmInfo = [_arrayAlarm objectAtIndex:indexPath.row];
        ProAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pro_alarm_cell"];

        cell.lbTime.text = [alarmInfo objectForKey:@"alarmTime"];
        cell.lbAddress.text = [[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"name"];

        NSString *state = [alarmInfo objectForKey:@"state"];
        cell.lbState.text = [self getAlarmDescriptionByState:state];

        return cell;
    }
    else if (TABLE_WORKER == tableView.tag)
    {
        NSDictionary *workerInfo = _arrayWorker[indexPath.row];
        WorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pro_worker_cell"];

        cell.lbName.text = [workerInfo objectForKey:@"name"];
        cell.lbTel.text = [workerInfo objectForKey:@"tel"];

        cell.lbState.text = [self getWorkerDescriptionByState:[workerInfo objectForKey:@"state"]];

        CLLocationCoordinate2D alarmCoor;
        alarmCoor.latitude = [[[_curAlarm objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
        alarmCoor.longitude = [[[_curAlarm objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];


        CLLocationCoordinate2D workerCoor;
        workerCoor.latitude = [[workerInfo objectForKey:@"lat"] floatValue];
        workerCoor.longitude = [[workerInfo objectForKey:@"lng"] floatValue];

        NSInteger distance = (NSInteger) BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(alarmCoor),
                BMKMapPointForCoordinate(workerCoor));
        cell.lbDistance.text = [NSString stringWithFormat:@"%ld米", distance];

        return cell;
    }

    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (TABLE_ALARM == tableView.tag)
    {
        [self setAlarmSelectInfo:indexPath.row];
    }
    else if (TABLE_WORKER == tableView.tag)
    {
        [self setWorkerSelectInfo:indexPath.row];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (TABLE_ALARM == tableView.tag)
    {
        return 64;
    }
    else if (TABLE_WORKER == tableView.tag)
    {
        return 60;
    }

    return 44;
}

- (NSString *)getAlarmDescriptionByState:(NSString *)alarmState
{
    NSString *result = @"";
    if ([alarmState isEqualToString:@"0"])
    {
        result = @"指派中";
    }
    else if ([alarmState isEqualToString:@"1"])
    {
        result = @"已出发";
    }
    else if ([alarmState isEqualToString:@"2"])
    {
        result = @"已到达";

    }
    else if ([alarmState isEqualToString:@"3"])
    {
        result = @"已完成";
    }

    return result;

}


- (NSString *)getWorkerDescriptionByState:(NSString *)state
{
    NSString *result = @"";

    if ([state isEqualToString:@"0"])
    {
        result = @"指派中";
    }
    else if ([state isEqualToString:@"1"])
    {
        result = @"已出发";
    }
    else if ([state isEqualToString:@"2"])
    {
        result = @"已到达";
    }
    else if ([state isEqualToString:@"3"])
    {
        result = @"点击确认完成";
    }

    return result;
}

- (void)setAlarmSelectInfo:(NSInteger)index
{
    _curAlarm = _arrayAlarm[index];
    NSString *state = [_curAlarm objectForKey:@"state"];

    [self getAlarmInfo:[_curAlarm objectForKey:@"id"]];

    _btnConfirm.hidden = YES;

    if ([state isEqualToString:@"3"])
    {
        _tableWorker.hidden = YES;
        _btnConfirm.hidden = NO;
        _btnConfirm.tag = index;
        [_btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([state isEqualToString:@"0"])
    {
        _tableWorker.hidden = YES;
        _btnConfirm.hidden = YES;
    }
    else
    {
        _tableWorker.hidden = NO;
        _btnConfirm.hidden = YES;

        [self getAlarmInfo:[_curAlarm objectForKey:@"id"]];
    }
}

- (void)confirm
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[_curAlarm objectForKey:@"id"] forKey:@"alarmId"];

    //确认救援完成
    [[HttpClient sharedClient] view:self.view post:@"propertyConfirmComplete" parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                [HUDClass showHUDWithLabel:@"救援已经确认完成" view:self.view];

                                [self getAlarmList];
                            }];
}

- (void)setWorkerSelectInfo:(NSInteger)index
{
    [_mapView removeAnnotation:_arrayMarker[index]];

    NSDictionary *workerInfo = _arrayWorker[index];

    CLLocationCoordinate2D workerCoor;
    workerCoor.latitude = [[workerInfo objectForKey:@"lat"] floatValue];
    workerCoor.longitude = [[workerInfo objectForKey:@"lng"] floatValue];

    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = workerCoor;
    annotation.title = @"worker_sel";
    [_arrayMarker addObject:annotation];


    //显示轨迹
    NSArray *array = [workerInfo objectForKey:@"points"];

    if (array && array.count > 0)
    {
        CLLocationCoordinate2D coor[array.count];

        for (NSInteger i = 0;
                i < array.count;
                i++)
        {
            CLLocationCoordinate2D cor;
            cor.latitude = [[array[i] objectForKey:@"lat"] floatValue];
            cor.longitude = [[array[i] objectForKey:@"lng"] floatValue];
            coor[i] = cor;
        }

        BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coor count:array.count];
        [_mapView addOverlay:polyline];
    }


}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKAnnotationView *marker = [mapView dequeueReusableAnnotationViewWithIdentifier:@"marker"];
        if (nil == marker)
        {
            marker = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"marker"];
        }
        [marker setBounds:CGRectMake(0, 0, 30, 30)];
        [marker setBackgroundColor:[UIColor clearColor]];

        NSString *title = annotation.title;

        NSLog(@"annotation title:%@", title);
        if ([title isEqualToString:@"alarm"])
        {
            marker.image = [UIImage imageNamed:@"icon_alarm"];
        }
        else
        {
            marker.image = [UIImage imageNamed:@"marker_worker"];
        }
        return marker;
    }

    return nil;
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        if (_overLayer)
        {
            [mapView removeOverlay:_overLayer];
        }

        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = UIColorFromRGB(0x25b6ed);
        polylineView.lineDash = YES;
        polylineView.lineWidth = 4.0;

        _overLayer = overlay;

        return polylineView;
    }
    return nil;
}

@end
