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

#pragma mark -- HistoryCell

@interface HistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelProject;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@end

@implementation HistoryCell


@end




#pragma mark -- ProMaintenanceHistory

@interface ProMaintenanceHistory()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *historyArray;

@property (weak, nonatomic) IBOutlet PullTableView *pullTableView;

@property NSInteger currentPage;

@end

@implementation ProMaintenanceHistory



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置菜单按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self setTitleString:@"维保管理"];
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor whiteColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];


    
    self.historyArray = [NSMutableArray arrayWithCapacity:1];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.historyArray removeAllObjects];
    self.currentPage = 1;
    [self getHistoryArrayByPage:self.currentPage project:nil building:nil unit:nil lift:nil];
}


/**
 *  根据输入信息查询维保历史
 *
 *  @param page     <#page description#>
 *  @param project  <#project description#>
 *  @param building <#building description#>
 *  @param unit     <#unit description#>
 *  @param litfId   <#litfId description#>
 */
- (void)getHistoryArrayByPage:(NSInteger)page project:(NSString *)project building:(NSString *)building
                         unit:(NSString *)unit lift:(NSString *)litfId {
    
    NSLog(@"currentPage:%ld", page);
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:[NSNumber numberWithLong:page] forKey:@"page"];
    [param setValue:project forKey:@"communityName"];
    [param setValue:building forKey:@"buildingCode"];
    [param setValue:unit forKey:@"unitCode"];
    [param setValue:litfId forKey:@"id"];
    
    __weak ProMaintenanceHistory *weakSelf = self;
    
    [[HttpClient sharedClient] view:self.view post:@"getHistoryMainList" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                
                                
                                if (YES == weakSelf.pullTableView.pullTableIsLoadingMore)
                                {
                                    
                                    //上拉加载更多请求完数据
                                    weakSelf.pullTableView.pullTableIsLoadingMore = NO;
                                    
                                    //如果已经没有数据，将页数恢复
                                    NSArray *array = [responseObject objectForKey:@"body"];
                                    if (nil == array || 0 == array.count)
                                    {
                                        weakSelf.currentPage--;
                                    }
                                    
                                }
                                else if (YES == weakSelf.pullTableView.pullTableIsRefreshing)
                                {
                                    //下拉刷新请求完数据
                                    weakSelf.pullTableView.pullTableIsRefreshing = NO;
                                    
                                }
                                //加载数据
                                [weakSelf.historyArray addObjectsFromArray:[responseObject objectForKey:@"body"] ];
                                [weakSelf.pullTableView reloadData];
                                
                            }];
}


#pragma mark -- TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    
    NSString *community = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"communityName"];
    NSString *building = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"buildingCode"];
    NSString *unit = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"unitCode"];
    
    NSString *project = [NSString stringWithFormat:@"%@%@号楼%@单元", community, building, unit];
    
    cell.labelProject.text = project;
    cell.labelDate.text = [[self.historyArray objectAtIndex:indexPath.row] objectForKey:@"planMainTime"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    
    [controller setValue:mainId forKey:@"mainId"];
    [controller setValue:liftNum forKey:@"liftNum"];
    [controller setValue:address forKey:@"address"];
    [controller setValue:mainDate forKey:@"mainDate"];
    [controller setValue:mainType forKey:@"mainType"];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    NSLog(@"refresh");
    //[self.pullTableView setContentOffset:CGPointMake(0, 88) animated:YES];
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:2.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
     NSLog(@"load more");
    //[self.pullTableView setContentOffset:CGPointMake(0, -64) animated:YES];
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:2.0f];
}


#pragma mark - PullTableViewDelegate callback

- (void)refreshTable {
    
    NSLog(@"refreshTable");
    [self.historyArray removeAllObjects];
    self.currentPage = 1;
    [self getHistoryArrayByPage:self.currentPage project:nil building:nil unit:nil lift:nil];
}

- (void)loadMoreDataToTable {
    NSLog(@"loadMoreDataToTable");

    self.currentPage++;
    [self getHistoryArrayByPage:self.currentPage project:nil building:nil unit:nil lift:nil];
    
}

- (void)setTitleString:(NSString *)title
{
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}

@end