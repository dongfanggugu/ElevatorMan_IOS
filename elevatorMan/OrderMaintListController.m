//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderMaintListController.h"
#import "OrderMaintCell.h"
#import "OrderMaintDetailController.h"

@interface OrderMaintListController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@end

@implementation OrderMaintListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保订单"];
    [self initView];
    [self getOrders];
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
}/**
 id  支付ID
 type 1维保2维修3一元保障
 frequency 购买次数
 payMoney 付款金额
 payTime 付款时间
 smallOwnerId 业主ID
 mainttypeId 维保类型ID 1.按次服务 2.智能小管家服务 3.全能大管家服务
 isPay 0未付1已付
 createTime 创建时间
 code 支付编号
 name 名称
 tel 电话
 address 地址
 */
- (void)getOrders
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;
    params[@"page"] = [NSNumber numberWithInteger:1];
    params[@"rows"] = [NSNumber numberWithInteger:100];


    [[HttpClient sharedClient] post:@"getPaymentByBranchId" parameter:params success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self.arrayOrder removeAllObjects];

        [self.arrayOrder addObjectsFromArray:[responseObject objectForKey:@"body"]];

        [self.tableView reloadData];
    }];
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
    cell.lbType.text = [orderInfo[@"mainttypeInfo"] objectForKey:@"name"];

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
    NSDictionary *info = self.arrayOrder[indexPath.section];

    OrderMaintDetailController *controller = [[OrderMaintDetailController alloc] init];
    controller.orderInfo = info;

    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 20;
}

@end