//
//  AlarmHistoryController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "AlarmHistoryController.h"
#import "ComAlarmCell.h"
#import "AlarmResultViewController.h"

@interface AlarmHistoryController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayAlarm;

@end

@implementation AlarmHistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"救援历史"];
    [self initView];
    [self getAlarms];
}

- (NSMutableArray *)arrayAlarm
{
    if (!_arrayAlarm)
    {
        _arrayAlarm = [NSMutableArray array];
    }

    return _arrayAlarm;
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

- (void)getAlarms
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;
    params[@"history"] = @"1";

    [[HttpClient sharedClient] post:@"getAlarmListByBranchId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.arrayAlarm removeAllObjects];
        [self.arrayAlarm addObjectsFromArray:responseObject[@"body"]];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayAlarm.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:[ComAlarmCell identifier]];

    if (!cell)
    {
        cell = [ComAlarmCell cellFromNib];
    }
    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    NSDictionary *info = self.arrayAlarm[indexPath.row];

    cell.lbProject.text = info[@"communityName"];
    cell.lbTime.text = info[@"alarmTime"];

    BOOL cancel = [info[@"isMisinformation"] boolValue];

    if (cancel)
    {
        cell.lbState.text = @"已撤销";
    }
    else
    {
        cell.lbState.text = @"已完成";
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ComAlarmCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.arrayAlarm[indexPath.row];
    NSInteger userState = [info[@"userState"] integerValue];

    if (-10 == userState)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该报警已经取消，无法查看救援结果!"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (-9 == userState)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该报警已经取消，无法查看救援结果!"
                                                       delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
        AlarmResultViewController *vc = [board instantiateViewControllerWithIdentifier:@"AlarmResultViewController"];
        vc.project = info[@"communityName"];
        vc.address = info[@"communityAddress"];
        vc.liftCode = info[@"liftNum"];
        vc.alarmTime = info[@"alarmTime"];
        vc.savedCount = [NSString stringWithFormat:@"%ld", [info[@"savedCount"] integerValue]];
        vc.injuredCount = [NSString stringWithFormat:@"%ld", [info[@"injureCount"] integerValue]];

        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}


@end
