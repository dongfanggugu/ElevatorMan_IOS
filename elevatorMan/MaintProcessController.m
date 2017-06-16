//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintProcessController.h"
#import "ProcessCell.h"

@interface MaintProcessController () <UITableViewDelegate, UITableViewDataSource>



@end

@implementation MaintProcessController

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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProcessCell *cell = [ProcessCell cellFromNib];
    switch (indexPath.row)
    {
        case 0:
            cell.isHere = YES;
            cell.lbProcess.text = @"订单已创建";
            cell.location = Location_Head;
            cell.lbDes.text = @"";
            cell.lbTime.text = _orderInfo[@"createTime"];
            break;

        case 1:
            cell.isHere = YES;
            cell.lbProcess.text = @"订单已提交";
            cell.location = Location_Middle;
            cell.lbDes.text = @"";
            cell.lbTime.text = _orderInfo[@"createTime"];
            break;

        case 2:
            cell.isHere = [_orderInfo[@"isPay"] boolValue];
            cell.lbProcess.text = @"订单已付款";
            cell.location = Location_Middle;
            cell.lbDes.text = @"";
            cell.lbTime.text = _orderInfo[@"payTime"];
            break;

        case 3:
            cell.isHere = [_orderInfo[@"isPay"] boolValue];
            cell.lbProcess.text = @"订单处理中";
            cell.location = Location_Middle;

            cell.lbDes.text = @"";
            if ([_orderInfo[@"isPay"] boolValue]) {
               cell.lbDes.text = @"正由维保公司安排维保任务";
            }
            cell.lbTime.text = _orderInfo[@"payTime"];
            break;

        case 4:
            cell.isHere = [_orderInfo[@"isPay"] boolValue];
            cell.lbProcess.text = @"订单已处理";
            cell.location = Location_Middle;

            cell.lbDes.text = @"";
            if ([_orderInfo[@"isPay"] boolValue]) {
                cell.lbDes.text = @"您的维保计划已经生成";
                [cell setOnClickBtn:^ {
                    NSLog(@"查看维保计划");
                }];
            }
            cell.lbTime.text = _orderInfo[@"payTime"];
            break;

        case 5:
            cell.isHere = NO;
            cell.lbProcess.text = @"感谢您的使用";
            cell.location = Location_Middle;
            cell.lbDes.text = @"";
            cell.lbTime.text = @"";
            break;

        case 6:
            cell.isHere = NO;
            cell.lbProcess.text = @"投诉建议";
            cell.location = Location_Tail;
            cell.lbDes.text = @"";
            cell.lbTime.text = @"";
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProcessCell cellHeight];
}

@end