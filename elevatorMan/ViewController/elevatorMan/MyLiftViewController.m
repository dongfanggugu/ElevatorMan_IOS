//
//  MyLiftViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "MyLiftViewController.h"
#import "HttpClient.h"
#import "MaintenanceReminder.h"
#import "DateUtil.h"
#import "LiftDetailViewController.h"
#import "PlanViewController.h"

@interface LiftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation LiftCell



@end

#pragma mark -- MyLiftViewController

@interface MyLiftViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation MyLiftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (TYPE_ALL == _liftType)
    {
        [self setNavTitle:@"我的电梯"];
    }
    else
    {
        [self setNavTitle:@"维保计划"];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getElevatorList];
}


- (void)getElevatorList
{
    
    __weak typeof(self) weakSelf = self;
    [[HttpClient sharedClient] view:self.view post:@"getMainElevatorList" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"result:%@", responseObject);
                                [weakSelf dealHttpData:[responseObject objectForKey:@"body"]];
                            }];
}

/**
 *  将电梯维保信息分类并展示
 *
 *  @param array
 */
- (void)dealHttpData:(NSArray *)array
{
    if (TYPE_ALL == _liftType)
    {
        _dataArray = array.mutableCopy;
      
        if (0 == _dataArray.count)
        {
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"您还没有绑定电梯，请联系您的维保主管进行电梯绑定!";
            [self.view addSubview:label];
            return;
        }
    
    }
    else
    {
        _dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array)
        {
            NSString *planMainTime = [dic objectForKey:@"planMainTime"];
            if (0 == planMainTime.length)
            {
                [_dataArray addObject:dic];
            }
            
        }
        
//        if (0 == _dataArray.count)
//        {
//            CGFloat width = [UIScreen mainScreen].bounds.size.width;
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
//            label.font = [UIFont systemFontOfSize:15];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.text = @"您还没有需要制定维保计划的电梯!";
//            [self.view addSubview:label];
//            return;
//        }
    }
    [self.tableView reloadData];
}
//- (void)setReminder:(NSArray *)array
//{
//    long long deadLineMin = MIN([self setPlanDoneReminder], [self setPlanMakeReminder]);
//    //设置维保待完成，维保计划指定和维保过期的提醒
//    [MaintenanceReminder setDeadLineReminderByIntervalSecons:deadLineMin];
//}
//
//- (long long)setPlanDoneReminder:(NSArray *)array
//{
//    
//    long long deadLineMin = LONG_LONG_MAX;
//    
//    if (0 == array.count) {
//        return deadLineMin;
//    }
//    
//    long long planDoneMin = LONG_LONG_MAX;
//    
//    //查找维保待完成的电梯距离现在最近的时间间隔
//    for (NSDictionary *dic in array)
//    {
//        NSString *planMainTime = [dic objectForKey:@"planMainTime"];
//        if (0 == planMainTime.length)
//        {
//            return planDoneMin;
//        }
//        NSString *planMainDateString = [dic objectForKey:@"planMainTime"];
//        NSDate *planMainDate = [DateUtil yyyyMMddFromString:planMainDateString];
//        long long planDoneinterval = [MaintenanceReminder
//                                      getPlanDoneReminderIntervalSecondsFromNowToDeadDate:planMainDate];
//        if (planDoneinterval < planDoneMin) {
//            planDoneMin = planDoneinterval;
//        }
//        
//        //查找距离最近的维保过期电梯
//        NSString *lastMainDateString = [dic objectForKey:@"lastMainTime"];
//        if (lastMainDateString.length != 0) {
//            NSDate *lastMainDate = [DateUtil yyyyMMddFromString:lastMainDateString];
//            long long deadLineInterval = [MaintenanceReminder
//                                          getDeadLineReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
//            if (deadLineInterval < deadLineMin) {
//                deadLineMin = deadLineInterval;
//            }
//        }
//    }
//    
//    [MaintenanceReminder setPlanDoneReminderByIntervalSecons:planDoneMin];
//    return deadLineMin;
//}
//
//- (long long)setPlanMakeReminder
//{
//    
//    long long deadLineMin = LONG_LONG_MAX;
//    if (0 == self.planUndoList.count) {
//        return deadLineMin;
//    }
//    
//    long long planMakeMin = LONG_LONG_MAX;
//    for (NSDictionary *dic in self.planUndoList) {
//        //查找需要制定计划的电梯距离现在最近的时间间隔
//        NSString *lastMainDateString = [dic objectForKey:@"lastMainTime"];
//        if (lastMainDateString.length != 0) {
//            NSDate *lastMainDate = [DateUtil yyyyMMddFromString:lastMainDateString];
//            long long planMakeInterval = [MaintenanceReminder
//                                          getPlanMakeReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
//            if (planMakeInterval < planMakeMin) {
//                planMakeMin = planMakeInterval;
//            }
//            
//            //查找距离最近的维保过期电梯
//            long long deadLineInterval = [MaintenanceReminder
//                                          getDeadLineReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
//            if (deadLineInterval < deadLineMin) {
//                deadLineMin = deadLineInterval;
//            }
//        }
//    }
//    
//    [MaintenanceReminder setPlanMakeReminderByIntervalSecons:planMakeMin];
//    return deadLineMin;
//}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lift_cell"];
    
    NSDictionary *info = _dataArray[indexPath.row];
    cell.codeLabel.text = [info objectForKey:@"num"];
    cell.addressLabel.text = [info objectForKey:@"address"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = _dataArray[indexPath.row];
    
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    
    if (TYPE_ALL == _liftType)
    {
        LiftDetailViewController *controller = [board instantiateViewControllerWithIdentifier:@"lift_detail"];
        controller.liftCode = [info objectForKey:@"num"];
        controller.project = [info objectForKey:@"project"];
        controller.address = [info objectForKey:@"address"];
        controller.brand = [info objectForKey:@"brand"];
        controller.worker = [User sharedUser].name;
        controller.tel = [User sharedUser].tel;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (TYPE_PLAN == _liftType)
    {
        PlanViewController *controller = [board instantiateViewControllerWithIdentifier:@"plan_controller"];
        controller.flag = @"add";
        controller.liftId = [info objectForKey:@"id"];
        controller.liftNum = [info objectForKey:@"num"];
        controller.address = [info objectForKey:@"address"];
        controller.mainDate = [info objectForKey:@"mainDate"];
        controller.mainType = [info objectForKey:@"mainType"];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

@end
