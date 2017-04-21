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



#pragma mark -- ProMaintenanceHistory

@interface ProMaintenanceHistory()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *historyArray;

@property (strong, nonatomic) UITableView *tableView;

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
    
    [self.historyArray removeAllObjects];
    self.currentPage = 1;
    [self getHistoryArrayByPage:self.currentPage project:nil building:nil unit:nil lift:nil];
}


- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64 - 49)];
    
    [self.view addSubview:_tableView];
    
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)initData
{
    _historyArray = [NSMutableArray array];
}

- (void)getHistoryArrayByPage:(NSInteger)page project:(NSString *)project building:(NSString *)building
                         unit:(NSString *)unit lift:(NSString *)litfId {
    
    NSLog(@"currentPage:%ld", page);
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:[NSNumber numberWithLong:-1] forKey:@"page"];
    [param setValue:project forKey:@"communityName"];
    [param setValue:building forKey:@"buildingCode"];
    [param setValue:unit forKey:@"unitCode"];
    [param setValue:litfId forKey:@"id"];
    
    __weak ProMaintenanceHistory *weakSelf = self;
    
    [[HttpClient sharedClient] view:self.view post:@"getHistoryMainList" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
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
    
    NSString *project = [NSString stringWithFormat:@"%@%@号楼%@单元", community, building, unit];
    
    NSString *date = [self.historyArray[indexPath.row] objectForKey:@"planMainTime"];
    
    NSString *worker = [self.historyArray[indexPath.row] objectForKey:@"workerName"];
    
    cell.labelProject.text = project;
    cell.labelDate.text = [NSString stringWithFormat:@"%@      维保人:%@", date, worker];
    
    
    return cell;
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
    
    
    [controller setValue:mainId forKey:@"mainId"];
    [controller setValue:liftNum forKey:@"liftNum"];
    [controller setValue:address forKey:@"address"];
    [controller setValue:mainDate forKey:@"mainDate"];
    [controller setValue:mainType forKey:@"mainType"];
    
    controller.worker = worker;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MaintInfoCell cellHeight];
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
    [self.historyArray removeAllObjects];
    self.currentPage = 1;
    [self getHistoryArrayByPage:self.currentPage project:nil building:nil unit:nil lift:nil];
}

- (void)loadMoreDataToTable
{
    self.currentPage++;
    [self getHistoryArrayByPage:self.currentPage project:nil building:nil unit:nil lift:nil];
    
}

@end
