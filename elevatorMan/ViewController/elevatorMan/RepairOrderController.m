//
//  RepairOrderController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "RepairOrderController.h"
#import "RepairOrderCell.h"
#import "RepairOrderDetailController.h"

@interface RepairOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@end

@implementation RepairOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"怡墅维修"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getOrders];
}

- (NSMutableArray *)arrayOrder
{
    if (!_arrayOrder)
    {
        _arrayOrder = [NSMutableArray array];
    }

    return _arrayOrder;
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


- (void)getOrders
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSNumber numberWithInteger:1];
    params[@"rows"] = [NSNumber numberWithInteger:100];

    [[HttpClient sharedClient] post:@"getRepairOrderByWorker" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.arrayOrder removeAllObjects];
        [self.arrayOrder addObjectsFromArray:responseObject[@"body"]];
        [self showOrders];
    }];


}

- (void)showOrders
{
    if (0 == self.arrayOrder.count)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 120, self.screenWidth - 32, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;

        label.text = @"您还没有需要处理的维修订单";

        self.tableView.tableHeaderView = label;

        [self.arrayOrder removeAllObjects];

        [self.tableView reloadData];

        return;
    }

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:[RepairOrderCell identifier]];

    if (!cell)
    {
        cell = [RepairOrderCell cellFromNib];
    }

    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    NSDictionary *info = self.arrayOrder[indexPath.row];

    cell.lbName.text = info[@"villaInfo"][@"cellName"];

    cell.lbState.text = [self getStateDes:[info[@"state"] integerValue]];

    NSString *name = info[@"villaInfo"][@"contacts"];

    if (0 == name.length)
    {
        name = info[@"smallOwnerInfo"][@"name"];
    }

    NSString *tel = info[@"villaInfo"][@"contactsTel"];

    if (0 == tel.length)
    {
        tel = info[@"smallOwnerInfo"][@"tel"];
    }

    cell.lbLink.text = [NSString stringWithFormat:@"%@/%@", name, tel];

    cell.lbDate.text = [NSString stringWithFormat:@"预约:%@", info[@"repairTime"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RepairOrderCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairOrderDetailController *controller = [[RepairOrderDetailController alloc] init];
    controller.orderInfo = self.arrayOrder[indexPath.row];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
