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
    
    cell.lbItem.text = info[@"item"];
    cell.lbMoney.text = [NSString stringWithFormat:@"￥%.2lf", [info[@"fee"] floatValue]];
    
    
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:item, @"item", [NSNumber numberWithFloat:money], @"fee", nil];
    
    [self.arrayPay addObject:dic];
    
    [self.tableView reloadData];
    
    _footerView.lbTotal.text = [NSString stringWithFormat:@"￥%.2lf", self.total];
}

#pragma mark - RepairPayFooterViewDelegate

- (void)onClickSubmit
{
    NSLog(@"提交");
}

@end
