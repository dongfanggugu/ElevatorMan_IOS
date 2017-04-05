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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置菜单按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self setTitleString:@"维保管理"];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getFinishedPlanList];
}

/**
 *  请求完成待确认的维保列表
 */
- (void)getFinishedPlanList {
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

/**
 *  跳转到详情页面，同时把TabBar隐藏
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
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

/**
 *  设置标题
 *
 *  @param title <#title description#>
 */
- (void)setTitleString:(NSString *)title {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}


@end

