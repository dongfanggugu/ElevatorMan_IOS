//
//  MaintManagerController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "MaintManagerController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ComMaintTitleView.h"
#import "MaintLiftController.h"
#import "ListDialogView.h"
#import "ListDialogData.h"

@interface MaintManagerController () <BMKMapViewDelegate, ComMaintTitleViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *arrayBranch;

@property (strong, nonatomic) NSMutableArray *arrayWorker;

@property (strong, nonatomic) ComMaintTitleView *titleView;

@property (copy, nonatomic) NSString *branchId;

@property (copy, nonatomic) NSString *workerId;

@end

@implementation MaintManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"E维保"];
    [self initNavRightWithText:@"维保历史"];
    [self initView];
    [self getBranches];
}

- (void)onClickNavRight {
    MaintLiftController *controller = [[MaintLiftController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)arrayBranch
{
    if (!_arrayBranch)
    {
        _arrayBranch = [NSMutableArray array];
    }

    return _arrayBranch;
}

- (NSMutableArray *)arrayWorker
{
    if (!_arrayWorker)
    {
        _arrayWorker = [NSMutableArray array];
    }

    return _arrayWorker;
}


- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 15;
    
    [self.view addSubview:_mapView];
    
    //头部视图
    _titleView = [ComMaintTitleView viewFromNib];
    
    _titleView.frame = CGRectMake(0, 64, self.screenWidth, 75);
    
    _titleView.delegate = self;
    
    [self.view addSubview:_titleView];
}

- (void)getBranches
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;

    [[HttpClient sharedClient] post:@"getBranchsByBranchId" parameter:params success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self.arrayBranch removeAllObjects];
        [self.arrayBranch addObjectsFromArray:responseObject[@"body"]];
        [self initBranch];
    }];
}

- (void)initBranch
{
    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *info in self.arrayBranch)
    {
        ListDialogData *data = [[ListDialogData alloc] initWithKey:info[@"id"] content:info[@"name"]];

        [array addObject:data];
    }

    _branchId = self.arrayBranch[0][@"id"];
    _titleView.arrayCompany = array;
}

- (void)getWorkers:(NSString *)branchId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = _branchId;

    [[HttpClient sharedClient] post:@"getWorkListByBranchId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.arrayWorker removeAllObjects];
        [self.arrayWorker addObjectsFromArray:responseObject[@"body"]];

        [self initWorker];
    }];
}
- (void)initWorker
{
    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *info in self.arrayWorker)
    {
        ListDialogData *data = [[ListDialogData alloc] initWithKey:info[@"id"] content:info[@"name"]];

        [array addObject:data];
    }

    _workerId = self.arrayWorker[0][@"id"];
    _titleView.arrayWorker = array;
}

#pragma mark - AlarmTitleViewDelegate

- (void)onChooseWorker:(NSString *)workerId name:(NSString *)name
{
    _workerId = _workerId;
}

- (void)onChooseCompany:(NSString *)comId name:(NSString *)name
{
    _branchId = comId;

    [self getWorkers:_branchId];
}

- (void)onClickBtn1
{
    
}

- (void)onClickBtn2
{
    
}

- (void)onClickBtn3
{
    
}

- (void)onClickBtn4
{
    
}

@end
