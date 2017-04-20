//
//  ProMaintenanceFinish.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/15.
//
//

#import <Foundation/Foundation.h>
#import "ProMaintenanceFinish.h"
#import "HttpClient.h"
#import "ProMaintenanceDetail.h"

#pragma mark -- PlanFinishCell

@interface PlanFinshCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelProject;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@end

@implementation PlanFinshCell


@end

#pragma mark -- ProMaintenanceFinish

@interface ProMaintenanceFinish()

@property (strong, nonatomic) NSArray *planArray;

//@property NSInteger selectedIndex;

@end

@implementation ProMaintenanceFinish

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保管理"];
    [self initView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getFinishedPlanList];
}

- (void)initView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

/**
 *  请求完成待确认的维保列表
 */
- (void)getFinishedPlanList
{
    [[HttpClient sharedClient] view:self.view post:@"getFinishedMainList" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                self.planArray = [responseObject objectForKey:@"body"];
                                [self.tableView reloadData];
                            }];
}

#pragma mark --  TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanFinshCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanFinishedCell"];
    
    NSString *community = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"communityName"];
    NSString *building = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"buildingCode"];
    NSString *unit = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"unitCode"];
    
    NSString *project = [NSString stringWithFormat:@"%@%@号楼%@单元", community, building, unit];
    
    cell.labelProject.text = project;
    cell.labelDate.text = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"planMainTime"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProMaintenanceDetail *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"planDetail"];
    
    NSDictionary *mainInfo = self.planArray[indexPath.row];
    NSString *mainId = [mainInfo  objectForKey:@"mainId"];
    NSString *liftNum = [mainInfo objectForKey:@"num"];
    
    NSString *community = [mainInfo objectForKey:@"communityName"];
    NSString *building = [mainInfo objectForKey:@"buildingCode"];
    NSString *unit = [mainInfo objectForKey:@"unitCode"];
    NSString *address = [NSString stringWithFormat:@"%@%@号楼%@单元", community, building, unit];
    
    NSString *mainDate = [mainInfo objectForKey:@"mainTime"];
    NSString *mainType = [mainInfo objectForKey:@"mainType"];
    
    
    [controller setValue:@"finish" forKey:@"enterFlag"];
    [controller setValue:mainId forKey:@"mainId"];
    [controller setValue:liftNum forKey:@"liftNum"];
    [controller setValue:address forKey:@"address"];
    [controller setValue:mainDate forKey:@"mainDate"];
    [controller setValue:mainType forKey:@"mainType"];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


@end

