//
//  MaintOrderController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "MaintOrderController.h"
#import "MainOrderInfoView.h"
#import "ListDialogView.h"
#import "MainTaskCell.h"
#import "MaintInfoController.h"
#import "ListDialogData.h"

@interface MaintOrderController () <UITableViewDelegate, UITableViewDataSource, MainOrderInfoViewDelegate, ListDialogViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MainOrderInfoView *infoView;

@property (strong, nonatomic) NSMutableArray *arrayTask;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@property (strong, nonatomic) NSDictionary *maintOrderInfo;


@end

@implementation MaintOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"维保订单"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMaintOrder];
}

- (NSMutableArray *)arrayOrder {
    if (!_arrayOrder) {
        _arrayOrder = [NSMutableArray array];
    }

    return _arrayOrder;
}

- (NSMutableArray *)arrayTask {
    if (!_arrayTask) {
        _arrayTask = [NSMutableArray array];
    }

    return _arrayTask;
}


- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    //维保记录
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    //显示服务订单信息
    _infoView = [MainOrderInfoView viewFromNib];

    _tableView.tableHeaderView = _infoView;

    _infoView.delegate = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];

}

/**
 设置订单信息
 
 @param maintOrdeinFO
 */
- (void)setMaintOrderInfo:(NSDictionary *)maintOrderInfo {
    _maintOrderInfo = maintOrderInfo;

    if (_infoView) {
        _infoView.lbAddress.text = _maintOrderInfo[@"cellName"];
    }

    [self getTask];
}

- (void)getMaintOrder {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"cellName"] = @"北京市望京soho";

    dic1[@"name"] = @"全能大管家";

    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    dic2[@"cellName"] = @"北京市望京soho1";

    dic2[@"name"] = @"全能小管家";

    [self.arrayOrder removeAllObjects];
    [self.arrayOrder addObject:dic1];
    [self.arrayOrder addObject:dic2];

    [self initOrderView];
}

- (void)initOrderView {
    if (0 == self.arrayOrder.count) {
        //当没有维保信息时，提示
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 120, self.screenWidth - 32, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;

        label.text = @"您还没有需要处理的维保服务";

        self.tableView.tableHeaderView = label;

        [self.arrayTask removeAllObjects];

        [self.tableView reloadData];

        return;
    }

    if (1 == self.arrayOrder.count) {
        _infoView.btnChange.hidden = YES;
    }
    _maintOrderInfo = self.arrayOrder[0];

    _infoView.lbAddress.text = _maintOrderInfo[@"cellName"];
    _infoView.lbName.text = _maintOrderInfo[@"name"];
}

- (void)showOrderList {
    if (0 == self.arrayOrder.count || 1 == self.arrayOrder.count) {
        return;
    }

    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *info in self.arrayOrder) {
        ListDialogData *data = [[ListDialogData alloc] initWithKey:info[@"id"] content:info[@"cellName"]];
        [array addObject:data];
    }

    ListDialogView *dialog = [ListDialogView viewFromNib];
    dialog.delegate = self;
    [dialog setData:array];
    [dialog show];

}

#pragma mark - LisDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content {
    for (NSDictionary *info in self.arrayOrder) {
        if ([key isEqualToString:info[@"id"]]) {
            self.maintOrderInfo = info;
            break;
        }
    }
}


- (void)getTask {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"maintOrderId"] = _maintOrderInfo[@"id"];


    [[HttpClient sharedClient] post:nil parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

    }];
}

//0待确认 1已确认 2已完成 3已评价
- (NSString *)getStateDes:(NSInteger)state {
    NSString *res = @"";

    switch (state) {
        case 0:
            res = @"待确认";
            break;

        case 1:
            res = @"已确认";
            break;

        case 2:
            res = @"已出发";
            break;

        case 3:
            res = @"已到达";
            break;

        case 4:
            res = @"已完成";
            break;

        case 5:
            res = @"已评价";
            break;

        default:
            break;
    }

    return res;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainTaskCell identifier]];

    if (!cell) {
        cell = [MainTaskCell cellFromNib];
    }

    NSDictionary *info = _arrayTask[indexPath.row];


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MainTaskCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MaintInfoController *controller = [[MaintInfoController alloc] init];
    controller.maintInfo = _arrayTask[indexPath.row];

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - MainOrderViewDelegate

- (void)onClickLinkButton:(MainOrderInfoView *)view {

}

- (void)onClickPlanButton:(MainOrderInfoView *)view {
    MaintInfoController *controller = [[MaintInfoController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickChangeButton:(MainOrderInfoView *)view {
    [self showOrderList];
}

- (void)onClickDetailButton:(MainOrderInfoView *)view {

}

@end
