//
//  MaintenancePageViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "MaintenancePageViewController.h"
#import "MyLiftViewController.h"
#import "RecordViewController.h"
#import "MaintenanceReminder.h"
#import "DateUtil.h"

@interface MaintenancePageViewController ()


@end

@implementation MaintenancePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"电梯维保"];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)initView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)myLift {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    MyLiftViewController *controller = [board instantiateViewControllerWithIdentifier:@"my_lift"];
    controller.liftType = TYPE_ALL;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)mainPlan {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    MyLiftViewController *controller = [board instantiateViewControllerWithIdentifier:@"my_lift"];
    controller.liftType = TYPE_PLAN;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)uploadRecord {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    RecordViewController *controller = [board instantiateViewControllerWithIdentifier:@"record_controller"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)mainReminder {
}

- (void)yearCheck {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;

    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (0 == row) {
        [self myLift];

    } else if (1 == row) {
        [self mainPlan];

    } else if (2 == row) {
        [self uploadRecord];

    } else if (3 == row) {
        [self mainReminder];

    } else if (4 == row) {
        [self yearCheck];
    }
}


- (void)getElevatorList {

    [[HttpClient sharedClient] view:self.view post:@"getMainElevatorList" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [self setReminder:[responseObject objectForKey:@"body"]];
                            }];
}

- (void)setReminder:(NSArray *)array {
    NSMutableArray *arrayPlan = [NSMutableArray array];
    NSMutableArray *arrayMake = [NSMutableArray array];

    for (NSDictionary *obj in array) {
        NSString *plan = obj[@"planMainTime"];

        if (0 == plan.length) {
            [arrayMake addObject:obj];

        } else {
            [arrayPlan addObject:obj];
        }
    }

    long long deadLineMin = MIN([self setPlanDoneReminder:arrayPlan], [self setPlanMakeReminder:arrayMake]);

    //设置维保待完成，维保计划指定和维保过期的提醒
    [MaintenanceReminder setDeadLineReminderByIntervalSecons:deadLineMin];
}

- (long long)setPlanDoneReminder:(NSArray *)array {

    long long deadLineMin = LONG_LONG_MAX;

    if (0 == array.count) {
        return deadLineMin;
    }

    long long planDoneMin = LONG_LONG_MAX;

    //查找维保待完成的电梯距离现在最近的时间间隔
    for (NSDictionary *dic in array) {
        NSString *planMainTime = [dic objectForKey:@"planMainTime"];

        if (0 == planMainTime.length) {
            return planDoneMin;
        }
        NSString *planMainDateString = [dic objectForKey:@"planMainTime"];
        NSDate *planMainDate = [DateUtil yyyyMMddFromString:planMainDateString];
        long long planDoneinterval = [MaintenanceReminder
                getPlanDoneReminderIntervalSecondsFromNowToDeadDate:planMainDate];
        if (planDoneinterval < planDoneMin) {
            planDoneMin = planDoneinterval;
        }

        //查找距离最近的维保过期电梯
        NSString *lastMainDateString = [dic objectForKey:@"lastMainTime"];
        if (lastMainDateString.length != 0) {
            NSDate *lastMainDate = [DateUtil yyyyMMddFromString:lastMainDateString];
            long long deadLineInterval = [MaintenanceReminder
                    getDeadLineReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
            if (deadLineInterval < deadLineMin) {
                deadLineMin = deadLineInterval;
            }
        }
    }

    [MaintenanceReminder setPlanDoneReminderByIntervalSecons:planDoneMin];
    return deadLineMin;
}

- (long long)setPlanMakeReminder:(NSArray *)array {

    long long deadLineMin = LONG_LONG_MAX;

    if (0 == array.count) {
        return deadLineMin;
    }

    long long planMakeMin = LONG_LONG_MAX;
    for (NSDictionary *dic in array) {

        //查找需要制定计划的电梯距离现在最近的时间间隔
        NSString *lastMainDateString = [dic objectForKey:@"lastMainTime"];
        if (lastMainDateString.length != 0) {
            NSDate *lastMainDate = [DateUtil yyyyMMddFromString:lastMainDateString];

            long long planMakeInterval = [MaintenanceReminder
                    getPlanMakeReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
            if (planMakeInterval < planMakeMin) {
                planMakeMin = planMakeInterval;
            }

            //查找距离最近的维保过期电梯
            long long deadLineInterval = [MaintenanceReminder
                    getDeadLineReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
            if (deadLineInterval < deadLineMin) {
                deadLineMin = deadLineInterval;
            }
        }
    }

    [MaintenanceReminder setPlanMakeReminderByIntervalSecons:planMakeMin];
    return deadLineMin;
}
@end
