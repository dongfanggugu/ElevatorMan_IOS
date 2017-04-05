//
//  WRepairProcessController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/12.
//
//

#import <Foundation/Foundation.h>
#import "WRepairProcessController.h"
#import "HttpClient.h"
#import "WRepairCell.h"
#import "WRepairDetailController.h"

@interface WRepairProcessController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayData;

@end

@implementation WRepairProcessController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getProcessList];
}

- (void)initData
{
    _arrayData = [NSMutableArray array];
}

- (void)initView
{
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - Network Request
- (void)getProcessList
{
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient sharedClient] view:self.view post:@"getRepairByWorker" parameter:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.arrayData removeAllObjects];
        [weakSelf.arrayData addObjectsFromArray:[responseObject objectForKey:@"body"]];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRepairCell *cell = [tableView dequeueReusableCellWithIdentifier:[WRepairCell identifier]];
    
    if (!cell)
    {
        cell = [WRepairCell viewFromNib];
    }
    
    NSDictionary *info = _arrayData[indexPath.row];
    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    cell.lbTel.text = [info objectForKey:@"tel"];
    cell.lbCreateTime.text = [info objectForKey:@"createTime"];
    cell.lbDescription.text = [info objectForKey:@"phenomenon"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WRepairCell cellHeigh];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WRepairDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"w_repair_detail"];
    controller.repairInfo = _arrayData[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
