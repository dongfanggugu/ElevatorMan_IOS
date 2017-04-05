//
//  ProMaintenancePlan.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/15.
//
//

#import <Foundation/Foundation.h>
#import "ProMaintenancePlan.h"
#import "HttpClient.h"
#import "Utils.h"


#pragma mark -- UITableViewCell
/**
 *  tableviewcell
 */
@interface PlanTableCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *stateView;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *workerLabel;


@end


@implementation PlanTableCell



@end


#pragma mark -- ProMaintenancePlan

@interface ProMaintenancePlan()<UIAlertViewDelegate>


@property (strong, nonatomic) NSArray *planArray;

@property (strong, nonatomic) PlanTableCell *currentAlerCell;



@end


@implementation ProMaintenancePlan


/**
 *  在视图显示时请求网络，获取维保计划信息
 *
 *  @param animated <#animated description#>
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getPlanList];
}

/**
 *  视图加载后，初始化全局变量
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"维保管理"];
    
//    //设置菜单按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
//    [button setFrame:CGRectMake(0, 0, 30, 30)];
//    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    
//    [self setTitleString:@"维保管理"];
    
    
    //self.tabBarItem.image = [UIImage imageNamed:@"1.png"];
    //self.tabBarItem.title = @"计划";
    
}

- (void)getPlanList {
    [[HttpClient sharedClient] view:self.view post:@"getMainPlanByPropertyId" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"plan result:%@", responseObject);
                                self.planArray = [responseObject objectForKey:@"body"];
                                [self.tableView reloadData];
                                
                            }];
}


#pragma mark -- Table View data source


/**
 *  返回tableview section数量
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/**
 *  返回table view中每个section的行数
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planArray.count;
}

/**
 *  处理每一个table view cell对象
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"planCell"];
    
    NSString *community = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"communityName"];
    NSString *building = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"buildingCode"];
    NSString *unit = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"unitCode"];
    
    NSString *project = [NSString stringWithFormat:@"%@%@号楼%@单元", community, building, unit];
    cell.projectLabel.text = project;
    cell.numberLabel.text = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"num"];
    cell.dateLabel.text = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"planMainTime"];
    
    NSString *type = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"planMainType"];
    cell.typeLabel.text = [self getDescriptionByType:type];
    cell.companyLabel.text = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"workerCompany"];
    cell.workerLabel.text = [[self.planArray objectAtIndex:indexPath.row] objectForKey:@"workerName"];
    
    NSString *state = [self.planArray[indexPath.row] objectForKey:@"propertyFlg"];
    
    [self setCellView:cell state:state];
    
    
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(cellSelected:)];
    [cell addGestureRecognizer:sigleTap];
    cell.tag = indexPath.row;
    
    return cell;
}

- (void)cellSelected:(UIGestureRecognizer *)recognizer {
    self.currentAlerCell = (PlanTableCell *)recognizer.view;
    NSInteger tag = self.currentAlerCell.tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"维保计划处理" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", @"拒绝", nil];
    alert.tag = tag;
    
    [alert show];
}


/**
 *  根据类型返回维保类型的描述
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)getDescriptionByType:(NSString *)type {
    NSString *description = nil;
    if ([type isEqualToString:@"hm"]) {
        description = @"半月保";
    } else if ([type isEqualToString:@"m"]) {
        description = @"月保";
    } else if ([type isEqualToString:@"s"]) {
        description = @"季度保";
    } else if ([type isEqualToString:@"hy"]) {
        description = @"半年保";
    } else if ([type isEqualToString:@"y"]) {
        description = @"年保";
    }
    return description;
}

/**
 *  维保确认弹出框回调方法
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //index:0 取消 1:确认 2:拒绝
    
    if (0 == buttonIndex) {
        return;
    }
    
    
    NSInteger tag = alertView.tag;
    NSString *mainId = [self.planArray[tag] objectForKey:@"mainId"];
    
    
    //verify = 1 确认, verify = 0:拒绝
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    param[@"mainId"] = mainId;
    param[@"verify"] = [NSNumber numberWithInt:buttonIndex == 1 ? 1 : 0];
    
    [[HttpClient sharedClient] view:self.view post:@"verifyMainPlan" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSString *state = buttonIndex == 1 ? @"2" : @"3";
                                [self setCellView:self.currentAlerCell state:state];
                            }];
}


- (void)setCellView:(PlanTableCell *)cell state:(NSString *)state {

    if ([state isEqualToString:@"1"]) {
        cell.stateView.backgroundColor = [Utils getColorByRGB:@"#cccccc"];
        cell.stateLabel.text = @"待确认";
        cell.stateImageView.image = [UIImage imageNamed:@"icon_waiting"];
        
    } else if ([state isEqualToString:@"2"]) {
        cell.stateView.backgroundColor = [Utils getColorByRGB:@"#9ac25f"];
        cell.stateLabel.text = @"已确认";
        cell.stateImageView.image = [UIImage imageNamed:@"icon_confirm"];
        
    } else if ([state isEqualToString:@"3"]) {
        cell.stateView.backgroundColor = [Utils getColorByRGB:@"#f2c63e"];
        cell.stateLabel.text = @"已拒绝";
        cell.stateImageView.image = [UIImage imageNamed:@"icon_reject"];
    }
}

- (void)setTitleString:(NSString *)title {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}


@end
