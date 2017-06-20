//
// Created by changhaozhang on 2017/6/17.
//

#import "TmateMainPageController.h"
#import "MainPageView.h"
#import "AddBannerData.h"
#import "HouseMaintManagerController.h"
#import "HouseRepairManagerController.h"
#import "AlarmManagerController.h"
#import "KnowledgeController.h"
#import "MaintManagerController.h"
#import "ProAlarmTabBarController.h"
#import "RepairOrderController.h"
#import "MaintOrderController.h"
#import "MarketDetailController.h"
#import "location.h"
#import "AlarmTabBarController.h"

@interface TmateMainPageController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MainPageView *myView;

@end

@implementation TmateMainPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"首页"];
    [self dealWithLocation];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64 - 49)];

    tableView.delegate = self;

    tableView.dataSource = self;

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    tableView.backgroundColor = RGB(BG_GRAY);

    [self.view addSubview:tableView];


    _myView = [MainPageView viewFromNib];


    tableView.tableHeaderView = _myView;

    if (Role_Pro == self.roleType)
    {
        _myView.lbMaint.text = @"电梯商城";
        _myView.lbRepair.text = @"附近维保";
    }

    [self addEventListener];

    [self initBannerView];
}

- (void)dealWithLocation
{
    if (self.roleType != Role_Worker)
    {
        return;
    }

    //添加定位成功返回监听
    if ([self respondsToSelector:@selector(uploadLocationWhenReceivedNotify:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadLocationWhenReceivedNotify:)
                                                     name:@"userLocationUpdate" object:nil];
    }

    //定位一次
    [[location sharedLocation] startLocationService];

    [self locationLoop:5];
}

- (void)locationLoop:(CGFloat)second
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    if (appDelegate.locationTimer)
    {
        [appDelegate.locationTimer invalidate];
        appDelegate.locationTimer = nil;
    }

    //有任务,30秒定位一次
    appDelegate.locationTimer = [NSTimer scheduledTimerWithTimeInterval:second * 60 target:self
                                                               selector:@selector(getUserLocationUpdate) userInfo:nil repeats:YES];
}

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


    if (latitude < 0.00001 || longitude < 0.00001)
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

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"lat"] = [NSNumber numberWithFloat:latitude];
    params[@"lng"] = [NSNumber numberWithFloat:longitude];

    [[HttpClient sharedClient] bgPost:@"updateLocation" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failed:^(id responseObject) {

    }];

}

- (void)addEventListener
{
    [_myView.viewAlarm addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rescue)]];

    [_myView.viewMaint addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maintenance)]];

    [_myView.viewHouseMaint addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseMaint)]];

    [_myView.viewHouseRepair addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseRepair)]];

    [_myView.viewQa addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QA)]];

    [_myView.viewFault addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faultCode)]];

    [_myView.viewOp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(operation)]];

    [_myView.viewSafety addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(safety)]];
}

- (void)initBannerView
{
    _myView.bannerHeight.constant = self.screenWidth / 2;

    AddBannerView *bannerView = [[AddBannerView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];

    [self.myView.bannerView addSubview:bannerView];

    [[HttpClient sharedClient] post:@"getAdvertisementBySmallOwner" parameter:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSMutableArray *array = [NSMutableArray array];

        for (NSDictionary *dic in [responseObject objectForKey:@"body"])
        {
            AddBannerData *data = [[AddBannerData alloc] initWithUrl:[dic objectForKey:@"pic"]
                                                            clickUrl:[dic objectForKey:@"picUrl"]];
            [array addObject:data];
        }

        bannerView.arrayData = [array copy];
        [bannerView shouldAutoShow:YES];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)rescue
{
    if (Role_Com == self.roleType)
    {
        AlarmManagerController *controller = [[AlarmManagerController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (Role_Pro == self.roleType)
    {
        ProAlarmTabBarController *controller = [[ProAlarmTabBarController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        AlarmTabBarController *controller = [[AlarmTabBarController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;

//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
//        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"WorkerAlarmList"];
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (void)maintenance
{
    if (Role_Com == self.roleType)
    {
        MaintManagerController *controller = [[MaintManagerController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (Role_Pro == self.roleType)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Property" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"mantenanceController"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"maintenance_page"];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}
- (void)houseMaint
{
    if (Role_Com == self.roleType)
    {
        if (!self.joinVilla)
        {
            [self showUnJoinedInfo];
            return;
        }
        HouseMaintManagerController *controller = [[HouseMaintManagerController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (Role_Pro == self.roleType)
    {
        MarketDetailContrller *contrller = [[MarketDetailContrller alloc] init];

        contrller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contrller animated:YES];
    }
    else
    {
        if (!self.joinVilla)
        {
            [self showUnJoinedInfo];
            return;
        }
        MaintOrderController *controller = [[MaintOrderController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (void)houseRepair
{
    if (Role_Com == self.roleType)
    {
        if (!self.joinVilla)
        {
            [self showUnJoinedInfo];
            return;
        }
        HouseRepairManagerController *controller = [[HouseRepairManagerController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (Role_Pro == self.roleType)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyProperty" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"around_controller"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        if (!self.joinVilla)
        {
            [self showUnJoinedInfo];
            return;
        }
        RepairOrderController *controller = [[RepairOrderController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }


}



- (void)QA
{
    KnowledgeController *controller = [[KnowledgeController alloc] init];

    controller.knType = @"常见问题";
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)faultCode
{
    KnowledgeController *controller = [[KnowledgeController alloc] init];

    controller.knType = @"故障码";
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)operation
{
    KnowledgeController *controller = [[KnowledgeController alloc] init];

    controller.knType = @"操作手册";
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)safety
{
    KnowledgeController *controller = [[KnowledgeController alloc] init];

    controller.knType = @"安全法规";
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end