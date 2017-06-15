//
//  RepairOrderDetailController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "RepairOrderDetailController.h"
#import "RepairInfoView.h"
#import "RepairTaskCell.h"
#import "EvaluateController.h"
#import "RepairProcessController.h"
#import "RepairTaskMakeController.h"
#import "RepairPayController.h"
#import "RepairSubmitController.h"
#import "RepairResultController.h"


@interface RepairOrderDetailController () <UITableViewDelegate, UITableViewDataSource, RepairInfoViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) RepairInfoView *repairInfoView;

@property (strong, nonatomic) NSMutableArray *arrayTask;

@end

@implementation RepairOrderDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维修任务"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTask];
}

- (NSMutableArray *)arrayTask
{
    if (!_arrayTask)
    {
        _arrayTask = [NSMutableArray array];
    }

    return _arrayTask;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _repairInfoView = [RepairInfoView viewFromNib];

    _repairInfoView.delegate = self;

    _repairInfoView.lbCode.text = [NSString stringWithFormat:@"订单编号: %@", _orderInfo[@"code"]];

    _repairInfoView.lbDate.text = [NSString stringWithFormat:@"订单时间: %@", _orderInfo[@"createTime"]];

    _repairInfoView.lbAppoint.text = [NSString stringWithFormat:@"预约时间: %@", _orderInfo[@"repairTime"]];

    _repairInfoView.lbFault.text = [NSString stringWithFormat:@"故障类型: %@", _orderInfo[@"repairTypeInfo"][@"name"]];


    _repairInfoView.lbFaultDes.text = _orderInfo[@"repairTypeInfo"][@"content"];

     [_repairInfoView.ivFault setImageWithURL:[NSURL URLWithString:_orderInfo[@"picture"]]];

    _repairInfoView.lbAddress.text = [NSString stringWithFormat:@"别墅地址: %@", _orderInfo[@"villaInfo"][@"cellName"]];

    _repairInfoView.lbBrand.text = [NSString stringWithFormat:@"电梯品牌: %@", _orderInfo[@"villaInfo"][@"brand"]];

    _repairInfoView.lbWeight.text = [NSString stringWithFormat:@"电梯载重量: %.0lfkg    层站:%d层",
                    [_orderInfo[@"villaInfo"][@"weight"] floatValue], [_orderInfo[@"villaInfo"][@"layerAmount"] integerValue]];

    NSInteger state = _orderInfo[@"state"];
    [self showViewWithState:state];

    _tableView.tableHeaderView = _repairInfoView;

    [self.view addSubview:_tableView];
}

- (void)showViewWithState:(NSInteger)state
{
    switch (state)
    {
        case 4:
            [self state4];
            break;

        case 6:
            [self state6];
            break;

        case 7:
            [self state7];
            break;

        case 8:
            [self state8];
            break;

        case 9:
            [self state9];
            break;

        default:
            break;
    }
}


/**
 已委派
 */
- (void)state4
{
    _repairInfoView.btnTask.hidden = YES;

    _repairInfoView.btnPay.hidden = YES;

    _repairInfoView.btnEvaluate.hidden = YES;
}

/**
 维修中
 */
- (void)state6
{
    _repairInfoView.btnTask.hidden = NO;

    _repairInfoView.btnPay.hidden = NO;

    _repairInfoView.btnEvaluate.hidden = YES;
}

/**
支付单生成
 */
- (void)state7
{
    _repairInfoView.btnTask.hidden = NO;

    _repairInfoView.btnPay.hidden = YES;

    _repairInfoView.btnEvaluate.hidden = YES;
}

/**
 维修完成
 */
- (void)state8
{
    _repairInfoView.btnTask.hidden = NO;

    _repairInfoView.btnPay.hidden = YES;

    _repairInfoView.btnEvaluate.hidden = YES;
}


- (void)state9
{
    _repairInfoView.btnTask.hidden = NO;

    _repairInfoView.btnPay.hidden = YES;

    _repairInfoView.btnEvaluate.hidden = NO;
}


//1待出发 2已出发 3工作中 5检修完成 6维修完成
- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";

    switch (state)
    {
        case 1:
            res = @"待出发";
            break;
        case 2:
            res = @"已出发";
            break;
        case 3:
            res = @"已到达";
            break;
        case 5:
            res = @"检修完成";
            break;
        case 6:
            res = @"维修完成";
            break;

        default:
            break;
    }

    return res;
}

#pragma mark - Network Request

- (void)getTask
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"repairOrderId"] = _orderInfo[@"id"];

    [[HttpClient sharedClient] post:@"getRepairOrderProcessByRepairOrder" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.arrayTask removeAllObjects];
        [self.arrayTask addObjectsFromArray:responseObject[@"body"]];

        [self.tableView reloadData];
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[RepairTaskCell identifier]];

    if (!cell)
    {
        cell = [RepairTaskCell cellFromNib];
    }

    NSDictionary *info = self.arrayTask[indexPath.row];

    cell.lbCode.text = info[@"code"];

    cell.lbState.text = [self getStateDes:[info[@"state"] integerValue]];

    cell.lbWorker.text = [NSString stringWithFormat:@"维修人员:%@", info[@"workerInfo"][@"name"]];

    cell.lbTel.text = [NSString stringWithFormat:@"联系电话:%@", info[@"workerInfo"][@"tel"]];

    cell.lbDate.text = [NSString stringWithFormat:@"维修时间:%@", info[@"planTime"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.arrayTask[indexPath.row];

    NSInteger state = [info[@"state"] integerValue];

    if (0 == state) //待出发
    {
        RepairProcessController *controller = [[RepairProcessController alloc] init];
        controller.taskInfo = info;
        controller.process = Repair_Start;

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (1 == state)    //已出发
    {
        RepairProcessController *controller = [[RepairProcessController alloc] init];
        controller.taskInfo = info;
        controller.process = Repair_Arrive;

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (3 == state)    //已到达
    {
        RepairSubmitController *controller = [[RepairSubmitController alloc] init];
        controller.taskInfo = info;

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (5 == state || 6 == state)    //检修完成
    {
        RepairResultController *controller = [[RepairResultController alloc] init];
        controller.repairResult = info[@"finishResult"];
        controller.urls = info[@"pictures"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RepairTaskCell cellHeight];
}


- (void)onClickEvaluate
{
    EvaluateController *controller = [[EvaluateController alloc] init];
    controller.content = _orderInfo[@"evaluateInfo"];
    controller.star = [_orderInfo[@"evaluate"] integerValue];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickPay
{
    RepairPayController *controller = [[RepairPayController alloc] init];
    controller.orderInfo = _orderInfo;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickTask
{
    RepairTaskMakeController *controller = [[RepairTaskMakeController alloc] init];
    controller.orderInfo = _orderInfo;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
