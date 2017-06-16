//
//  TrackingViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "TrackingViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HttpClient.h"
#import "UnderLineLabel.h"
#import "AppDelegate.h"
#import "ChatController.h"

@interface TrackingViewController () <BMKMapViewDelegate>
{
    IBOutlet BMKMapView *_mapView;
    BMKPointAnnotation *_alarmAnnotation;
}

@property (weak, nonatomic) IBOutlet UIView *viewTitle;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIButton *button_finish;

@property (weak, nonatomic) IBOutlet UILabel *currentState;

@property (weak, nonatomic) IBOutlet UILabel *labelStateLeft;

@property (weak, nonatomic) IBOutlet UILabel *labelWokerLeft;

@property (weak, nonatomic) IBOutlet UILabel *labelTelLeft;

@property (weak, nonatomic) IBOutlet UILabel *label_workerName;

@property (weak, nonatomic) IBOutlet UnderLineLabel *label_telphone;

@property (weak, nonatomic) IBOutlet UILabel *label_projectName;

@property (weak, nonatomic) IBOutlet UIView *viewInfo;


@property (nonatomic, strong) NSTimer *trackingTimer;

@property (nonatomic, weak) id <BMKOverlay> overLayer;


@property (nonatomic, strong) NSArray *workerInfo;

@property (nonatomic, strong) NSArray *noticedWorkers;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) NSMutableArray *noticedWorkerAnnotations;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;

@property NSInteger curSelect;

@end

@implementation TrackingViewController

- (void)dealloc
{

    if (self.trackingTimer)
    {
        [self.trackingTimer invalidate];
        self.trackingTimer = nil;
    }

    if (_mapView)
    {
        _mapView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];

    // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getAlarmInfo];

    //开启定时器
    self.trackingTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(getRepairListByAlarmId) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil

    //取消定时器
    [self.trackingTimer invalidate];
    self.trackingTimer = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //[self initTitle];
    [self setNavTitle:@"电梯报警"];
    [self initNavRight];

    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.zoomLevel = 15;

    self.curSelect = -1;

    self.annotations = [NSMutableArray arrayWithCapacity:1];


    //When enter the page, no worker is selected, so hidden the worker info

    _button_finish.hidden = YES;
    [self hideWorkerInfo:true];
}


- (void)initNavRight
{
    //设置标题栏右侧
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //[btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    //[btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //btnSubmit.titleLabel.font = [UIFont fontWithName:@"System" size:17];
    [btnSubmit setImage:[UIImage imageNamed:@"icon_bbs"] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)chat
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    ChatController *controller = [board instantiateViewControllerWithIdentifier:@"chat_controller"];
    controller.enterType = Enter_Property;
    [self.navigationController pushViewController:controller animated:YES];
}

//- (void)initTitle
//{
//    //set the background of the title view
//    UIColor *titleColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
//    [self.viewTitle setBackgroundColor:titleColor];
//    
//    //set back button
//    self.backImage.userInteractionEnabled = YES;
//    self.backImage.contentMode = UIViewContentModeScaleAspectFit;
//    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc]
//                                        initWithTarget:self action:@selector(dismis:)];
//    [self.backImage addGestureRecognizer:sigleTap];
//}

- (void)hideWorkerInfo:(BOOL)show
{
    self.labelStateLeft.hidden = show;

    self.currentState.hidden = show;

    self.labelWokerLeft.hidden = show;

    self.labelTelLeft.hidden = show;

    self.label_workerName.hidden = show;

    self.label_telphone.hidden = show;

    if (show)
    {
        self.infoViewHeight.constant = 35;
    }
    else
    {
        self.infoViewHeight.constant = 140;
    }
}


- (void)getAlarmInfo
{
    __weak TrackingViewController *weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.alarmId forKey:@"id"];

    [[HttpClient sharedClient] view:self.view post:@"getAlarmDetail" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *misInfo = [[responseObject objectForKey:@"body"] objectForKey:@"isMisinformation"];
        if ([misInfo isEqualToString:@"1"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"报警消息已经撤消!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];

        }
        else
        {
            NSDictionary *alarmInfo = [responseObject objectForKey:@"body"];
            //是否显示完成按钮
            if ([[alarmInfo objectForKey:@"state"] isEqualToString:@"3"])
            {
                weakSelf.button_finish.hidden = NO;
            }
            else
            {
                weakSelf.button_finish.hidden = YES;

                if ([[alarmInfo objectForKey:@"state"] isEqualToString:@"0"])
                {
                    weakSelf.currentState.text = @"任务指派中";
                    [weakSelf getNoticedWorkerInfo];
                }

            }

            weakSelf.label_projectName.text = [[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"name"];

            //标记报警位置
            float latitude = [[[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
            float longitude = [[[alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
            [weakSelf addAlarmAnnotationWithLat:latitude AndLng:longitude];

            //报警跟踪
            [weakSelf getRepairListByAlarmId];


            self.label_telphone.userInteractionEnabled = YES;
            UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call)];
            [self.label_telphone addGestureRecognizer:portraitTap];
            self.label_telphone.shouldUnderline = YES;

        }
    }];
}

- (IBAction)dismis:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  call the telphone
 */
- (void)call
{
    NSString *telstringTrim = [self.label_telphone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([telstringTrim isEqualToString:@""])
    {
        return;
    }
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", telstringTrim]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];

}

//请求推送完的维修工数量及位置
- (void)getNoticedWorkerInfo
{

    NSDictionary *dic =
            [NSDictionary dictionaryWithObject:self.alarmId forKey:@"alarmId"];
    __weak TrackingViewController *weakself = self;

    [[HttpClient sharedClient] post:@"getNearUserLocation"
                          parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                if ([responseObject objectForKey:@"body"])
                                {
                                    weakself.noticedWorkers = [NSArray arrayWithArray:[responseObject objectForKey:@"body"]];
                                    [weakself addNoticedWorkerAnnotations];
                                }
                            }];

}


//请求报警追踪
- (void)getRepairListByAlarmId
{

    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.alarmId forKey:@"alarmId"];

    __weak TrackingViewController *weakself = self;

    [[HttpClient sharedClient] post:@"getRepairListByAlarmId"
                          parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                //根据获取的报警跟踪信息显示数据
                                //[weakself addAlarmAnnotation];

                                if ([responseObject objectForKey:@"body"])
                                {
                                    weakself.workerInfo = [NSArray arrayWithArray:[responseObject objectForKey:@"body"]];
                                    [weakself addWorkersAnnotation];
                                }
                            }];

}

//显示所有推送的维修工的位置
- (void)addNoticedWorkerAnnotations
{

    //[_mapView removeOverlays:_mapView.overlays];

    self.noticedWorkerAnnotations = [NSMutableArray arrayWithCapacity:1];

    for (NSInteger i = 0;
            i < self.noticedWorkers.count;
            i++)
    {
        CLLocationCoordinate2D coor;
        coor.latitude = [[[self.noticedWorkers objectAtIndex:i] objectForKey:@"lat"] floatValue];
        coor.longitude = [[[self.noticedWorkers objectAtIndex:i] objectForKey:@"lng"] floatValue];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coor;

        [self.noticedWorkerAnnotations addObject:annotation];
    }

    [_mapView addAnnotations:self.noticedWorkerAnnotations];

    //NSMutableArray *array = [NSMutableArray arrayWithArray:self.noticedWorkerAnnotations];
    //[array addObject:_alarmAnnotation];

    //[_mapView showAnnotations:array animated:YES];
}

- (void)addAlarmAnnotationWithLat:(float)lat AndLng:(float)lng
{

    if (_alarmAnnotation.coordinate.latitude == lat
            && _alarmAnnotation.coordinate.longitude == lng)
    {
        return;
    }


    //[_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotation:_alarmAnnotation];

    if (nil == _alarmAnnotation)
    {
        _alarmAnnotation = [[BMKPointAnnotation alloc] init];
    }

    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    _alarmAnnotation.coordinate = coor;

    [_mapView addAnnotation:_alarmAnnotation];

    NSArray *array = [NSArray arrayWithObject:_alarmAnnotation];

    [_mapView showAnnotations:array animated:YES];

}

- (void)addWorkersAnnotation
{

    //clear the annotation previous
    [_mapView removeAnnotations:_annotations];
    [_annotations removeAllObjects];

    NSLog(@"worker count:%ld", _workerInfo.count);
    for (NSInteger i = 0;
            i < _workerInfo.count;
            i++)
    {
        NSDictionary *worker = [_workerInfo objectAtIndex:i];
        CLLocationCoordinate2D coor;
        coor.latitude = [[worker objectForKey:@"lat"] floatValue];
        coor.longitude = [[worker objectForKey:@"lng"] floatValue];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coor;
        annotation.title = @"点击查看详情";


        NSString *state = [self getDescriptionByState:[worker objectForKey:@"state"]];

        if (0 == state.length)
        {
            continue;
        }
        if (_curSelect == i)
        {
            _currentState.text = state;
        }

        [self.annotations addObject:annotation];
    }

    [_mapView addAnnotations:_annotations];
    //[_mapView showAnnotations:_annotations animated:YES];

    //NSMutableArray *array = [NSMutableArray arrayWithArray:self.annotations];
    //[array addObject:_alarmAnnotation];

    //[_mapView showAnnotations:array animated:YES];
}

- (IBAction)finishedAlarm:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.alarmId forKey:@"alarmId"];

    //确认救援完成
    [[HttpClient sharedClient] view:self.view post:@"propertyConfirmComplete" parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                //[weakSelf.delegate finishedAlarm];
                                [self.navigationController popViewControllerAnimated:YES];
                            }];

}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {

        if (annotation == _alarmAnnotation)
        {
            BMKAnnotationView *alarmAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"alarmAnnotation"];
            [alarmAnnotationView setBounds:CGRectMake(0.f, 0.f, 20.f, 25.f)];
            [alarmAnnotationView setBackgroundColor:[UIColor clearColor]];
            alarmAnnotationView.image = [UIImage imageNamed:@"icon_annotation_alarm.png"];

            return alarmAnnotationView;
        }

        BMKAnnotationView *alarmAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"workerAnnotation"];
        [alarmAnnotationView setBounds:CGRectMake(0.f, 0.f, 20.f, 25.f)];
        [alarmAnnotationView setBackgroundColor:[UIColor clearColor]];
        UIImageView *annotationImageView = [[UIImageView alloc] initWithFrame:alarmAnnotationView.bounds];
        annotationImageView.contentMode = UIViewContentModeScaleAspectFit;


        for (BMKPointAnnotation *annotation1 in self.annotations)
        {

            if (annotation1 == annotation)
            {
                NSInteger index = [self.annotations indexOfObject:annotation];
                NSDictionary *dic = [self.workerInfo objectAtIndex:index];
                if ([[dic objectForKey:@"state"] isEqualToString:@"1"])
                {
                    if (index == self.curSelect)
                    {
                        [annotationImageView setImage:[UIImage imageNamed:@"marker_selected"]];
                    }
                    else
                    {
                        [annotationImageView setImage:[UIImage imageNamed:@"marker_worker"]];
                    }

                }
                else if ([[dic objectForKey:@"state"] isEqualToString:@"2"] || [[dic objectForKey:@"state"] isEqualToString:@"3"])
                {
                    if (index == self.curSelect)
                    {
                        [annotationImageView setImage:[UIImage imageNamed:@"marker_selected"]];
                    }
                    else
                    {
                        [annotationImageView setImage:[UIImage imageNamed:@"marker_worker_arrived"]];
                    }
                }


            }
        }

        [alarmAnnotationView addSubview:annotationImageView];
        return alarmAnnotationView;
    }
    return nil;

}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //[_mapView removeOverlays:_mapView.overlays];

    for (int i = 0;
            i < self.annotations.count;
            i++)
    {
        BMKPointAnnotation *annotation = [self.annotations objectAtIndex:i];
        if (view.annotation == annotation)
        {
            //设置选中的状态
            NSDictionary *worker = [self.workerInfo objectAtIndex:i];

            self.curSelect = i;


//            NSArray *subviews = [view subviews];
//            for (int j = 0; j < subviews.count; j++)
//            {
//                [subviews[j] removeFromSuperview];
//            }
//
//            UIImageView *annotationImageView  = [[UIImageView alloc] initWithFrame:view.bounds];
//            [annotationImageView setImage:[UIImage imageNamed:@"marker_selected"]];
//            [view addSubview:annotationImageView];


            [self hideWorkerInfo:false];
            self.label_workerName.text = [worker objectForKey:@"name"];
            self.label_telphone.text = [worker objectForKey:@"tel"];

            //set the worker state
            if ([[worker objectForKey:@"state"] isEqualToString:@"0"])
            {
                self.currentState.text = @"指派中";

            }
            else if ([[worker objectForKey:@"state"] isEqualToString:@"1"])
            {
                self.currentState.text = @"已出发";

            }
            else if ([[worker objectForKey:@"state"] isEqualToString:@"2"])
            {
                self.currentState.text = @"已到达";

            }
            else if ([[worker objectForKey:@"state"] isEqualToString:@"3"])
            {
                self.currentState.text = @"已完成";

            }


            //show the trace if the worker does not arrive
            if ([[worker objectForKey:@"state"] isEqualToString:@"1"])
            {
                NSArray *points = [worker objectForKey:@"points"];

                if (points && points.count > 0)
                {
                    CLLocationCoordinate2D coors[points.count];

                    for (NSInteger j = 0;
                            j < points.count;
                            j++)
                    {
                        CLLocationCoordinate2D coor;
                        coor.latitude = [[points[j] objectForKey:@"lat"] floatValue];
                        coor.longitude = [[points[j] objectForKey:@"lng"] floatValue];
                        coors[j] = coor;
                    }

                    BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:coors count:points.count];
                    [_mapView addOverlay:polyLine];
                }
            }
        }
    }
    [self addWorkersAnnotation];
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    for (BMKPointAnnotation *annotation in self.annotations)
    {

        if (view.annotation == annotation)
        {
            NSInteger index = [self.annotations indexOfObject:annotation];

            //界面上更新数据
            NSDictionary *dic = [self.workerInfo objectAtIndex:index];


            self.label_workerName.text = [dic objectForKey:@"name"];
            self.label_telphone.text = [dic objectForKey:@"tel"];

            self.infoViewHeight.constant = 130;

            //设置报警状态描述
            if ([[dic objectForKey:@"state"] isEqualToString:@"0"])
            {
                self.currentState.text = @"指派中";

            }
            else if ([[dic objectForKey:@"state"] isEqualToString:@"1"])
            {
                self.currentState.text = @"已出发";

            }
            else if ([[dic objectForKey:@"state"] isEqualToString:@"2"])
            {
                self.currentState.text = @"已到达";

            }
            else if ([[dic objectForKey:@"state"] isEqualToString:@"3"])
            {
                self.currentState.text = @"已完成";

            }


//            CLLocationCoordinate2D coors[2] = {0};
//            coors[0].latitude = 39.315;
//            coors[0].longitude = 116.304;
//            coors[1].latitude = 39.515;
//            coors[1].longitude = 116.504;
//            BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
//            [_mapView addOverlay:polyline];
//            

            //显示轨迹
            NSArray *array = [dic objectForKey:@"points"];


            if (array && array.count > 0)
            {
                // NSMutableArray *newA = [NSMutableArray arrayWithCapacity:1];


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

            return;
        }

    }

}

// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        [mapView removeOverlay:self.overLayer];

        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = UIColorFromRGB(0x25b6ed);
        polylineView.lineDash = YES;
        polylineView.lineWidth = 4.0;

        self.overLayer = overlay;

        return polylineView;
    }
    return nil;
}


/**
 *  根据维修工的状态码返回状态描述
 *
 *  @param state <#state description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)getDescriptionByState:(NSString *)state
{

    NSString *result = @"";
    //设置报警状态描述
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
        result = @"已完成";
    }

    return result;
}

@end
