//
//  AlarmReceivedViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/24.
//
//

#import <Foundation/Foundation.h>
#import "AlarmReceivedViewController.h"
#import "HttpClient.h"
#import "AlarmProcessViewController.h"
#import "../../../chorstar/chorstar/Chorstar.h"
#import <BaiduMapAPI/BMapKit.h>
#import "CalloutAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "location.h"
#import "Utils.h"


@interface AlarmInfo ()

@end

@implementation AlarmInfo


@end


#pragma mark -- AlarmCell

@interface AlarmCell ()

@end

@implementation AlarmCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.labelIndex.layer.masksToBounds = YES;
    self.labelIndex.layer.cornerRadius = self.labelIndex.frame.size.height / 2;
}

- (void)setColorWithIndex:(NSInteger)index
{
    switch (index % 8)
    {
        case 0:
        {
            self.labelIndex.backgroundColor = UIColorFromRGB(0xffbeee78);
            break;
        }
        case 1:
        {
            self.labelIndex.backgroundColor = UIColorFromRGB(0xffebe084);
            break;
        }
        case 2:
        {
            self.labelIndex.backgroundColor = UIColorFromRGB(0xffbecccb);
            break;
        }
        case 3:
        {
            self.labelIndex.backgroundColor = UIColorFromRGB(0xffb2f4b1);
            break;
        }
        case 4:
        {
            self.labelIndex.backgroundColor = UIColorFromRGB(0xffb6b6fc);
            break;
        }
        case 5:
        {
            self.labelIndex.backgroundColor = UIColorFromRGB(0xfffecb236);
            break;
        }
        case 6:
        {
            self.labelIndex.backgroundColor = UIColorFromRGB(0xff99cdff);
            break;
        }
        case 7:
        {
            self.labelIndex.backgroundColor = UIColorFromRGB(0xff4aeab7);
            break;
        }


        default:
            break;
    }

}

@end

#pragma mark -- AlarmInfo


#pragma mark - AlarmCell

@interface AlarmReceiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end

@implementation AlarmReceiveCell


@end


#pragma mark -- AlarmReceivedViewController

@interface AlarmReceivedViewController () <BMKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *mAlarmArray;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) CalloutAnnotationView *calloutView;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

//@property (strong, nonatomic) NSArray *alarmArray;

@property (strong, nonatomic) BMKPointAnnotation *annotaion;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbElevator;

@property (weak, nonatomic) IBOutlet UIButton *btnTel;

@property (weak, nonatomic) IBOutlet UIButton *btnAccept;

@property (weak, nonatomic) IBOutlet UIView *viewInfo;

@property (strong, nonatomic) BMKPointAnnotation *workerAnnotation;

@property (strong, nonatomic) CalloutMapAnnotation *alarmAnnotation;


@end


@implementation AlarmReceivedViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    _mAlarmArray = [[NSMutableArray alloc] init];
    [self initView];
    [self setNavTitle:@"应急救援"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView setZoomLevel:15];
    [_mapView setMinZoomLevel:10];
    [_mapView setMaxZoomLevel:20];

    [self getAlarmInfo];

    //监听定位信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivedLocation) name:@"userLocationUpdate"

                                               object:nil];
    //刚进入时进行定位
    [[location sharedLocation] startLocationService];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getAlarmInfo
{
    //定位成功再请求报警信息
    __weak AlarmReceivedViewController *weakSelf = self;
    [[HttpClient sharedClient] view:self.view post:@"getAlarmListByReceiveAndUnassign" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSArray *body = [responseObject objectForKey:@"body"];

                                [_mAlarmArray removeAllObjects];

                                //the data received from server is too much, abandon others
                                if (body && body.count > 0)
                                {
                                    for (NSDictionary *dic in body)
                                    {
                                        [weakSelf.mAlarmArray addObject:dic];
                                    }

                                    //请求完报警信息，进行定位
                                    _viewInfo.hidden = NO;
                                    _tableView.hidden = NO;
                                    [_tableView reloadData];

                                    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                                    [self setSelectInfo:_mAlarmArray[0] index:0];

                                    [[location sharedLocation] startLocationService];
                                    //[weakSelf showAlarms];
                                }

                            }];
}

- (void)onReceivedLocation
{

    //显示维修工位置

    if (_workerAnnotation != nil)
    {
        [_mapView removeAnnotation:_workerAnnotation];
    }

    _workerAnnotation = [[BMKPointAnnotation alloc] init];
    _workerAnnotation.coordinate = [location sharedLocation].userLocation.location.coordinate;
    [_mapView addAnnotation:_workerAnnotation];
    [_mapView showAnnotations:[[NSArray alloc] initWithObjects:_workerAnnotation, nil] animated:YES];


//    if (_mAlarmArray.count > 0)
//    {
//        [self showAlarms];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)initView
{
    _mapView.delegate = self;

    [_locationBtn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];

    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.hidden = YES;
    _viewInfo.hidden = YES;

    _btnAccept.layer.masksToBounds = YES;
    _btnAccept.layer.cornerRadius = 3;
    _btnAccept.layer.borderWidth = 1;
    _btnAccept.layer.borderColor = [Utils getColorByRGB:@"#007e5c"].CGColor;
}

- (void)location
{
    [[location sharedLocation] startLocationService];
}

- (void)showAlarms
{
    for (int i = 0;
            i < _mAlarmArray.count;
            i++)
    {
        CGFloat lat = [[[_mAlarmArray[i] objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
        CGFloat lng = [[[_mAlarmArray[i] objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];

        CalloutMapAnnotation *marker = [[CalloutMapAnnotation alloc] init];
        marker.latitude = lat;
        marker.longitude = lng;
        marker.info = _mAlarmArray[i];
        [_mapView addAnnotation:marker];
    }
}

- (AlarmInfo *)alarmReceivedFromDic:(NSDictionary *)dicInfo
{
    AlarmInfo *alarmInfo = [[AlarmInfo alloc] init];
    NSDictionary *community = [dicInfo objectForKey:@"communityInfo"];

    if (community)
    {
        alarmInfo.project = [community objectForKey:@"name"];
    }
    alarmInfo.alarmId = [dicInfo objectForKey:@"id"];
    alarmInfo.date = [dicInfo objectForKey:@"alarmTime"];
    alarmInfo.userState = 0;

    return alarmInfo;
}


#pragma mark -- BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKAnnotationView *marker = [mapView dequeueReusableAnnotationViewWithIdentifier:@"worker"];
        if (nil == marker)
        {
            marker = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"worker"];
        }
        [marker setBounds:CGRectMake(0, 0, 30, 30)];
        [marker setBackgroundColor:[UIColor clearColor]];
        marker.image = [UIImage imageNamed:@"marker_worker"];
        return marker;
    }
    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        //CalloutMapAnnotation *ann = (CalloutMapAnnotation *)annotation;

        CalloutAnnotationView *calloutView = (CalloutAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];

        if (nil == calloutView)
        {
            calloutView = [[CalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
        }

//        NSInteger distance = (NSInteger)[[location sharedLocation] handleDistance:ann.coordinate];
//        
//        NSDictionary *community = [ann.info objectForKey:@"communityInfo"];
//        
//        calloutView.alarmInfoView.projectLabel.text = [community objectForKey:@"name"];
//        
//        NSDictionary *elevatorInfo = [ann.info objectForKey:@"elevatorInfo"];
//        
//        NSString *address = [community objectForKey:@"address"];
//        
//        NSString *buildingCode = [elevatorInfo objectForKey:@"buildingCode"];
//        NSString *unitCode = [elevatorInfo objectForKey:@"unitCode"];
//        NSString *liftNum = [elevatorInfo objectForKey:@"liftNum"];
//        NSString *elevator = [NSString stringWithFormat:@"%@%@号楼%@单元%@号电梯", address, buildingCode, unitCode, liftNum];
//        calloutView.alarmInfoView.addressLabel.text = elevator;
//        
//        NSString *dis = @"--";
//        if (distance > 1000)
//        {
//            CGFloat km = distance / 1000.0;
//            dis = [NSString stringWithFormat:@"%.3lf公里", km];
//        }
//        else if (distance > 0)
//        {
//            dis = [NSString stringWithFormat:@"%ld米", distance];
//        }
//        calloutView.alarmInfoView.distanceLabel.text = dis;
//        calloutView.alarmInfoView.projectLabel.text = [community objectForKey:@"propertyUtel"];
//        
//        calloutView.alarmInfoView.alarmId = [ann.info objectForKey:@"id"];
//        
//        calloutView.alarmInfoView.distance = distance;
//        
//        __weak typeof(self) weakSelf = self;
//        [calloutView.alarmInfoView onClickConfirm:^(NSString *alarmId, NSInteger distance) {
//            NSLog(@"accetp alarm:%@", alarmId);
//            NSLog(@"distance:%ld", distance);
//            
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            
//            [dic setObject:alarmId forKey:@"alarmId"];
//            [dic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:distance]] forKey:@"distance"];
//            
//            [[HttpClient sharedClient] view:self.view post:@"userAcceptAlarm" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                //[HUDClass showHUDWithLabel:@"已接单成功，请等待系统分配" view:self.view];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经接单成功，请等待系统指派" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//                
//            }  failed:^(id responseObject) {
//                //[self onReceiveAlarmCancelMessage];
//                //[HUDClass showHUDWithLabel:@"该报警任务已经被撤消,感谢您的参与!" view:self.view];
//                NSString *rspMsg = [[responseObject objectForKey:@"head"]objectForKey:@"rspMsg"];
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rspMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//                
//            }];
//        }];
//        
//        [calloutView.alarmInfoView onClickTel:^(NSString *tel) {
//            NSLog(@"tel:%@", tel);
//            
//            if (0 == tel.length)
//            {
//                [HUDClass showHUDWithLabel:@"非法的手机号码,无法拨打!" view:weakSelf.view];
//                return;
//            }
//            
//            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
//            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//            [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//            [weakSelf.view addSubview:webView];
//            
//        }];
        return calloutView;

    }

    return nil;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//    CalloutAnnotationView *calloutView = (CalloutAnnotationView *)view;
//    
//    if (_calloutView == calloutView)
//    {
//        return;
//    }
//    
//    if (nil == _calloutView)
//    {
//        _calloutView = calloutView;
//        [_calloutView showInfoWindow];
//    }
//    else
//    {
//        [_calloutView hideInfoWindow];
//        _calloutView = calloutView;
//        [_calloutView showInfoWindow];
//    }


}

//- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
//{
//    NSLog(@"deselection");
//    if (nil == _calloutView)
//    {
//        return;
//    }
//   
//    _calloutView.alarmInfoView.hidden = YES;
//    _calloutView = nil;
//}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (nil == _calloutView)
    {
        return;
    }

    [_calloutView hideInfoWindow];
    _calloutView = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mAlarmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alarm_receive_cell"];

    if (nil == cell)
    {
        cell = [[AlarmReceiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alarm_receive_cell"];
    }


    cell.lbContent.text = [[_mAlarmArray[indexPath.row] objectForKey:@"communityInfo"] objectForKey:@"name"];
//    NSDictionary *community = [_mAlarmArray[indexPath.row] objectForKey:@"communityInfo"];
//    
//    NSString *address = [community objectForKey:@"address"];
//    
//    NSDictionary *elevatorInfo = [_mAlarmArray[indexPath.row] objectForKey:@"elevatorInfo"];
//    NSString *buildingCode = [elevatorInfo objectForKey:@"buildingCode"];
//    NSString *unitCode = [elevatorInfo objectForKey:@"unitCode"];
//    NSString *liftNum = [elevatorInfo objectForKey:@"liftNum"];
//    
//    
//    //报警类型 1:电梯报警 2:项目报警
//    NSString *alarmType = [_mAlarmArray[indexPath.row] objectForKey:@"type"];
//    
//    if ([alarmType isEqualToString:@"1"])
//    {
//        NSString *elevator = [NSString stringWithFormat:@"%@%@号楼%@单元%@号电梯", address, buildingCode, unitCode, liftNum];
//        cell.lbContent.text = [NSString stringWithFormat:@"%@", elevator];
//    }
//    else if ([alarmType isEqualToString:@"2"])
//    {
//        cell.lbContent.text = [NSString stringWithFormat:@"%@", address];;
//    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self setSelectInfo:_mAlarmArray[indexPath.row] index:indexPath.row];

//    CGFloat lat = [[[_mAlarmArray[indexPath.row] objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
//    CGFloat lng = [[[_mAlarmArray[indexPath.row] objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
//    
//    CalloutMapAnnotation *marker = [[CalloutMapAnnotation alloc] init];
//    marker.latitude = lat;
//    marker.longitude = lng;
//    //marker.info = _mAlarmArray[i];
//    [_mapView addAnnotation:marker];
//    
//    //设置信息
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
//    NSInteger distance = (NSInteger)[[location sharedLocation] handleDistance:coordinate];
//    
//    NSDictionary *community = [_mAlarmArray[indexPath.row] objectForKey:@"communityInfo"];
//    NSString *project = [community objectForKey:@"name"];
//    _lbProject.text = project;
//    
//    NSDictionary *elevatorInfo = [_mAlarmArray[indexPath.row] objectForKey:@"elevatorInfo"];
//    
//    NSString *address = [community objectForKey:@"address"];
//    
//    NSString *buildingCode = [elevatorInfo objectForKey:@"buildingCode"];
//    NSString *unitCode = [elevatorInfo objectForKey:@"unitCode"];
//    NSString *liftNum = [elevatorInfo objectForKey:@"liftNum"];
//    NSString *elevator = [NSString stringWithFormat:@"%@%@号楼%@单元%@号电梯", address, buildingCode, unitCode, liftNum];
//    _lbAddress.text = elevator;
//    
//    NSString *dis = @"--";
//    if (distance > 1000)
//    {
//        CGFloat km = distance / 1000.0;
//        dis = [NSString stringWithFormat:@"%.3lf公里", km];
//    }
//    else if (distance > 0)
//    {
//        dis = [NSString stringWithFormat:@"%ld米", distance];
//    }
//    _lbDistance.text = dis;
//    
//    _lbTel.text = [community objectForKey:@"propertyUtel"];
//    
//    
//    _btnTel.tag = indexPath.row;
//
//    _btnTel.tag = indexPath.row;
//    
//    
//    [_btnAccept addTarget:self action:@selector(acceptAlarm:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_btnTel addTarget:self action:@selector(dial:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setSelectInfo:(NSDictionary *)alarmInfo index:(NSInteger)index
{

    if (_alarmAnnotation != nil)
    {
        [_mapView removeAnnotation:_alarmAnnotation];
    }
    CGFloat lat = [[[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
    CGFloat lng = [[[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];

    _alarmAnnotation = [[CalloutMapAnnotation alloc] init];
    _alarmAnnotation.latitude = lat;
    _alarmAnnotation.longitude = lng;

    [_mapView addAnnotation:_alarmAnnotation];
    [_mapView showAnnotations:[NSArray arrayWithObjects:_alarmAnnotation, nil] animated:YES];

    //设置信息
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
    NSInteger distance = (NSInteger) [[location sharedLocation] handleDistance:coordinate];

    NSDictionary *community = [alarmInfo objectForKey:@"communityInfo"];
    NSString *project = [community objectForKey:@"name"];
    _lbProject.text = [NSString stringWithFormat:@"报警时间: %@", [alarmInfo objectForKey:@"alarmTime"]];

    NSDictionary *elevatorInfo = [alarmInfo objectForKey:@"elevatorInfo"];

    NSString *address = [community objectForKey:@"address"];

    NSString *buildingCode = [elevatorInfo objectForKey:@"buildingCode"];
    NSString *unitCode = [elevatorInfo objectForKey:@"unitCode"];
    NSString *liftNum = [elevatorInfo objectForKey:@"liftNum"];


    //报警类型 1:电梯报警 2:项目报警
    NSString *alarmType = [alarmInfo objectForKey:@"type"];

    if ([alarmType isEqualToString:@"1"])
    {
        NSString *elevator = [NSString stringWithFormat:@"%@%@号楼%@单元%@号电梯", address, buildingCode, unitCode, liftNum];
        _lbAddress.text = [NSString stringWithFormat:@"项目地址: %@", elevator];
    }
    else if ([alarmType isEqualToString:@"2"])
    {
        _lbAddress.text = [NSString stringWithFormat:@"项目地址: %@", address];;
    }

    NSString *brand = [elevatorInfo objectForKey:@"brand"];
    NSString *elevatorType = [elevatorInfo objectForKey:@"elevatorType"];
    NSString *saveNumber = [elevatorInfo objectForKey:@"number"];

    if ([alarmType isEqualToString:@"1"])
    {
        NSString *info = [NSString stringWithFormat:@"电梯信息: 救援码-%@ 品牌-%@ 梯型-%@", saveNumber, brand, elevatorType];
        _lbElevator.text = info;
    }
    else if ([alarmType isEqualToString:@"2"])
    {
        _lbElevator.text = @"电梯信息: 暂无电梯相关信息";
    }


    NSString *dis = @"--";
    if (distance > 1000)
    {
        CGFloat km = distance / 1000.0;
        dis = [NSString stringWithFormat:@"%.3lf公里", km];
    }
    else if (distance > 0)
    {
        dis = [NSString stringWithFormat:@"%ld米", distance];
    }
    _lbDistance.text = [NSString stringWithFormat:@"项目距离 %@", dis];

    _lbTel.text = [NSString stringWithFormat:@"物业电话 %@", [community objectForKey:@"propertyUtel"]];


    _btnTel.tag = index;

    _btnTel.tag = index;


    [_btnAccept addTarget:self action:@selector(acceptAlarm:) forControlEvents:UIControlEventTouchUpInside];

    [_btnTel addTarget:self action:@selector(dial:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)acceptAlarm:(UIButton *)sender
{

    NSInteger index = sender.tag;
    NSDictionary *alarmInfo = _mAlarmArray[index];


    CGFloat lat = [[[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
    CGFloat lng = [[[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];

    //设置信息
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
    NSInteger distance = (NSInteger) [[location sharedLocation] handleDistance:coordinate];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    [dic setObject:[alarmInfo objectForKey:@"id"] forKey:@"alarmId"];
    [dic setObject:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:distance]] forKey:@"distance"];

    [[HttpClient sharedClient] view:self.view post:@"userAcceptAlarm" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        //[HUDClass showHUDWithLabel:@"已接单成功，请等待系统分配" view:self.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经接单成功，请等待系统指派" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }                        failed:^(id responseObject) {
        //[self onReceiveAlarmCancelMessage];
        //[HUDClass showHUDWithLabel:@"该报警任务已经被撤消,感谢您的参与!" view:self.view];
        NSString *rspMsg = [[responseObject objectForKey:@"head"] objectForKey:@"rspMsg"];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rspMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }];
}

- (void)dial:(UIButton *)sender
{

    NSInteger index = sender.tag;
    NSDictionary *alarmInfo = _mAlarmArray[index];

    NSString *tel = [[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"propertyUtel"];
    if (0 == tel.length)
    {
        [HUDClass showHUDWithLabel:@"非法的手机号码,无法拨打!" view:self.view];
        return;
    }

    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
}

@end
