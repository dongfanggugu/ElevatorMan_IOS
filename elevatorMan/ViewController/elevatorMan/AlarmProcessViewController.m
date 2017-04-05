//
//  AlarmProcessViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/26.
//
//

#import "AlarmProcessViewController.h"
#import "HttpClient.h"
#import <BaiduMapAPI/BMapKit.h>
#import "FinishedReportViewController.h"
#import "location.h"
#import "UnderLineLabel.h"
#import "WorkerMenuViewController.h"


@interface AlarmProcessViewController ()<BMKMapViewDelegate>
{
    IBOutlet BMKMapView* _mapView;
    BMKPointAnnotation* _alarmAnnotation;
}

@property (nonatomic ,strong)NSDictionary *alarmInfo;

@property (weak, nonatomic) IBOutlet UIView *alarmInfoView;

@property (weak, nonatomic) IBOutlet UIView *state1;
@property (weak, nonatomic) IBOutlet UIView *state2;
@property (weak, nonatomic) IBOutlet UIButton *state3;

@property (weak, nonatomic) IBOutlet UILabel *label_projectName;

@property (weak, nonatomic) IBOutlet UnderLineLabel *label_tel;
@property (weak, nonatomic) IBOutlet UILabel *label_adress;

@property (weak, nonatomic) IBOutlet UILabel *label_distence;

@end

@implementation AlarmProcessViewController


- (void)dealloc
{
    
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showsUserLocation = YES;
    [self getAlarmInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.state1.hidden = YES;
    self.state2.hidden = YES;
    self.state3.hidden = YES;
    
    
    [self.view setExclusiveTouch:YES];
    
    //设置title
    self.title = @"电梯易管家";
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    
    self.label_tel.userInteractionEnabled = YES;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call)];
    [self.label_tel addGestureRecognizer:portraitTap];
    self.label_tel.shouldUnderline = YES;
    
    
}
- (IBAction)dismiss:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)call
{
    NSString *telstringTrim = [self.label_tel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([telstringTrim isEqualToString:@""])
    {
        return;
    }
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telstringTrim]];
    UIWebView* phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    
}

/**
 *  获取报警信息
 */
- (void)getAlarmInfo
{
   
    __weak AlarmProcessViewController *weakself = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.alarmId forKey:@"id"];

    [[HttpClient sharedClient] view:self.view post:@"getAlarmDetail" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"result:%@", responseObject);
         weakself.alarmInfo = [responseObject objectForKey:@"body"];
        [weakself refresh];
     }];

}

- (void)refresh {
    //如果报警已经撤消，不再显示
    if ([[_alarmInfo objectForKey:@"isMisinformation"] isEqualToString:@"1"]) {
        [self onReceiveAlarmCancelMessage];
        return;
    }

    NSDictionary *communityInfo = [_alarmInfo objectForKey:@"communityInfo"];
    
    self.label_projectName.text = [communityInfo objectForKey:@"name"];
    self.label_adress.text = [communityInfo objectForKey:@"address"];
    self.label_tel.text = [communityInfo objectForKey:@"propertyUtel"];
    
    
    CLLocationCoordinate2D coor;
    coor.latitude = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
    coor.longitude = [[[_alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
    
    //处理距离显示
    CLLocationDistance distance =  [[location sharedLocation] handleDistance:coor];
    
        NSString *distanceString;
        if (distance <1000.f)
        {
            distanceString = [NSString stringWithFormat:@"%i米",(int)distance];
    
        }
        else if (distance >= 1000)
        {
    
            distanceString = [NSString stringWithFormat:@"%i千米",(int)(distance/1000)];
        
        }

    
    
    self.label_distence.text = distanceString;
    
    
    
    //根据state切换界面
    if ([[_alarmInfo objectForKey:@"state"] isEqualToString:@"0"]) {
        
        self.state1.hidden = NO;
        self.state2.hidden = YES;
        self.state3.hidden = YES;
        
    }
    else if (1 == self.userState)
    {
        self.state1.hidden = YES;
        self.state2.hidden = NO;
        self.state3.hidden = YES;

    }
    else if (2 == self.userState)
    {
        self.state1.hidden = YES;
        self.state2.hidden = YES;
        self.state3.hidden = NO;
    }
    else
    {
        _alarmInfoView.hidden = YES;
    }
    
    [self addAlarmAnnotation];

}

- (void)addAlarmAnnotation
{
    
    [_mapView removeOverlays:_mapView.overlays];
    
    if (_alarmAnnotation == nil) {
        _alarmAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[[self.alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
        coor.longitude = [[[self.alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
        _alarmAnnotation.coordinate = coor;
    }
    
    [_mapView addAnnotation:_alarmAnnotation];
   
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    [array addObject:_alarmAnnotation];
    
    [_mapView showAnnotations:array animated:YES];
}


#pragma mark - BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        
        if (annotation == _alarmAnnotation) {
            BMKAnnotationView *alarmAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                                                   reuseIdentifier:@"alarmAnnotation"];
            [alarmAnnotationView setBounds:CGRectMake(0.f, 0.f, 20.f,25.f)];
            [alarmAnnotationView setBackgroundColor:[UIColor clearColor]];
            alarmAnnotationView.image = [UIImage imageNamed:@"icon_annotation_alarm.png"];
            
            
            return alarmAnnotationView;
        }
        
    }
    return nil;
    
}


- (void)call:(NSString *)telString
{
    NSString *telstringTrim = [telString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([telstringTrim isEqualToString:@""])
    {
        return;
    }
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telstringTrim]];
    UIWebView* phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];

}

- (IBAction)refuse:(id)sender
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)accept:(id)sender
{

    __weak AlarmProcessViewController *weakself = self;
    
  
    CLLocationCoordinate2D coor;
    coor.latitude = [[[self.alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lat"] floatValue];
    coor.longitude = [[[self.alarmInfo objectForKey:@"communityInfo"] objectForKey:@"lng"] floatValue];
    
    
   CLLocationDistance distance =  [[location sharedLocation] handleDistance:coor];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dic setObject:self.alarmId forKey:@"alarmId"];
    [dic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(int)distance]] forKey:@"distance"];
    
    [[HttpClient sharedClient] view:self.view post:@"userAcceptAlarm" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUDClass showHUDWithLabel:@"已接单成功，请等待系统分配" view:self.view];
        [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }  failed:^(id responseObject) {
        [self onReceiveAlarmCancelMessage];
        [HUDClass showHUDWithLabel:@"该报警任务已经被撤消,感谢您的参与!" view:self.view];
    }];
  
}
- (IBAction)arrive:(id)sender
{
    
    __weak AlarmProcessViewController *weakself = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:self.alarmId forKey:@"alarmId"];
    [dic setObject:@"0" forKey:@"isConfirm"];
    [dic setObject:@"2" forKey:@"state"];
    
    
    [[HttpClient sharedClient] view:self.view post:@"saveProcessRecord"
                          parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                self.userState = 2;
                                [weakself getAlarmInfo];
                            }  failed:^(id responseObject) {
                                [self onReceiveAlarmCancelMessage];
                                [HUDClass showHUDWithLabel:@"该报警任务已经被撤消,感谢您的参与!" view:self.view];
                            }];
    
}
- (IBAction)unexpect:(id)sender
{
    __weak AlarmProcessViewController *weakself = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:self.alarmId forKey:@"alarmId"];
    [dic setObject:@"中途出现事故，无法到达现场" forKey:@"remark"];
    
    
    [[HttpClient sharedClient] view:self.view post:@"unexpectedByUser"
                          parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
                            } failed:^(id responseObject) {
                                [self onReceiveAlarmCancelMessage];
                                [HUDClass showHUDWithLabel:@"该报警任务已经被撤消,感谢您的参与!" view:self.view];
                            }];

}

- (IBAction)finish:(id)sender
{
    FinishedReportViewController *vc = [self.storyboard  instantiateViewControllerWithIdentifier:@"finishedReport"];
    vc.alarmId = self.alarmId ;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  当报警撤消时，恢复界面
 */
- (void)onReceiveAlarmCancelMessage {
    self.alarmInfoView.hidden = YES;
    self.state1.hidden = YES;
    self.state2.hidden = YES;
    self.state3.hidden = YES;
}


@end
