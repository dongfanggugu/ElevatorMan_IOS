//
//  RepairPayController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import "RepairPayController.h"
#import "RepairPayAddView.h"
#import "RepairPayHeaderView.h"
#import "RepairPayCell.h"
#import "RepairPayFooterView.h"


@interface RepairPayController () <UITableViewDelegate, UITableViewDataSource, RepairPayHeaderViewDelegate,
RepairPayAddViewDelegate, RepairPayFooterViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayPay;

@property (strong, nonatomic) RepairPayFooterView *footerView;

@property (assign, nonatomic) CGFloat total;

@end

@implementation RepairPayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"收费清单"];
    [self initView];
}

- (NSMutableArray *)arrayPay
{
    if (!_arrayPay) {
        _arrayPay = [NSMutableArray array];
    }
    
    return _arrayPay;
}

- (CGFloat)total
{
    CGFloat total = 0.0f;
    
    for (NSDictionary *info in self.arrayPay) {
        total += [info[@"fee"] floatValue];
    }
    
    return total;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    
    //头
    RepairPayHeaderView *headerView = [RepairPayHeaderView viewFromNib];
    headerView.delegate = self;
    
    _tableView.tableHeaderView = headerView;
    
    //尾
    _footerView = [RepairPayFooterView viewFromNib];
    _footerView.delegate = self;
    _footerView.lbTotal.text = @"￥0.00";
    
    _tableView.tableFooterView = _footerView;
}

- (void)delItem:(NSInteger)index
{
    [self.arrayPay removeObjectAtIndex:index];
    [_tableView reloadData];
    
    _footerView.lbTotal.text = [NSString stringWithFormat:@"￥%.2lf", self.total];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayPay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairPayCell *cell = [tableView dequeueReusableCellWithIdentifier:[RepairPayCell identifier]];
    
    if (!cell) {
        cell = [RepairPayCell cellFromNib];
    }
 
    NSDictionary *info = self.arrayPay[indexPath.row];
    
    cell.lbItem.text = info[@"name"];
    cell.lbMoney.text = [NSString stringWithFormat:@"￥%.2lf", [info[@"price"] floatValue]];
    
    
    __weak typeof (self) weakSelf = self;
    
    [cell setOnClickDel:^{
        [weakSelf delItem:indexPath.row];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RepairPayCell cellHeight];
}

#pragma mark - RepairHeaderViewDelegate

- (void)onClickAdd
{
    RepairPayAddView *dialog = [RepairPayAddView viewFromNib];
    
    dialog.delegate = self;
    
    [dialog show];
}

#pragma mark - RepairAddViewDelegate

- (void)onClickConfirm:(NSString *)item fee:(CGFloat)money
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:item, @"name", [NSNumber numberWithFloat:money], @"price",
                    _orderInfo[@"id"], @"repairOrderId", nil];
    
    [self.arrayPay addObject:dic];
    
    [self.tableView reloadData];
    
    _footerView.lbTotal.text = [NSString stringWithFormat:@"￥%.2lf", self.total];
}

#pragma mark - RepairPayFooterViewDelegate

- (void)onClickSubmit
{
    __weak typeof (self) weakSelf = self;

    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"已经和客户协商并确认提交维修费用明细?" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf submitPay];
    }]];

    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)submitPay
{

    if (0 == self.arrayPay)
    {
        [HUDClass showHUDWithLabel:@"请添加维修收费项目"];

        return;
    }

    [[HttpClient sharedClient] post:@"addPriceDetails" parameter:self.arrayPay success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUDClass showHUDWithLabel:@"维修明细提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
