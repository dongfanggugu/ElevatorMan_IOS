//
//  AlarmAssignedViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/25.
//
//

#import <Foundation/Foundation.h>
#import "AlarmAssignedViewController.h"
#import "AlarmReceivedViewController.h"
#import "AlarmViewController.h"

#pragma mark -- AlarmCell

@interface AlarmCell (assigned)

@end

@implementation AlarmCell (assigned)

@end

#pragma mark -- AlarmAssignedViewController

@interface AlarmAssignedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *arrayAlarm;

@end

@implementation AlarmAssignedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
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
    self.mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAlarms];
}

- (void)getAlarms
{
    __weak typeof(self) weakSelf = self;

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"scope"] = @"unfinished";

    [[HttpClient sharedClient] view:nil post:@"getAlarmListByRepairUserId" parameter:params

                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [self.arrayAlarm removeAllObjects];
                                [self.arrayAlarm addObjectsFromArray:responseObject[@"body"]];

                                [weakSelf reloadTableView];
                            }];

}

- (void)reloadTableView
{
    if (0 == self.arrayAlarm.count)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 40)];

        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;

        label.text = @"您暂时没有需要处理的报警事件";

        self.mTableView.tableHeaderView = label;
    }
    else
    {
        self.mTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    [self.mTableView reloadData];
}

#pragma mark -- UITableViewDataSource

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
    AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];

    NSDictionary *alarmInfo = self.arrayAlarm[indexPath.row];

    cell.labelProject.text = alarmInfo[@"communityInfo"][@"name"];
    cell.labelDate.text = alarmInfo[@"alarmTime"];

    NSInteger userState = [alarmInfo[@"userState"] integerValue];

    if (1 == userState)
    {
        cell.labelState.text = @"已出发";
    }
    else if (2 == userState)
    {
        cell.labelState.text = @"已到达";
    }

    cell.labelIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    [cell setColorWithIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *alarmInfo = self.arrayAlarm[indexPath.row];

    NSInteger userState = [alarmInfo[@"userState"] integerValue];

    if (1 == userState)
    {
        AlarmViewController *controller = [self.storyboard
                instantiateViewControllerWithIdentifier:@"alarm_process"];
        controller.alarmId = alarmInfo[@"id"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (2 == userState)
    {
        AlarmViewController *controller = [self.storyboard
                instantiateViewControllerWithIdentifier:@"confirm_process"];
        controller.alarmId = alarmInfo[@"id"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
