//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintDetailController.h"
#import "MainOrderDetailCell.h"

@interface MaintDetailController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MaintDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth,
            self.screenHeight - 118)];

    tableView.delegate = self;

    tableView.dataSource = self;

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainOrderDetailCell *cell = [MainOrderDetailCell cellFromNib];

    cell.lbCode.text = [NSString stringWithFormat:@"订单编号:%@", _orderInfo[@"code"]];

    cell.lbDate.text = [NSString stringWithFormat:@"下单时间:%@", _orderInfo[@"createTime"]];

    NSString *payType = [_orderInfo[@"mainttypeInfo"] objectForKey:@"name"];

    cell.lbName.text = [NSString stringWithFormat:@"服务类型:%@", payType];

    cell.lbContent.text = [_orderInfo[@"mainttypeInfo"] objectForKey:@"content"];

    cell.lbBrand.text = [NSString stringWithFormat:@"电梯品牌:%@", _orderInfo[@"villaInfo"][@"brand"]];

    cell.lbAddress.text = [NSString stringWithFormat:@"别墅地址:%@", _orderInfo[@"villaInfo"][@"cellName"]];


    cell.lbAmount.text = [NSString stringWithFormat:@"%ld", [_orderInfo[@"frequency"] integerValue]];


    CGFloat price = [[_orderInfo[@"mainttypeInfo"] objectForKey:@"price"] floatValue];

    cell.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", price];

    cell.lbDiscourt.text = @"￥0";

    cell.lbPay.text = [NSString stringWithFormat:@"￥%.2lf", [_orderInfo[@"payMoney"] floatValue]];

    cell.lbPayType.text = @"在线支付";

    NSInteger isPay = [_orderInfo[@"isPay"] integerValue];

    if (isPay)
    {
        cell.lbPayState.text = @"已经支付";
        cell.lbPayDate.text = _orderInfo[@"payTime"];
        cell.btn.hidden = YES;

    }
    else
    {

        NSInteger delete = [[_orderInfo[@"maintOrderInfo"] objectForKey:@"isDelete"] integerValue];

        if (delete)
        {
            cell.lbPayState.text = @"已过期";
            cell.lbPayDate.text = @"--";
            cell.btn.hidden = YES;

        }
        else
        {
            cell.lbPayState.text = @"未支付";
            cell.lbPayDate.text = @"--";
            cell.btn.hidden = NO;

            [cell.btn addTarget:self action:@selector(payment) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainOrderDetailCell cellHeight];
}

- (void)payment
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickPay)])
    {
        [_delegate onClickPay];
    }
}

@end