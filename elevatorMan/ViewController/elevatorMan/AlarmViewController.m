//
//  AlarmViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/4.
//
//

#import <Foundation/Foundation.h>
#import "AlarmViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HttpClient.h"
#import "location.h"
#import "ConfirmProcessViewController.h"
#import "CalloutMapAnnotation.h"
#import "CalloutAnnotationView.h"
#import "ExceptionView.h"
#import "JZLocationConverter.h"
#import <MapKit/MKMapItem.h>
#import <MapKit/MKTypes.h>
#import "ChatController.h"
#import "FileUtils.h"


#pragma mark - RescuWorkerCell

@interface RescuWorkerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;

@property (weak, nonatomic) IBOutlet UIImageView *imagePhone;

@end

@implementation RescuWorkerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _imageIcon.layer.masksToBounds = YES;
    _imageIcon.layer.cornerRadius = 15;
}

@end

#pragma mark - AlarmViewController

@interface AlarmViewController()<UIAlertViewDelegate, BMKMapViewDelegate, ExceptionDelegate,
UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) NSDictionary *alarmInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *workerArray;

@property (strong, nonatomic) IBOutlet UIButton *btnLocation;

@property (weak, nonatomic) IBOutlet UIView *viewTip;

@property (weak, nonatomic) IBOutlet UIButton *btnNav;

@property (strong, nonatomic) NSMutableArray *mapApps;

@property (strong, nonatomic) NSMutableArray *maps;

@property (strong, nonatomic) UIImageView *imageViewShow;

@end

@implementation AlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"应急救援"];
    [self initNavRight];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedLocation) name:@"userLocationUpdate"
                                               object:nil];
}

- (void)initView
{
    _confirmBtn.hidden = YES;
    _cancelBtn.hidden = YES;
    
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _confirmBtn.layer.borderWidth = 1;
    
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _cancelBtn.layer.borderWidth = 1;
    
    _btnNav.layer.masksToBounds = YES;
    _btnNav.layer.cornerRadius = 5;
    _btnNav.layer.borderColor = [UIColor blueColor].CGColor;
    _btnNav.layer.borderWidth = 1;
    
    
    [_mapView setZoomLevel:15];
    [_mapView setMaxZoomLevel:20];
    [_mapView setMinZoomLevel:8];
    
    _mapView.delegate = self;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    label.text = @"合作伙伴";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
    _tableView.tableHeaderView = label;
    
    [_btnLocation addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnNav addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAlarmInfo];
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
    ChatController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"chat_controller"];
    controller.alarmId = _alarmId;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)location
{
    [[location sharedLocation] startLocationService];
}

- (void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (NSString *title in _maps)
    {
        [actionSheet addButtonWithTitle:title];
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)getAlarmInfo
{
    __weak AlarmViewController *weakself = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.alarmId forKey:@"id"];
    
    [[HttpClient sharedClient] view:self.view post:@"getAlarmDetail" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"body"];
        
        //显示报警信息
        _alarmInfo = dic;
        
        CGFloat lat = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
        CGFloat lng = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
        
        CLLocationCoordinate2D coorEnd;
        coorEnd.latitude = lat;
        coorEnd.longitude = lng;
        
        [self initMapAppWithEnd:coorEnd];
        
        //参与救援的维修工列表
        _workerArray = [dic objectForKey:@"contactList"];
                
        if (0 == _workerArray.count)
        {
            weakself.tableView.hidden = YES;
            _viewTip.hidden = NO;
        }
        else
        {
            _viewTip.hidden = YES;
            weakself.tableView.hidden = NO;
            [weakself.tableView reloadData];

        }
        
        //启动定位
        [[location sharedLocation] startLocationService];
        
        [weakself showAlarmInfo:dic];
    }];
}

- (void)showAlarmInfo:(NSDictionary *)dic
{
    
    NSDictionary *communityInfo = [dic objectForKey:@"communityInfo"];
    NSString *project = [communityInfo objectForKey:@"name"];
    
    NSDictionary *elevatorInfo = [dic objectForKey:@"elevatorInfo"];
    NSString *address = [communityInfo objectForKey:@"address"];
    
    NSString *buildingCode = [elevatorInfo objectForKey:@"buildingCode"];
    NSString *unitCode = [elevatorInfo objectForKey:@"unitCode"];
    NSString *liftNum = [elevatorInfo objectForKey:@"liftNum"];
    NSString *elevator = [NSString stringWithFormat:@"%@%@号楼%@单元%@号电梯", address, buildingCode, unitCode, liftNum];
    
    
    NSString *tel = [communityInfo objectForKey:@"propertyUtel"];
    
    
    _projectLabel.text = [dic objectForKey:@"alarmTime"];
    _addressLabel.text = elevator;
    _telLabel.text = tel;
    
    //报警已经撤销
    NSString *isCancel = [dic objectForKey:@"isMisinfomation"];
    if ([isCancel isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该报警已经撤销，感谢您的参与!"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *alarmState = [dic objectForKey:@"state"];
    NSString *userState = [dic objectForKey:@"userState"];
    
    //接收到报警
    if ([alarmState isEqualToString:@"0"] || 0 == alarmState.length)
    {
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        [_confirmBtn addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmBtn.hidden = NO;
        _cancelBtn.hidden = NO;
    }
    else
    {
        //发给报警，但是并没有指派给当前用户
        if (0 == userState.length)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该报警已经无法再次接收报警，感谢你的参与!"
                                                           delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if ([userState isEqualToString:@"1"])
        {
            [_confirmBtn setTitle:@"顺利到达" forState:UIControlStateNormal];
            [_cancelBtn setTitle:@"无法到达" forState:UIControlStateNormal];
            [_confirmBtn addTarget:self action:@selector(arrived) forControlEvents:UIControlEventTouchUpInside];
            [_cancelBtn addTarget:self action:@selector(unArrived) forControlEvents:UIControlEventTouchUpInside];
            _confirmBtn.hidden = NO;
            _cancelBtn.hidden = NO;
        }
        
    }
    
    //设置电话按钮监听
    [_telBtn addTarget:self action:@selector(dialTel) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)arrived
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[_alarmInfo objectForKey:@"id"] forKey:@"alarmId"];
    [dic setObject:@"2" forKey:@"state"];
    
    
    [[HttpClient sharedClient] view:self.view post:@"saveProcessRecord"
                          parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
                                ConfirmProcessViewController *controller = [board instantiateViewControllerWithIdentifier:@"confirm_process"];
                                controller.alarmId = [_alarmInfo objectForKey:@"id"];
                                
                                [self.navigationController pushViewController:controller animated:YES];
                                
                            }  failed:^(id responseObject) {
                                NSString *rspMsg = [[responseObject objectForKey:@"head"] objectForKey:@"rspMsg"];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rspMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                [alert show];
                            }];
}

- (void)unArrived
{
    ExceptionView *exceptionView = [ExceptionView viewFromNib];
    exceptionView.delegate = self;
    [self.view addSubview:exceptionView];
}


- (void)receivedLocation
{
    [_mapView removeAnnotations:_mapView.annotations];
    
    //显示维修工当前位置
    BMKPointAnnotation *worker = [[BMKPointAnnotation alloc] init];
    worker.coordinate = [location sharedLocation].userLocation.location.coordinate;
    [_mapView addAnnotation:worker];
    [_mapView showAnnotations:[NSArray arrayWithObjects:worker, nil] animated:YES];
    
    //标记报警位置
    CGFloat lat = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
    CGFloat lng = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
    
    CalloutMapAnnotation *marker = [[CalloutMapAnnotation alloc] init];
    marker.latitude = lat;
    marker.longitude = lng;
    marker.info = [_alarmInfo copy];
    [_mapView addAnnotation:marker];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)accept
{
    if (0 == _distanceLabel.tag)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法获取您的定位信息,您无法处理此次救援,感谢您的参与!"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[_alarmInfo objectForKey:@"id"] forKey:@"alarmId"];
    [dic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:_distanceLabel.tag]] forKey:@"distance"];
    
    [[HttpClient sharedClient] view:self.view post:@"userAcceptAlarm" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经接单成功,请等待系统指派" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }  failed:^(id responseObject) {
        NSString *rspMsg = [[responseObject objectForKey:@"head"]objectForKey:@"rspMsg"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rspMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (void)cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经拒绝处理此次救援,感谢您的参与!"
                                                   delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)dialTel
{
    NSString *tel = [[_alarmInfo objectForKey:@"communityInfo" ] objectForKey:@"propertyUtel"];
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
#pragma mark --  UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (ALARM_RECEIVED == alertView.tag || ALARM_ASSIGNED == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
            AlarmViewController *controller = [board instantiateViewControllerWithIdentifier:@"alarm_process"];
            controller.alarmId = self.notifyAlarmId;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        //填写距离
        CGFloat lat = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
        CGFloat lng = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
        CLLocationCoordinate2D coor;
        coor.latitude = lat;
        coor.longitude = lng;
        NSInteger distance = (NSInteger)[[location sharedLocation] handleDistance:coor];
        
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
        
        _distanceLabel.tag = distance;
        _distanceLabel.text = dis;
        
        //返回维修工当前位置标记
        BMKAnnotationView *marker = [mapView dequeueReusableAnnotationViewWithIdentifier:@"worker"];
        if (nil ==  marker)
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
        
        CalloutAnnotationView *calloutView = (CalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"alarm"];
        
        if (nil == calloutView)
        {
            calloutView = [[CalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"alarm"];
        }
        return calloutView;
    }
    
    return nil;
}

#pragma mark -- ExceptionDelegate
- (void)onClickConfirm:(NSString *)remark
{
    if (0 == remark.length)
    {
        [HUDClass showHUDWithLabel:@"请填写无法到达的理由!"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[_alarmInfo objectForKey:@"id"] forKey:@"alarmId"];
    [dic setObject:remark forKey:@"remark"];
    
    
    [[HttpClient sharedClient] view:self.view post:@"unexpectedByUser"
                          parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [HUDClass showHUDWithLabel:@"提交无法到达理由成功!"];
                                [self.navigationController popViewControllerAnimated:YES];
                                
                            }  failed:^(id responseObject) {
                                NSString *rspMsg = [[responseObject objectForKey:@"head"] objectForKey:@"rspMsg"];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rspMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                [alert show];
                            }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _workerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RescuWorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rescu_worker_cell"];
    
    if (nil == cell)
    {
        cell = [[RescuWorkerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rescu_worker_cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *url = [_workerArray[indexPath.row] objectForKey:@"headPic"];
    [self downloadIconByUrlString:url imageView:cell.imageIcon];
    cell.lbName.text = [_workerArray[indexPath.row] objectForKey:@"name"];
    cell.lbTel.text = [_workerArray[indexPath.row] objectForKey:@"tel"];
    
    cell.imagePhone.userInteractionEnabled = YES;
    cell.imagePhone.tag = indexPath.row;
    [cell.imagePhone addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialTel:)]];
    
    cell.imageIcon.userInteractionEnabled = YES;
    cell.imageIcon.tag = indexPath.row;
    [cell.imageIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
    
    return cell;
}

- (void)showImage:(UIGestureRecognizer *)sender
{
    NSInteger tag = [sender view].tag;
    NSString *url = [_workerArray[tag] objectForKey:@"headPic"];
    
    _imageViewShow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    [self downloadIconByUrlString:url imageView:_imageViewShow];
    
    [self.view addSubview:_imageViewShow];
    
    _imageViewShow.userInteractionEnabled = YES;
    [_imageViewShow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endShow)]];
}

- (void)endShow
{
    if (_imageViewShow && [_imageViewShow superview])
    {
        [_imageViewShow removeFromSuperview];
        _imageViewShow = nil;
    }
}

- (void)dialTel:(UIGestureRecognizer *)sender
{
    NSInteger tag = [sender view].tag;
    NSString *tel = [_workerArray[tag] objectForKey:@"tel"];
    
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    RescuWorkerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSString *tel = cell.lbTel.text;
//    
//    if (0 == tel.length)
//    {
//        [HUDClass showHUDWithLabel:@"非法的手机号码,无法拨打!" view:self.view];
//        return;
//    }
//    
//    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//    [self.view addSubview:webView];
}

#pragma mark - 导航

- (void)initMapAppWithEnd:(CLLocationCoordinate2D)endLocation
{
    _mapApps = [NSMutableArray array];
    _maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    
    [_mapApps addObject:iosMapDic];
    [_maps addObject:@"苹果地图"];
    
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving",
                               endLocation.latitude, endLocation.longitude, @"电梯报警"]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [_mapApps addObject:baiduMapDic];
        [_maps addObject:@"百度地图"];
    }
    
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        CLLocationCoordinate2D gcj = [JZLocationConverter bd09ToGcj02:endLocation];
        
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",
                               @"导航功能", @"电梯易管家", gcj.latitude, gcj.longitude]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [_mapApps addObject:gaodeMapDic];
        [_maps addObject:@"高德地图"];
        
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]])
    {
        
        CLLocationCoordinate2D gcj = [JZLocationConverter bd09ToGcj02:endLocation];
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=电梯报警&coord_type=1&policy=0",
                                gcj.latitude, gcj.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [_mapApps addObject:qqMapDic];
        
        [_maps addObject:@"腾讯地图"];

    }
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"index:%ld", buttonIndex);
    CGFloat lat = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
    CGFloat lng = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
    
    CLLocationCoordinate2D coorEnd;
    coorEnd.latitude = lat;
    coorEnd.longitude = lng;
    
    if (0 == buttonIndex)
    {
        //[actionSheet dis]
    }
    else if (1 == buttonIndex)
    {
        [self navAppleMapWithDes:coorEnd];
    }
    else
    {
        
        NSString *urlString = [_mapApps[buttonIndex - 1] objectForKey:@"url"];
        NSLog(@"url:%@", urlString);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}


//苹果地图
- (void)navAppleMapWithDes:(CLLocationCoordinate2D)destination
{
    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:destination];
    
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}


#pragma mark - deal with the icon image


- (void)downloadIconByUrlString:(NSString *)urlString imageView:(UIImageView *)imageView {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"pic:%@", url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data.length > 0 && nil == connectionError) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:imageView forKey:@"imageView"];
            [dic setObject:data forKey:@"data"];
            [self performSelectorOnMainThread:@selector(setImage:) withObject:dic waitUntilDone:NO];
            
        } else if (connectionError != nil) {
            NSLog(@"download picture error = %@", connectionError);
        }
    }];
}

- (void)setImage:(NSDictionary *)params
{
    UIImageView *imageView = [params objectForKey:@"imageView"];
    NSData *data = [params objectForKey:@"data"];
    [imageView setImage:[UIImage imageWithData:data]];
}


@end
