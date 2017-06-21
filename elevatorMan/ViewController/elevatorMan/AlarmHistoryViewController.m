//
//  AlarmHistoryViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/25.
//
//

#import <Foundation/Foundation.h>
#import "AlarmHistoryViewController.h"
#import "AlarmReceivedViewController.h"
#import "AlarmResultViewController.h"

#pragma mark -- AlarmCell

@interface AlarmCell (history)
@end

@implementation AlarmCell (history)

@end

#pragma mark -- AlarmHistoryViewController

@interface AlarmHistoryViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *arrayAlarm;

@end

@implementation AlarmHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"应急救援"];
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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    params[@"scope"] = @"finished";

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

        label.text = @"您暂时没有处理过的报警事件";

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

    if (-10 == userState)
    {
        cell.labelState.text = @"已撤销";
    }
    else if (-9 == userState)
    {
        cell.labelState.text = @"未指派";
    }
    else if (3 == userState)
    {
        cell.labelState.text = @"已完成";
    }
    else if (4 == userState)
    {
        cell.labelState.text = @"意外情况";
    }

    cell.labelIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    [cell setColorWithIndex:indexPath.row];

    return cell;
}

/**
 *  setting the height of the tableview cell
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -- UITableViewDelegate

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
        AlarmResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlarmResultViewController"];
        vc.project = info[@"communityInfo"][@"name"];;
        vc.address = info[@"communityInfo"][@"address"];
        vc.liftCode = info[@"elevatorInfo"][@"liftNum"];
        vc.alarmTime = info[@"alarmTime"];
        vc.savedCount = [NSString stringWithFormat:@"%ld", [info[@"savedCount"] integerValue]];
        vc.injuredCount = [NSString stringWithFormat:@"%ld", [info[@"injureCount"] integerValue]];
        vc.picUrl = info[@"pic"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
