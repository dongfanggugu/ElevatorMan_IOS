//
//  ProMaintenanceHistory.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/15.
//
//

#import <Foundation/Foundation.h>
#import "ProMaintenanceHistory.h"
#import "HttpClient.h"
#import "PullTableView.h"
#import "ProMaintenanceDetail.h"
#import "MaintInfoCell.h"


#define PAGE_SIZE 2


#pragma mark -- ProMaintenanceHistory

@interface ProMaintenanceHistory()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate>

@property (strong, nonatomic) NSMutableArray *historyArray;

@property (strong, nonatomic) PullTableView *tableView;

@property NSInteger currentPage;

@end

@implementation ProMaintenanceHistory



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.currentPage = 1;
    [self getHistory];
}


- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64 - 49)];
    
    [self.view addSubview:_tableView];
    
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.pullDelegate = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)initData
{
    _historyArray = [NSMutableArray array];
}

- (void)getHistory
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:[NSNumber numberWithLong:1] forKey:@"page"];
    
    __weak ProMaintenanceHistory *weakSelf = self;
    
    [[HttpClient sharedClient] view:self.view post:@"getHistoryMainList" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                if (_tableView.pullTableIsRefreshing) {
                                    _tableView.pullTableIsRefreshing = NO;
                                }
                                
                                [weakSelf.historyArray removeAllObjects];
                                
                                [weakSelf.historyArray addObjectsFromArray:[responseObject objectForKey:@"body"] ];
                                
                                [weakSelf.tableView reloadData];
                                
                            }];
}


- (void)getMoreHistory
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:[NSNumber numberWithLong:self.currentPage] forKey:@"page"];
    
    __weak ProMaintenanceHistory *weakSelf = self;
    
    [[HttpClient sharedClient] view:self.view post:@"getHistoryMainList" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                if (_tableView.pullTableIsLoadingMore) {
                                    _tableView.pullTableIsLoadingMore = NO;
                                }
                                
                                [weakSelf.historyArray addObjectsFromArray:[responseObject objectForKey:@"body"] ];
                                
                                [weakSelf.tableView reloadData];
                                
                            }];
}

- (void)getHistoryArrayByPage:(NSInteger)page project:(NSString *)project building:(NSString *)building
                         unit:(NSString *)unit lift:(NSString *)litfId
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:[NSNumber numberWithLong:1] forKey:@"page"];
    [param setValue:[NSNumber numberWithLong:PAGE_SIZE] forKey:@"pageSize"];
    [param setValue:project forKey:@"communityName"];
    [param setValue:building forKey:@"buildingCode"];
    [param setValue:unit forKey:@"unitCode"];
    [param setValue:litfId forKey:@"id"];
    
    __weak ProMaintenanceHistory *weakSelf = self;
    
    [[HttpClient sharedClient] view:self.view post:@"getHistoryMainList" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                [weakSelf.historyArray removeAllObjects];
                                [weakSelf.historyArray addObjectsFromArray:[responseObject objectForKey:@"body"] ];
                                [weakSelf.tableView reloadData];
                                
                            }];
}


#pragma mark -- TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaintInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[MaintInfoCell identifier]];
    
    if (!cell) {
        cell = [MaintInfoCell cellFromNib];
    }
    
    NSString *community = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"communityName"];
    NSString *building = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"buildingCode"];
    NSString *unit = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"unitCode"];
    
    NSString *confirmTime = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"propertyFinishedTime"];
    
    NSString *project = [NSString stringWithFormat:@"%@%@号楼%@单元", community, building, unit];
    
    NSString *mainTime = [self.historyArray[indexPath.row] objectForKey:@"mainTime"];
    
    NSString *worker = [self.historyArray[indexPath.row] objectForKey:@"workerName"];
    
    cell.labelProject.text = project;
    cell.labelInfo.text = [NSString stringWithFormat:@"维保时间:%@ 维保人:%@", mainTime, worker];
    cell.labelDate.text = confirmTime;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *community = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"communityName"];
    NSString *building = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"buildingCode"];
    NSString *unit = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"unitCode"];
    NSString *project = [NSString stringWithFormat:@"%@%@号楼%@单元", community, building, unit];
    
    return [MaintInfoCell cellHeightWithText:project];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProMaintenanceDetail *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"planDetail"];
    
    NSDictionary *mainInfo = self.historyArray[indexPath.row];
    
    NSString *mainId = [mainInfo  objectForKey:@"mainId"];
    NSString *liftNum = [mainInfo objectForKey:@"num"];
    
    NSString *community = [mainInfo objectForKey:@"communityName"];
    NSString *building = [mainInfo objectForKey:@"buildingCode"];
    NSString *unit = [mainInfo objectForKey:@"unitCode"];
    NSString *address = [NSString stringWithFormat:@"%@%@号楼%@单元", community, building, unit];
    
    NSString *mainDate = [mainInfo objectForKey:@"mainTime"];
    NSString *mainType = [mainInfo objectForKey:@"mainType"];
    
    NSString *worker = [mainInfo objectForKey:@"workerName"];
    
    NSString *workerSign = [mainInfo objectForKey:@"workerAutograph"];
    
    NSString *propertySign = [mainInfo objectForKey:@"propertyAutograph"];
    
    
    [controller setValue:mainId forKey:@"mainId"];
    [controller setValue:liftNum forKey:@"liftNum"];
    [controller setValue:address forKey:@"address"];
    [controller setValue:mainDate forKey:@"mainDate"];
    [controller setValue:mainType forKey:@"mainType"];
    
    controller.worker = worker;
    
    controller.workerSign = workerSign;
    
    controller.propertySign = propertySign;
    
    controller.enterFlag = @"history";
    
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self refreshTable];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadMoreDataToTable];
}


#pragma mark - PullTableViewDelegate callback

- (void)refreshTable
{
    [self getHistory];
}

- (void)loadMoreDataToTable
{
    self.currentPage++;
    [self getMoreHistory];
    
}

@end
