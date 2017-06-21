//
//  RecordViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "RecordViewController.h"
#import "HttpClient.h"
#import "PlanViewController.h"
#import "AlarmViewController.h"

#pragma mark -- PlanCell

@interface PlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *planDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *planTypeLabel;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

@implementation PlanCell


@end


#pragma mark --  RecordViewController

@interface RecordViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"记录上传"];
    [self initView];
    _dataArray = [[NSMutableArray alloc] init];
}


- (void)initView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)getElevatorList
{

    [[HttpClient sharedClient] view:self.view post:@"getMainElevatorList" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [self dealHttpData:[responseObject objectForKey:@"body"]];
                            }];
}

- (void)dealHttpData:(NSArray *)array
{

    [_dataArray removeAllObjects];
    for (NSDictionary *dic in array)
    {

        NSString *flag = [dic objectForKey:@"planMainTime"];
        if (flag.length > 0)
        {
            [_dataArray addObject:dic];
        }
    }

    if (0 == _dataArray.count)
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您还没有需要完成的维保计划!";
        [self.view addSubview:label];
        //return;
    }
    [self.tableView reloadData];
}

- (NSString *)getDescriptionByType:(NSString *)type
{
    NSString *description = nil;
    if ([type isEqualToString:@"hm"])
    {
        description = @"半月保";
    }
    else if ([type isEqualToString:@"m"])
    {
        description = @"月保";
    }
    else if ([type isEqualToString:@"s"])
    {
        description = @"季度保";
    }
    else if ([type isEqualToString:@"hy"])
    {
        description = @"半年保";
    }
    else if ([type isEqualToString:@"y"])
    {
        description = @"年保";
    }
    return description;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getElevatorList];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plan_cell"];

    NSDictionary *info = _dataArray[indexPath.row];

    NSDate *now = [NSDate date];

    NSDate *planDate = [DateUtil yyyyMMddFromString:info[@"planMainTime"]];

    NSInteger intervalDay = [DateUtil getIntervalDaysFromStart:now end:planDate];

    NSString *intervalStr = [NSString stringWithFormat:@"%ld", intervalDay];

    if (-1 == intervalDay)
    {
        intervalStr = @"过期";
    }

    cell.dayLabel.text = intervalStr;

    cell.codeLabel.text = [info objectForKey:@"num"];
    cell.addressLabel.text = [info objectForKey:@"address"];
    cell.planDateLabel.text = [info objectForKey:@"planMainTime"];
    NSString *type = [info objectForKey:@"planMainType"];
    cell.planTypeLabel.text = [self getDescriptionByType:type];

    cell.editBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editPlan:) forControlEvents:UIControlEventTouchUpInside];

    cell.delBtn.tag = indexPath.row;
    [cell.delBtn addTarget:self action:@selector(delPlan:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = _dataArray[indexPath.row];
    NSString *proFlag = [info objectForKey:@"propertyFlg"];
    if ([proFlag isEqualToString:@"3"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"物业已经拒绝，请您和物业沟通，修改维保计划！"
                                                       delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    PlanViewController *controller = [board instantiateViewControllerWithIdentifier:@"plan_controller"];
    controller.flag = @"complete";
    controller.liftId = [info objectForKey:@"id"];
    controller.liftNum = [info objectForKey:@"num"];
    controller.address = [info objectForKey:@"address"];
    controller.mainDate = [info objectForKey:@"mainDate"];
    controller.mainType = [info objectForKey:@"mainType"];
    controller.planMainDate = [info objectForKey:@"planMainTime"];
    controller.planMainType = [info objectForKey:@"planMainType"];

    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)editPlan:(UIButton *)button
{
    NSLog(@"edit");

    NSDictionary *info = _dataArray[button.tag];

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    PlanViewController *controller = [board instantiateViewControllerWithIdentifier:@"plan_controller"];
    controller.flag = @"edit";
    controller.liftId = [info objectForKey:@"id"];
    controller.liftNum = [info objectForKey:@"num"];
    controller.address = [info objectForKey:@"address"];
    controller.mainDate = [info objectForKey:@"mainDate"];
    controller.mainType = [info objectForKey:@"mainType"];
    controller.planMainDate = [info objectForKey:@"planMainTime"];
    controller.planMainType = [info objectForKey:@"planMainType"];

    [self.navigationController pushViewController:controller animated:YES];

}

- (void)delPlan:(UIButton *)button
{
    NSLog(@"delete");

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您即将删除此条维保计划?" delegate:self
                                          cancelButtonTitle:nil otherButtonTitles:@"取消", @"确定", nil];
    alert.tag = button.tag;
    [alert show];

}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (ALARM_RECEIVED == alertView.tag || ALARM_ASSIGNED == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
            AlarmViewController *controller = [board instantiateViewControllerWithIdentifier:@"alarm_process"];
            controller.alarmId = self.notifyAlarmId;

            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else
    {
        if (0 == buttonIndex)
        {
            return;
        }
        else if (1 == buttonIndex)
        {
            NSInteger tag = alertView.tag;
            NSDictionary *info = _dataArray[tag];
            NSString *liftId = [info objectForKey:@"id"];

            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
            [param setValue:liftId forKey:@"id"];

            __weak typeof(self) weakSelf = self;

            [[HttpClient sharedClient] view:self.view post:@"removeMainPlan" parameter:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                        //删除维保中拍摄但是没有提交的照片
                                        NSString *liftNum = [info objectForKey:@"num"];
                                        NSString *path1 = [NSHomeDirectory() stringByAppendingPathComponent:
                                                [[NSString alloc] initWithFormat:@"Documents/%@/0", liftNum]];

                                        NSString *path2 = [NSHomeDirectory() stringByAppendingPathComponent:
                                                [[NSString alloc] initWithFormat:@"Documents/%@/1", liftNum]];


                                        NSString *path3 = [NSHomeDirectory() stringByAppendingPathComponent:
                                                [[NSString alloc] initWithFormat:@"Documents/%@/2", liftNum]];

                                        [self deleteFileByPath:path1];
                                        [self deleteFileByPath:path2];
                                        [self deleteFileByPath:path3];

                                        //更新视图
                                        [_dataArray removeObjectAtIndex:tag];


                                        [weakSelf.tableView reloadData];
                                        [HUDClass showHUDWithLabel:@"您已经删除此条维保计划，请及时到维保计划中制定计划" view:weakSelf.view];

                                    }];
        }
    }

}

/**
 删除指定路径下的文件
 **/
- (void)deleteFileByPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:path];

    if (exist)
    {
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
    }
}
@end
