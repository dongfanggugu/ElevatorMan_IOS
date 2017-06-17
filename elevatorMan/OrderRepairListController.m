//
// Created by changhaozhang on 2017/6/13.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderRepairListController.h"
#import "OrderMaintCell.h"
#import "HouseRepairOrderDetailController.h"
//#import "RepairInfoController.h"

@interface OrderRepairListController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@end

@implementation OrderRepairListController
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"快修订单"];
    [self initView];
    [self getRepair];
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

- (NSMutableArray *)arrayOrder
{
    if (!_arrayOrder)
    {
        _arrayOrder = [NSMutableArray array];
    }

    return _arrayOrder;
}


- (void)getRepair
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;
    params[@"page"] = [NSNumber numberWithInteger:1];
    params[@"rows"] = [NSNumber numberWithInteger:100];

    [[HttpClient sharedClient] post:@"getRepairOrderByBranchId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self.arrayOrder removeAllObjects];
        [self.arrayOrder addObjectsFromArray:responseObject[@"body"]];
        [self.tableView reloadData];
    }];
}

- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";

    if (1 == state)
    {
        res = @"待确认";

    }
    else if (2 == state)
    {
        res = @"已确认";

    }
    else if (4 == state)
    {
        res = @"已委派";

    }
    else if (6 == state)
    {
        res = @"维修中";

    }
    else if (8 == state)
    {
        res = @"维修完成";

    }
    else if (9 == state)
    {
        res = @"已评价";
    }

    return res;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayOrder.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMaintCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderMaintCell identifier]];

    if (!cell)
    {
        cell = [OrderMaintCell cellFromNib];
    }

    NSDictionary *orderInfo = self.arrayOrder[indexPath.section];

    cell.lbCode.text = [NSString stringWithFormat:@"编号: %@", orderInfo[@"code"]];
    cell.lbTime.text = orderInfo[@"createTime"];
    cell.lbName.text = [orderInfo[@"villaInfo"] objectForKey:@"cellName"];

    NSString *fault = [orderInfo[@"repairTypeInfo"] objectForKey:@"name"];
    cell.lbType.text = [NSString stringWithFormat:@"故障类型: %@", fault];

    cell.lbState.text = [self getStateDes:[orderInfo[@"state"] integerValue]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderMaintCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseRepairOrderDetailController *controller = [[HouseRepairOrderDetailController alloc] init];
    controller.orderInfo = self.arrayOrder[indexPath.section];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 20;
}

@end