//
//  MainpageViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/27.
//
//

#import "MainpageViewController.h"
#import "location.h"
#import "AVFoundation/AVFoundation.h"
#import "MaintOrderController.h"
#import "RepairOrderController.h"
#import "AlarmManagerController.h"
#import "MaintManagerController.h"
#import "HouseRepairManagerController.h"
#import "HouseMaintManagerController.h"
#import "HelpController.h"


@interface MainpageViewController () <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *rescueView;

@property (weak, nonatomic) IBOutlet UIView *maintenanceView;

@property (weak, nonatomic) IBOutlet UIView *helpView;

@property (weak, nonatomic) IBOutlet UIView *personView;

@property (weak, nonatomic) IBOutlet UIView *repairView;

@property (weak, nonatomic) IBOutlet UIView *wikiView;

@property (nonatomic, strong) NSTimer *trackingTimer;

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

@property (nonatomic) __block UIBackgroundTaskIdentifier bgTask;

@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation MainpageViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯易管家"];
    [self initView];


    //添加定位成功返回监听
    if ([self respondsToSelector:@selector(uploadLocationWhenReceivedNotify:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadLocationWhenReceivedNotify:)
                                                     name:@"userLocationUpdate" object:nil];
    }

    //后台一直运行
    [self startTimer];

    //定位一次
    [[location sharedLocation] startLocationService];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackIcon];
    [self hasAlarm];
}


/**
 *  请求服务器，看是否有报警未处理
 */
- (void)hasAlarm
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"unfinished" forKey:@"scope"];

    [[HttpClient sharedClient] view:self.view post:@"getAlarmListByRepairUserId" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                [self showTagView:responseObject[@"body"]];
                            }];

}


- (void)showTagView:(NSArray *)array
{

    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    if (appDelegate.locationTimer)
    {
        [appDelegate.locationTimer invalidate];
        appDelegate.locationTimer = nil;
    }


    if (array.count > 0)
    {

        _tagView.hidden = NO;


        //有任务,30秒定位一次
        appDelegate.locationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 * 60 target:self
                                                                   selector:@selector(getUserLocationUpdate) userInfo:nil repeats:YES];


    }
    else
    {
        _tagView.hidden = YES;

        //没有任务,5分钟定位一次
        appDelegate.locationTimer = [NSTimer scheduledTimerWithTimeInterval:5 * 60 target:self
                                                                   selector:@selector(getUserLocationUpdate) userInfo:nil repeats:YES];
    }

}


- (void)initView
{
    self.tableView.allowsSelection = NO;
    self.tableView.bounces = NO;

    _tagView.hidden = YES;
    _tagView.layer.masksToBounds = YES;
    _tagView.layer.cornerRadius = 8;

    _rescueView.layer.masksToBounds = YES;
    _rescueView.layer.cornerRadius = 8;
    _rescueView.userInteractionEnabled = YES;
    [_rescueView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rescue)]];


    _maintenanceView.layer.masksToBounds = YES;
    _maintenanceView.layer.cornerRadius = 8;
    _maintenanceView.userInteractionEnabled = YES;
    [_maintenanceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maintenance)]];

    _helpView.layer.masksToBounds = YES;
    _helpView.layer.cornerRadius = 8;
    _helpView.userInteractionEnabled = YES;
    [_helpView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseRepair)]];

    _personView.layer.masksToBounds = YES;
    _personView.layer.cornerRadius = 8;
    _personView.userInteractionEnabled = YES;
    [_personView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(person)]];


    _repairView.layer.masksToBounds = YES;
    _repairView.layer.cornerRadius = 8;
    _repairView.userInteractionEnabled = YES;
    [_repairView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseMaint)]];

    _wikiView.layer.masksToBounds = YES;
    _wikiView.layer.cornerRadius = 8;
    _wikiView.userInteractionEnabled = YES;
    [_wikiView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wiki)]];

}


- (void)rescue
{
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
//    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"WorkerAlarmList"];
//    [self.navigationController pushViewController:controller animated:YES];

    AlarmManagerController *controller = [[AlarmManagerController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)maintenance
{
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
//    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"maintenance_page"];
//    [self.navigationController pushViewController:controller animated:YES];

    MaintManagerController *controller = [[MaintManagerController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)houseRepair
{
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
//    UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"help_center"];
//    [self.navigationController pushViewController:controller animated:YES];

    RepairOrderController *controller = [[RepairOrderController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];


//    HouseRepairManagerController *controller = [[HouseRepairManagerController alloc] init];
//
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)person
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
    UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"person_center"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)houseMaint
{

    MaintOrderController *controller = [[MaintOrderController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

//    HouseMaintManagerController *controller = [[HouseMaintManagerController alloc] init];
//
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];

    //NSString *region =  [[NSUserDefaults standardUserDefaults] objectForKey:@"urlString"];

//    UIViewController *controller = [[WRepairTabBarController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)wiki
{
    HelpController *controller = [[HelpController alloc] init];
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
//    UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"lift_wiki"];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//- (void)initNavBar
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
//    label.text = @"首页";
//    label.font = [UIFont systemFontOfSize:17];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    
//    [self.navigationItem setTitleView:label];
//}




#pragma mark - getUserLocationUpdate


- (void)getUserLocationUpdate
{

    [[location sharedLocation] startLocationService];
}

- (void)uploadLocationWhenReceivedNotify:(NSNotification *)notify
{
    BMKUserLocation *location = (BMKUserLocation *) [notify.userInfo objectForKey:@"userLocation"];
    if (nil == location)
    {
        return;
    }

    float latitude = location.location.coordinate.latitude;
    float longitude = location.location.coordinate.longitude;


    if (latitude < 0.00001 && longitude < 0.00001)
    {
        NSLog(@"may be wrong coords");
        return;
    }

    [self uploadLocationWithLatitude:latitude longitude:longitude success:nil];
}

/**
 *  在后台上传位置信息，不在使用HUDClass阻塞UI刷新
 *
 *  @param latitude  <#latitude description#>
 *  @param longitude <#longitude description#>
 */
- (void)uploadLocationWithLatitude:(float)latitude longitude:(float)longitude
                           success:(void (^)(void))success
{

    NSString *urlString = [[Utils getServer] stringByAppendingString:@"updateLocation"];
    NSURL *url = [NSURL URLWithString:urlString];


    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];

    //设置head
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];

    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];

    NSString *token = [User sharedUser].accessToken;
    NSString *userId = [User sharedUser].userId;

    if (0 == token.length || 0 == userId.length)
    {
        return;
    }

    [head setObject:[NSString stringWithFormat:@"%@", [User sharedUser].accessToken] forKey:@"accessToken"];
    [head setObject:[User sharedUser].userId forKey:@"userId"];



    //设置body
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];


    [body setObject:[NSNumber numberWithFloat:latitude] forKey:@"lat"];
    [body setObject:[NSNumber numberWithFloat:longitude] forKey:@"lng"];


    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:head forKey:@"head"];
    [params setObject:body forKey:@"body"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [urlRequest setHTTPBody:jsonData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {


        if (data.length > 0 && nil == connectionError)
        {
            if (success != nil)
            {
                success();
            }
        }
    }];
}

/**
 *  检测后台时间是否到期，需要后台一直运行来进行定位
 */
- (void)startTimer
{

    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    if (!appDelegate.bgCheckTimer)
    {
        appDelegate.bgCheckTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self
                                                                  selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
    }

}

- (void)timerAdvanced:(NSTimer *)timer
{
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0)
    {
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"Alarm" ofType:@"mp3"];
        NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];

        if (nil == _avAudioPlayer)
        {
            _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
            _avAudioPlayer.delegate = self;
            _avAudioPlayer.volume = 0.0f;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                             withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        }
        [self.avAudioPlayer play];

        __weak typeof(self) weakSelf = self;
        _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{

            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.bgTask != UIBackgroundTaskInvalid)
                {
                    weakSelf.bgTask = UIBackgroundTaskInvalid;
                }
            });

        }];
    }
    else
    {
        NSLog(@"left time >> 61");
    }
}
@end
