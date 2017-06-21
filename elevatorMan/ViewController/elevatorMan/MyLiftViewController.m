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

@interface MyLiftViewController () <UITableViewDelegate, UITableViewDataSource>

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

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    [self.dataArray removeAllObjects];

    if (TYPE_ALL == _liftType)
    {
        [self.dataArray addObjectsFromArray:array];

        if (0 == self.dataArray.count)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 40)];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"您还没有绑定电梯，请联系您的维保主管进行电梯绑定!";
            self.tableView.tableHeaderView = label;
        }
        [self.tableView reloadData];
    }
    else
    {
        for (NSDictionary *dic in array)
        {
            NSString *planMainTime = [dic objectForKey:@"planMainTime"];
            if (0 == planMainTime.length)
            {
                [self.dataArray addObject:dic];
            }
        }
        if (0 == self.dataArray.count)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 40)];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"您没有需要制定维保计划的电梯!";
            self.tableView.tableHeaderView = label;
        }

        [self.tableView reloadData];
    }
}


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
        controller.project = [info objectForKey:@"communityName"];
        controller.address = [info objectForKey:@"address"];
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
