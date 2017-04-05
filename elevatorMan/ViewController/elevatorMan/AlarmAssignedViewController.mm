//
//  AlarmAssignedViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/25.
//
//

#import <Foundation/Foundation.h>
#import "AlarmProcessViewController.h"
#import "AlarmAssignedViewController.h"
#import "AlarmReceivedViewController.h"
#import "HttpClient.h"
#import "../../../chorstar/chorstar/Chorstar.h"
#import "AlarmViewController.h"

#pragma mark -- AlarmCell

@interface AlarmCell(assigned)

@end
@implementation AlarmCell(assigned)

@end

#pragma mark -- AlarmInfo

@interface AlarmInfo(assigned)
@end

@implementation AlarmInfo(assigned)


+ (AlarmInfo *)alarmAssignedFromDic:(NSDictionary *)dicInfo
{
    AlarmInfo *alarmInfo = [[AlarmInfo alloc] init];
    NSDictionary *community = [dicInfo objectForKey:@"communityInfo"];
    
    if (community)
    {
        alarmInfo.project = [community objectForKey:@"name"];
    }
    alarmInfo.alarmId = [dicInfo objectForKey:@"id"];
    alarmInfo.date = [dicInfo objectForKey:@"alarmTime"];
    NSString *userState = [dicInfo objectForKey:@"userState"];
    alarmInfo.userState = [userState integerValue];
    return alarmInfo;
}

@end

#pragma mark -- AlarmAssignedViewController

@interface AlarmAssignedViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *mAlarmArray;

@end

@implementation AlarmAssignedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set navigation bar menu
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(presentLeftMenuViewController:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    self.mAlarmArray = [[NSMutableArray alloc] init];
    [self setTitleString:@"报警管理"];
    //forbidden bounce
    self.mTableView.bounces = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"assigned view did appear");
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"assigned view will appear");
    
    __weak AlarmAssignedViewController *weakSelf = self;
   
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"unfinished" forKey:@"scope"];
    
    [[HttpClient sharedClient] view:self.view post:@"getAlarmListByRepairUserId" parameter:params
                            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *body = [responseObject objectForKey:@"body"];
         
         [self.mAlarmArray removeAllObjects];
         
         //the data received from server is too much, abandon others
         if (body && body.count > 0)
         {
             for (NSDictionary *dic in body)
             {
                 AlarmInfo *alarmInfo = [AlarmInfo alarmAssignedFromDic:dic];
                 if (alarmInfo != nil)
                 {
                     [weakSelf.mAlarmArray addObject:alarmInfo];
                 }
             }
         }
         
         [weakSelf.mTableView reloadData];
         
     }];
    
}

/**
 *  set navigation bar title string
 *
 *  @param title 页面标题
 */
- (void)setTitleString:(NSString *)title
{
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    lableTitle.text = title;
    lableTitle.font = [UIFont fontWithName:@"System" size:17];
    lableTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:lableTitle];
    
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mAlarmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
    
    AlarmInfo *alarmInfo = self.mAlarmArray[indexPath.row];
    
    cell.labelProject.text = alarmInfo.project;
    cell.labelDate.text = alarmInfo.date;
    
    if (1 == alarmInfo.userState)
    {
       cell.labelState.text = @"已出发";
        
    }
    else if (2 == alarmInfo.userState)
    {
        cell.labelState.text = @"已到达";
    }
    
    cell.labelIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    [cell setColorWithIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AlarmInfo *alarmInfo = self.mAlarmArray[indexPath.row];
    
    if (1 == alarmInfo.userState)
    {
        AlarmViewController *controller = [self.storyboard
                                           instantiateViewControllerWithIdentifier:@"alarm_process"];
        controller.alarmId = alarmInfo.alarmId;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (2 == alarmInfo.userState)
    {
        AlarmViewController *controller = [self.storyboard
                                           instantiateViewControllerWithIdentifier:@"confirm_process"];
        controller.alarmId = alarmInfo.alarmId;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
    //[self presentViewController:nvc animated:YES completion:nil];
}


@end
