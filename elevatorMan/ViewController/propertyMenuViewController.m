//
//  propertyMenuViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/23.
//
//

#import "propertyMenuViewController.h"

#import "AppDelegate.h"
#import "HttpClient.h"
#import "TrackingViewController.h"
#import "APService.h"
#import "FileUtils.h"

#define ICON_PATH @"/tmp/person/"

#pragma mark - PropertyMenuCell
@interface PropertyMenuCell : UITableViewCell

@property (nonatomic,retain)IBOutlet UIImageView *imageView_menuIcon;
@property (nonatomic,retain)IBOutlet UILabel *label_menuTitle;
@property (nonatomic,retain)IBOutlet UIImageView *imageView_accessory;

@end

@implementation PropertyMenuCell

@end


#pragma mark - PropertyMenuViewController

@interface propertyMenuViewController ()<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *viewPerson;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *label_userName;

@property (weak, nonatomic) IBOutlet UILabel *label_UserCompany;

@property (nonatomic)NSInteger currentSelectedIndex;

@property (nonatomic, strong)UINavigationController *alarmListVC;

@property (nonatomic, strong)UINavigationController *homePageVC;

@property (strong ,nonatomic) UITabBarController *maintenanceVC;

@property (nonatomic, strong)NSDictionary *currentUserInfo;

@property (strong, nonatomic) UIAlertView *alertView;

@property (weak, nonatomic) UIViewController *currentController;

//@property (nonatomic, strong)UINavigationController *trackingVC;
//@property (nonatomic,strong)NSString *currentNotiAlarmID;

@end

@implementation propertyMenuViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.label_userName.text = [User sharedUser].userName;
    
    self.label_UserCompany.text = [User sharedUser].branch;

    self.homePageVC = (UINavigationController *)self.sideMenuViewController.contentViewController;
    
    _currentController = [[_homePageVC viewControllers] objectAtIndex:0];
    
    
    if([self respondsToSelector:@selector(getALarmNotification:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getALarmNotification:)name:@"alarmNotification" object:nil];
    }
    
    self.viewPerson.userInteractionEnabled = YES;
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalCenter)];
    [self.viewPerson addGestureRecognizer:recognizer];
    
    //设置头像为圆形
    self.imageViewIcon.layer.masksToBounds = YES;
    self.imageViewIcon.layer.cornerRadius = 40;
    [self setPersonIcon:[User sharedUser].picUrl];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //在这里加载头像，解决更新头像后头像无法及时显示的问题
    [self setPersonIcon:[User sharedUser].picUrl];
}

#pragma mark - getALarmNotification
//处理推送事件
- (void)getALarmNotification:(NSNotification *)notification
{
    
    self.currentUserInfo = nil;
    
//    if (self.alertView != nil)
//    {
//        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
//        self.alertView.tag = 2;
//        self.alertView = nil;
//    }
    
    self.currentUserInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    
    //UIAlertView *alert;
    
    if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"PROPERTY_ASSIGNED"])
    {
        //[[User sharedUser] showHUDWithLabel:@"您的报警已指派维修工前往"];
        self.alertView = [[UIAlertView alloc]initWithTitle:@"新消息" message:@"您的报警已指派维修工前往" delegate:self cancelButtonTitle:@"查看" otherButtonTitles:nil];
    }
    else if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"PROPERTY_ARRIVED"])
    {
        //[[User sharedUser] showHUDWithLabel:@"您的报警维修工已到达"];
        self.alertView = [[UIAlertView alloc]initWithTitle:@"新消息" message:@"您的报警维修工已到达现场" delegate:self cancelButtonTitle:@"查看" otherButtonTitles:nil];
    }
    else if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"PROPERTY_COMPLETED"])
    {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"新消息" message:@"维修工已完成，请确认完成" delegate:self cancelButtonTitle:@"查看" otherButtonTitles:nil];
    }
    else if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"PROPERTY_ALARM"])
    {
       //[[User sharedUser] showHUDWithLabel:@"您有一条新的报警"];
        self.alertView = [[UIAlertView alloc]initWithTitle:@"新消息" message:@"您有一条新的报警" delegate:self cancelButtonTitle:@"查看" otherButtonTitles:nil];

    }
    else if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"ALARM_CANCEL"])
    {
        
        self.alertView  = [[UIAlertView alloc]initWithTitle:@"新消息" message:@"当前处理的报警已经撤销" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        self.alertView.tag = 1;
    }
    
    [self.alertView show];
    //[alert show];
    
}

#pragma mark - UIAlertView Delegate

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (1 == alertView.tag) {
//        if (self.delegate) {
//            [self.delegate onReceivedAlarmCancel];
//        }
//        
//    } else {
//        NSString* alarmId =  [self.currentUserInfo objectForKey:@"alarmId"];
//        
//        
//        UIViewController *curController = [self appTopViewController];
//        
//        //AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
//        if ([curController isKindOfClass:[TrackingViewController class]])
//        {            
//            TrackingViewController *trackVC = (TrackingViewController *)curController;
//            trackVC.alarmId = alarmId;
//            [trackVC getAlarmInfo];
//        }
//        else
//        {
//            UINavigationController *tracking = [self.storyboard instantiateViewControllerWithIdentifier:@"trackingNavViewController"];
//            
//            TrackingViewController *trackVC = [[tracking viewControllers] objectAtIndex:0];
//            trackVC.alarmId = alarmId;
//            [self presentViewController:tracking animated:YES completion:nil];
//        }
//    }
//}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *alarmId =  [self.currentUserInfo objectForKey:@"alarmId"];
    
    
    UIViewController *curController = [self appTopViewController];
    
    if ([curController isKindOfClass:[TrackingViewController class]])
    {
        TrackingViewController *trackVC = (TrackingViewController *)curController;
        if (1 == alertView.tag)
        {
            [trackVC dismissViewControllerAnimated:YES completion:nil];
        }
        else if (2 == alertView.tag)
        {
            
        }
        else
        {
            trackVC.alarmId = alarmId;
            [trackVC getAlarmInfo];
        }
        
    }
    else
    {
        NSLog(@"tag:%ld", alertView.tag);
        
        
        if (1 == alertView.tag || 2 == alertView.tag)
        {
            return;
        }
        
        //NSLog(@"class:%@", [_currentController class]);
        TrackingViewController *trackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"trackingViewController"];
        trackVC.alarmId = alarmId;
        
        
        [_currentController.navigationController pushViewController:trackVC animated:YES];
    }
}


#pragma mark - getALarmNotification
//接收到报警完成，进入tracking
- (void)reportAlarmFinished:(NSNotification *)notification
{
    
//    //报警完成后给予提示
//    UIAlertView * alert;
//    alert = [[UIAlertView alloc]initWithTitle:@"新消息" message:@"报警成功，系统正在指派最近的维修工前往维修，请耐心等待！如需跟踪报警进度，请进入‘当前报警’查看" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//    [alert show];
//    [notification.userInfo objectForKey:@"id"];
//  
//    //根据报警id请求报警数据 并打开tracking
//    NSString *alarmId = [notification.userInfo objectForKey:@"id"];
//    
//
//    __weak propertyMenuViewController *weakself = self;
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:alarmId forKey:@"id"];
//    
//    [[HttpClient sharedClient] post:@"getAlarmDetail" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         //[responseObject objectForKey:@"body"];
//
//         UINavigationController *tracking = [self.storyboard instantiateViewControllerWithIdentifier:@"trackingNavViewController"];
//         TrackingViewController *vc = [[tracking viewControllers] objectAtIndex:0];
//         vc.alarmInfo = [responseObject objectForKey:@"body"];
//         vc.delegate = weakself;
//         
//         [weakself.sideMenuViewController presentViewController:tracking animated:YES completion:nil];
//
//
//     }];
}

- (void)homePage
{

    if (!self.homePageVC) {
        self.homePageVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"propertyContentViewController"];
        
    }
    
     _currentController = [[_homePageVC viewControllers] objectAtIndex:0];
    
    [self.sideMenuViewController setContentViewController:self.homePageVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

-(void)alarmList
{
    
    if (!self.alarmListVC) {
        self.alarmListVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"alarmlistViewController"];
        
    }
    
     _currentController = [[_alarmListVC viewControllers] objectAtIndex:0];
    
    [self.sideMenuViewController setContentViewController:self.alarmListVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}
/**
 *  进入维保管理
 */
- (void)maintenance {
    if (!self.maintenanceVC)
    {
        self.maintenanceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mantenanceController"];
    }
    
    _currentController = [[_maintenanceVC viewControllers] objectAtIndex:0];
    
    [self.sideMenuViewController setContentViewController:self.maintenanceVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

/**
 *  进入个人中心
 */
- (void)personalCenter {
    
    UIStoryboard *personalStoryBoard = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
    UINavigationController *nav = [personalStoryBoard instantiateViewControllerWithIdentifier:@"person_nav"];
    
    UIViewController *personalVC = [personalStoryBoard instantiateViewControllerWithIdentifier:@"person_center"];
    [nav pushViewController:personalVC animated:YES];
    
    _currentController = [[nav viewControllers] objectAtIndex:0];
    
    [self presentViewController:nav animated:YES completion:nil];
}


//-(void)tracking
//{
//    __weak propertyMenuViewController *weakSelf = self;
//    //获取当前报警
//    [[HttpClient sharedClient] view:self.view post:@"getOneAlarmListByUserId"
//                          parameter:nil
//                            success:^(AFHTTPRequestOperation *operation, id responseObject)
//    {
//        if ([responseObject objectForKey:@"body"])
//        {
//            if ([[responseObject objectForKey:@"body"] isKindOfClass:[NSString class]])
//            {
//                //提示当前无报警
//                [HUDClass showHUDWithLabel:@"当前无正在进行的报警救援" view:self.view];
//            }
//            
//            else if (![[responseObject objectForKey:@"body"] objectForKey:@"userState"])
//            {
//                //提示当前无报警
//                [HUDClass showHUDWithLabel:@"当前无正在进行的报警救援" view:self.view];
//                
//            }
//            else
//            {
//            
//                UINavigationController *tracking = [self.storyboard instantiateViewControllerWithIdentifier:@"trackingNavViewController"];
//                TrackingViewController *vc = [[tracking viewControllers] objectAtIndex:0];
//                vc.alarmInfo = [responseObject objectForKey:@"body"];
//                vc.delegate = weakSelf;
//                
//                self.delegate = vc;
//                [weakSelf.sideMenuViewController presentViewController:tracking animated:YES completion:nil];
//                
////                [weakSelf.sideMenuViewController setContentViewController:tracking animated:YES];
////                [weakSelf.sideMenuViewController hideMenuViewController];
//            
//            
//            }
//
//        }
//
//    }];
//
//
//}


- (void)finishedAlarm {
    
    [self.sideMenuViewController dismissViewControllerAnimated:YES completion:^{
     [self homePageVC];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //上海地区不显示
    if ([self isInShanghai]) {
        return 2;
    } else {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    PropertyMenuCell *cell = (PropertyMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"propertymenuCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.imageView_accessory.hidden = YES;
    if (indexPath.row == 0) {
        cell.imageView_menuIcon.image = [UIImage imageNamed:@"icon_homePage.png"];
        cell.label_menuTitle.text = @"项目报警";
        cell.imageView_accessory.hidden = NO;
        
    }
//    else if (indexPath.row == 1) {
//        cell.imageView_menuIcon.image = [UIImage imageNamed:@"icon_ring.png"];
//        cell.label_menuTitle.text = @"当前报警";
//    }
    
    else if (indexPath.row == 1)
    {
        cell.imageView_menuIcon.image = [UIImage imageNamed:@"icon_AlarmList.png"];
        cell.label_menuTitle.text = @"报警列表";
        //cell.imageView_accessory.hidden = YES;
    }
    else if (2 == indexPath.row)
    {
        cell.imageView_menuIcon.image = [UIImage imageNamed:@"icon_lift"];
        cell.label_menuTitle.text = @"维保管理";
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.delegate = nil;
    
    if (self.currentSelectedIndex != indexPath.row) {
        
        
        //当进入报警跟踪页面时，当前页面不需要更新选择菜单的UI
        
        PropertyMenuCell *oldCell =  (PropertyMenuCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0]];
        
        PropertyMenuCell *newCell =  (PropertyMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        self.currentSelectedIndex = indexPath.row;
        
        oldCell.imageView_accessory.hidden = YES;
        newCell.imageView_accessory.hidden = NO;
        
        
        if (indexPath.row == 0)
        {
            [self homePage];
        }
        else if (indexPath.row == 1)
        {
            [self alarmList];
        } else if (2 == indexPath.row)
        {
            [self maintenance];
        }
        
    }
    
}

/**
 *  根据URL下载图片并保存
 *
 *  @param urlString
 *  @param dirPath
 *  @param fileName
 */
- (void)downloadIconByUrlString:(NSString *)urlString dirPath:(NSString *)dirPath fileName:(NSString *)fileName {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data.length > 0 && nil == connectionError) {
            [FileUtils writeFile:data Path:dirPath fileName:fileName];
            [self performSelectorOnMainThread:@selector(setPersonIcon:) withObject:urlString waitUntilDone:NO];
            
        } else if (connectionError != nil) {
            NSLog(@"download picture error = %@", connectionError);
        }
    }];
}


/**
 *  设置头像
 *
 *  @param urlString <#urlString description#>
 */
- (void)setPersonIcon:(NSString *)urlString {
    
    if (0 == urlString.length) {
        return;
    }
    
    NSString *dirPath = [NSHomeDirectory() stringByAppendingString:ICON_PATH];
    NSString *fileName = [FileUtils getFileNameFromUrlString:urlString];
    NSString *filePath = [dirPath stringByAppendingString:fileName];
    
    if ([FileUtils existInFilePath:filePath]) {
        
        UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
        self.imageViewIcon.image = icon;
    } else {
        [self downloadIconByUrlString:urlString dirPath:dirPath fileName:fileName];
    }
    
}

/**
 *  显示侧边栏时回调
 *
 *  @param sideMenu           <#sideMenu description#>
 *  @param menuViewController <#menuViewController description#>
 */
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController {
    
}

/**
 *  确定是否在上海
 *
 *  @return <#return value description#>
 */
- (BOOL) isInShanghai {
    NSString *zone =  [[NSUserDefaults standardUserDefaults] objectForKey:@"urlString"];
    if ([zone isEqualToString:@"上海"]) {
        return YES;
    } else {
        return NO;
    }
}


/**
 *  get current show viewcontroller
 *
 *  @return <#return value description#>
 */
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    
    return result;
}


- (UIViewController *)appTopViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
