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

@interface TmateMainPageController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MainPageView *myView;

@end

@implementation TmateMainPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"首页"];
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

    if (ROle_Pro == self.roleType)
    {
        _myView.lbMaint.text = @"电梯商城";
        _myView.lbRepair.text = @"附近维保";
    }

    [self addEventListener];

    [self initBannerView];
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
    _myView.bannerHeight.constant = self.screenWidth / 3;

    AddBannerView *bannerView = [[AddBannerView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 3)];

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
    else if (ROle_Pro == self.roleType)
    {
        ProAlarmTabBarController *controller = [[ProAlarmTabBarController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"WorkerAlarmList"];
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
    else if (ROle_Pro == self.roleType)
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

- (void)houseRepair
{
    if (Role_Com == self.roleType)
    {
        HouseRepairManagerController *controller = [[HouseRepairManagerController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (ROle_Pro == self.roleType)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyProperty" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"around_controller"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        RepairOrderController *controller = [[RepairOrderController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }


}

- (void)houseMaint
{
    if (Role_Com == self.roleType)
    {
        HouseMaintManagerController *controller = [[HouseMaintManagerController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (ROle_Pro == self.roleType)
    {
        MarketDetailContrller *contrller = [[MarketDetailContrller alloc] init];

        contrller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contrller animated:YES];
    }
    else
    {
        MaintOrderController *controller = [[MaintOrderController alloc] init];
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

@end