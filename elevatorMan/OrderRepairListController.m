//
// Created by changhaozhang on 2017/6/13.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderRepairListController.h"
#import "OrderMaintCell.h"
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

    cell.lbState.text = @"未支付";

    BOOL isPay = [orderInfo[@"isPay"] boolValue];

    if (isPay)
    {
        cell.lbState.text = @"已支付";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderMaintCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 20;
}

@end