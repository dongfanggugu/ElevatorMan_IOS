//
//  MantenanceViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/8.
//
//

#import <Foundation/Foundation.h>
#import "MaintenanceViewController.h"
#import "HttpClient.h"
#import "DateUtil.h"
#import "SwipeableCell.h"
#import "MaintenanceReminder.h"

@interface MaintenanceViewController()<SwipeableCellDelegate>

@property (nonatomic, strong) NSMutableArray *planDoneList;

@property (nonatomic, strong) NSMutableArray *planUndoList;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property NSInteger selectedIndex;

@property (strong, nonatomic) NSString *leftFlag;

@end

@implementation MaintenanceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getElevatorList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置菜单按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self.segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    
    self.tableView.bounces = NO;
}

- (void)getElevatorList {
    
    [[HttpClient sharedClient] view:self.view post:@"getMainElevatorList" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealHttpData:[responseObject objectForKey:@"body"]];
    }];
}

- (long long)setPlanDoneReminder {
    
    long long deadLineMin = LONG_LONG_MAX;
    
    if (0 == self.planDoneList.count) {
        return deadLineMin;
    }
    
    long long planDoneMin = LONG_LONG_MAX;
    
    //查找维保待完成的电梯距离现在最近的时间间隔
    for (NSDictionary *dic in self.planDoneList) {
        NSString *planMainDateString = [dic objectForKey:@"planMainTime"];
        NSDate *planMainDate = [DateUtil yyyyMMddFromString:planMainDateString];
        long long planDoneinterval = [MaintenanceReminder
                                      getPlanDoneReminderIntervalSecondsFromNowToDeadDate:planMainDate];
        if (planDoneinterval < planDoneMin) {
            planDoneMin = planDoneinterval;
        }
        
        //查找距离最近的维保过期电梯
        NSString *lastMainDateString = [dic objectForKey:@"lastMainTime"];
        if (lastMainDateString.length != 0) {
            NSDate *lastMainDate = [DateUtil yyyyMMddFromString:lastMainDateString];
            long long deadLineInterval = [MaintenanceReminder
                                          getDeadLineReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
            if (deadLineInterval < deadLineMin) {
                deadLineMin = deadLineInterval;
            }
        }
    }
    
    [MaintenanceReminder setPlanDoneReminderByIntervalSecons:planDoneMin];
    return deadLineMin;
}

- (long long)setPlanMakeReminder {
    
    long long deadLineMin = LONG_LONG_MAX;
    if (0 == self.planUndoList.count) {
        return deadLineMin;
    }
    
    long long planMakeMin = LONG_LONG_MAX;
    for (NSDictionary *dic in self.planUndoList) {
        //查找需要制定计划的电梯距离现在最近的时间间隔
        NSString *lastMainDateString = [dic objectForKey:@"lastMainTime"];
        if (lastMainDateString.length != 0) {
            NSDate *lastMainDate = [DateUtil yyyyMMddFromString:lastMainDateString];
            long long planMakeInterval = [MaintenanceReminder
                                          getPlanMakeReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
            if (planMakeInterval < planMakeMin) {
                planMakeMin = planMakeInterval;
            }
            
            //查找距离最近的维保过期电梯
            long long deadLineInterval = [MaintenanceReminder
                                          getDeadLineReminderIntervalSecondsFromNowByLastFinishedDate:lastMainDate];
            if (deadLineInterval < deadLineMin) {
                deadLineMin = deadLineInterval;
            }
        }
    }
    
    [MaintenanceReminder setPlanMakeReminderByIntervalSecons:planMakeMin];
    return deadLineMin;
}

- (void)setReminder {
    long long deadLineMin = MIN([self setPlanDoneReminder], [self setPlanMakeReminder]);
    //设置维保待完成，维保计划指定和维保过期的提醒
    [MaintenanceReminder setDeadLineReminderByIntervalSecons:deadLineMin];
}

/**
 *  将电梯维保信息分类并展示
 *
 *  @param array <#array description#>
 */
- (void)dealHttpData:(NSArray *)array {
    self.planDoneList = [NSMutableArray arrayWithCapacity:1];
    self.planUndoList = [NSMutableArray arrayWithCapacity:1];
    
    
    for (NSDictionary *dic in array) {
       
        
        NSString *flag = [dic objectForKey:@"planMainTime"];
        if (0 == flag.length) {
            [self.planUndoList addObject:dic];
            
        } else {
            [self.planDoneList addObject:dic];
            
        } 
    }
    [self setReminder];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == self.segment.selectedSegmentIndex) {
        return self.planDoneList.count;
    } else {
        return self.planUndoList.count;
    }
}

/**设置table view的cell显示数据**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SwipeableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"elevator_cell" forIndexPath:indexPath];
    
    cell.swipeableCellDelegate = self;
    
    if (0 == self.segment.selectedSegmentIndex) {
        
        NSString *liftCode = [[self.planDoneList objectAtIndex:indexPath.row] objectForKey:@"num"];
        NSString *address = [[self.planDoneList objectAtIndex:indexPath.row] objectForKey:@"address"];
        NSString *planDate  = [[self.planDoneList objectAtIndex:indexPath.row] objectForKey:@"planMainTime"];
        NSString *planType = [self getDescriptionByType:[[self.planDoneList objectAtIndex:indexPath.row] objectForKey:@"planMainType"]];
        NSString *proFlag = [[self.planDoneList objectAtIndex:indexPath.row] valueForKey:@"propertyFlg"];
        
        [cell labelCode].text = liftCode;
        [cell labelAddress].text = address;
        [cell labelDate].text = planDate;
        [cell labelType].text = planType;
        
        [cell btnDel].tag = indexPath.row;
        [cell btnEdit].tag = indexPath.row;
        
        
        [cell labelDateDes].text = @"计划日期";
        [cell labelTypeDes].text = @"计划类型";
        
        [cell setSwipeable:YES];
        
        NSDate *date = [DateUtil yyyyMMddFromString:planDate];
        NSInteger days = [DateUtil getIntervalDaysFromStart:[NSDate date] end:date];
        [[cell labelDays] setBackgroundColor:[UIColor whiteColor]];
        
        if (days < 0) {
            [cell labelTian].hidden = YES;
            [cell labelDays].text = @"过期";
        } else {
            [cell labelTian].hidden = NO;
            [cell labelDays].text = [NSString stringWithFormat:@"%ld", days];
        }
        
        if (days <= 3) {
            [[cell labelDays] setBackgroundColor:[self getColorByRGB:@"#ee7651"]];
            
        } else if (days <= 8) {
            [[cell labelDays] setBackgroundColor:[self getColorByRGB:@"#ebe084"]];
            
        } else {
            [[cell labelDays] setBackgroundColor:[self getColorByRGB:@"#9ac25f"]];
        }
        
        if ([proFlag isEqualToString:@"3"]) {
            [cell labelTian].hidden = YES;
            [cell labelDays].text = @"拒绝";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
    } else {
        NSString *liftCode = [[self.planUndoList objectAtIndex:indexPath.row] objectForKey:@"num"];
        NSString *address = [[self.planUndoList objectAtIndex:indexPath.row] objectForKey:@"address"];
        NSString *mainDate  = [[self.planUndoList objectAtIndex:indexPath.row] objectForKey:@"lastMainTime"];
        NSString *mainType = [self getDescriptionByType:[[self.planUndoList objectAtIndex:indexPath.row] objectForKey:@"lastMainType"]];
        
        [cell labelCode].text = liftCode;
        [cell labelAddress].text = address;
        [cell labelDate].text = (mainDate.length == 0 ? @"无" : mainDate);
        [cell labelType].text = (mainType.length == 0 ? @"无" : mainType);
        
        [cell labelDateDes].text = @"维保日期";
        [cell labelTypeDes].text = @"维保类型";
        
        [cell setSwipeable:NO];
        
        [cell labelTian].hidden = YES;
        [cell labelDays].text = @"未制定";
        
        [[cell labelDays] setBackgroundColor:[self getColorByRGB:@"#e1e1e1"]];
        
    }
    
    cell.tag = indexPath.row;
    return cell;
}


/**根据类型返回维保类型的描述**/
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //如果物业拒绝，不能完成该计划
    if (0 == self.segment.selectedSegmentIndex) {
        NSString *proFlag = [self.planDoneList[indexPath.row] objectForKey:@"propertyFlg"];
        if ([proFlag isEqualToString:@"3"]) {
            
            
            //弹出警告框
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"物业已经拒绝,请修改维保计划!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    
    self.selectedIndex = indexPath.row;
    if (0 == self.segment.selectedSegmentIndex) {
        self.leftFlag = @"complete";
    } else if (1 == self.segment.selectedSegmentIndex) {
        self.leftFlag = @"add";
    }
    [self performSegueWithIdentifier:@"push_to_maintenance_detail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *send = segue.destinationViewController;
    
    if (0 == self.segment.selectedSegmentIndex) {
        NSString *litfId = [[self.planDoneList objectAtIndex:self.selectedIndex] objectForKey:@"id"];
        NSString *num = [[self.planDoneList objectAtIndex:self.selectedIndex] objectForKey:@"num"];
        NSString *address = [[self.planDoneList objectAtIndex:self.selectedIndex] objectForKey:@"address"];
        NSString *mainDate = [[self.planDoneList objectAtIndex:self.selectedIndex] objectForKey:@"lastMainTime"];
        NSString *mainType = [[self.planDoneList objectAtIndex:self.selectedIndex] objectForKey:@"lastMainType"];
        NSString *planDate = [[self.planDoneList objectAtIndex:self.selectedIndex] objectForKey:@"planMainTime"];
        NSString *planType = [[self.planDoneList objectAtIndex:self.selectedIndex] objectForKey:@"planMainType"];
        [send setValue:self.leftFlag forKey:@"flag"];
        [send setValue:litfId forKey:@"liftId"];
        [send setValue:num forKey:@"liftNum"];
        [send setValue:address forKey:@"address"];
        [send setValue:mainDate forKey:@"mainDate"];
        [send setValue:mainType forKey:@"mainType"];
        [send setValue:planDate forKey:@"planMainDate"];
        [send setValue:planType forKey:@"planMainType"];
        
    } else {
        NSString *litfId = [[self.planUndoList objectAtIndex:self.selectedIndex] objectForKey:@"id"];
        NSString *num = [[self.planUndoList objectAtIndex:self.selectedIndex] objectForKey:@"num"];
        NSString *address = [[self.planUndoList objectAtIndex:self.selectedIndex] objectForKey:@"address"];
        NSString *mainDate = [[self.planUndoList objectAtIndex:self.selectedIndex] objectForKey:@"lastMainTime"];
        NSString *mainType = [[self.planUndoList objectAtIndex:self.selectedIndex] objectForKey:@"lastMainType"];
        [send setValue:self.leftFlag forKey:@"flag"];
        [send setValue:litfId forKey:@"liftId"];
        [send setValue:num forKey:@"liftNum"];
        [send setValue:address forKey:@"address"];
        [send setValue:mainDate forKey:@"mainDate"];
        [send setValue:mainType forKey:@"mainType"];
    }
}

/**
 编辑和删除点击时回调方法
 **/
- (void)buttonClicked:(NSString *)buttonType tag:(NSInteger)tag {
    if ([buttonType isEqualToString:@"edit"]) {
        self.leftFlag = @"edit";
        self.selectedIndex = tag;
        [self performSegueWithIdentifier:@"push_to_maintenance_detail" sender:self];
        
    } else if ([buttonType isEqualToString:@"del"]) {
        NSString *liftId = [[self.planDoneList objectAtIndex:tag] objectForKey:@"id"];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
        [param setValue:liftId forKey:@"id"];
        
        [[HttpClient sharedClient] view:self.view post:@"removeMainPlan" parameter:param
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    //删除维保中拍摄但是没有提交的照片
                                    NSString *liftNum = [[self.planDoneList objectAtIndex:tag] objectForKey:@"num"];
                                    NSString *path1 = [NSHomeDirectory()stringByAppendingPathComponent:
                                                       [[NSString alloc] initWithFormat:@"Documents/%@/0", liftNum]];
                                    
                                    NSString *path2 = [NSHomeDirectory()stringByAppendingPathComponent:
                                                       [[NSString alloc] initWithFormat:@"Documents/%@/1", liftNum]];

                                    
                                    NSString *path3 = [NSHomeDirectory()stringByAppendingPathComponent:
                                                       [[NSString alloc] initWithFormat:@"Documents/%@/2", liftNum]];
                                    
                                    [self deleteFileByPath:path1];
                                    [self deleteFileByPath:path2];
                                    [self deleteFileByPath:path3];

                                    //更新视图
                                    [self.planUndoList addObject:[self.planDoneList objectAtIndex:tag]];
                                    [self.planDoneList removeObjectAtIndex:tag];
                                    
                                    //重新设置提醒事件
                                    [self setReminder];
                                    
                                    [self.tableView reloadData];
                                
                                }];
    }
}

/**
 tab页选择切换
 **/
- (void)selected:(id)sender {
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    switch (control.selectedSegmentIndex) {
        case 0:
            if (!self.planDoneList || 0 == self.planDoneList.count) {
                [HUDClass showHUDWithLabel:@"没有已经制定好计划的电梯!" view:self.view];
            }
            break;
        case 1:
            if (!self.planUndoList || 0 == self.planUndoList.count) {
                [HUDClass showHUDWithLabel:@"所有电梯都已经制定计划!" view:self.view];
            }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

/**
 删除指定路径下的文件
 **/
- (void)deleteFileByPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:path];
    
    if (exist) {
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
    }
}

- (UIColor *)getColorByRGB:(NSString *)RGB {
    
    if (RGB.length != 7) {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }
    
    if (![RGB hasPrefix:@"#"]) {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }
    
    NSString *colorString = [RGB substringFromIndex:1];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *red = [colorString substringWithRange:range];
    
    range.location = 2;
    NSString *green = [colorString substringWithRange:range];
    
    range.location = 4;
    NSString *blue = [colorString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}



@end



