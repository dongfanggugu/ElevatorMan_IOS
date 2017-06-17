//
// Created by changhaozhang on 2017/6/17.
//

#import "HouseRepairOrderDetailController.h"
#import "RepairInfoView.h"
#import "KeyboardManager.h"

@interface HouseRepairOrderDetailController () <UITableViewDelegate, UITableViewDataSource, RepairInfoViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) RepairInfoView *repairInfoView;

@end;

@implementation HouseRepairOrderDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维修订单"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

    [self showView];

    _tableView.tableHeaderView = _repairInfoView;

    [self.view addSubview:_tableView];
}

- (void)showView
{
    _repairInfoView.btnTask.hidden = YES;

    _repairInfoView.btnPay.hidden = YES;

    _repairInfoView.btnEvaluate.hidden = YES;

    _repairInfoView.ivTitleTask.hidden = YES;

    _repairInfoView.lbTitleTask.hidden = YES;

    _repairInfoView.viewSeparator.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return nil;
}



@end