//
// Created by changhaozhang on 2017/6/15.
//

#import "MaintLiftHistoryController.h"
#import "ComMaintInfoCell.h"
#import "PlanViewController.h"
#import "MaintListDetailController.h"

@interface MaintLiftHistoryController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayLift;

@end

@implementation MaintLiftHistoryController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保历史"];
    [self initView];
    [self getHistory];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

- (NSMutableArray *)arrayLift
{
    if (!_arrayLift)
    {
        _arrayLift = [NSMutableArray array];
    }
    return _arrayLift;
}

- (void)getHistory
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"elevatorId"] = _liftId;

    [[HttpClient sharedClient] post:@"getMaintListByElevatorId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.arrayLift removeAllObjects];
        [self.arrayLift addObjectsFromArray:responseObject[@"body"]];
        [self.tableView reloadData];
    }];
}

- (NSString *)getMaintDes:(NSString *)type
{
    if ([type isEqualToString:@"hm"])
    {
        return @"半月保";
    }
    else if ([type isEqualToString:@"m"])
    {
        return @"月保";
    }
    else if ([type isEqualToString:@"s"])
    {
        return @"季度保";
    }
    else if ([type isEqualToString:@"hy"])
    {
        return @"半年保";
    }
    else
    {
        return @"年保";
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayLift.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComMaintInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ComMaintInfoCell identifier]];

    if (!cell)
    {
        cell = [ComMaintInfoCell cellFromNib];
    }

    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    NSDictionary *info = self.arrayLift[indexPath.row];

    cell.lbAddress.text = [self getMaintDes:info[@"maintType"]];

    NSString *maintTime = info[@"maintTime"];

    if (0 == maintTime)
    {
        cell.lbWorker.text = [NSString stringWithFormat:@"待维保  计划日期:%@", info[@"planTime"]];
    }
    else
    {
        cell.lbWorker.text = [NSString stringWithFormat:@"已完成  完成日期:%@", maintTime];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ComMaintInfoCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.arrayLift[indexPath.row];
    MaintListDetailController *controller = [[MaintListDetailController alloc] init];
    controller.maintInfo = info;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
@end