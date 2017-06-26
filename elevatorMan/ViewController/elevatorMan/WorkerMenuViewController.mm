//
//  WorkerMenuViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/23.
//
//

#import "WorkerMenuViewController.h"
#import "HttpClient.h"
#import "AlarmProcessViewController.h"
#import "location.h"
#import "APService.h"
#import <AVFoundation/AVFoundation.h>
#import "FileUtils.h"
#import "MaintenanceReminder.h"
#import "Utils.h"


#pragma mark - WorkerMenuCell

@interface WorkerMenuCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *imageView_menuIcon;
@property (nonatomic, retain) IBOutlet UILabel *label_menuTitle;
@property (nonatomic, retain) IBOutlet UIImageView *imageView_accessory;
@end


@implementation WorkerMenuCell
@end


#pragma mark -- MenuItem

@interface MenuItem : NSObject

@property (strong, nonatomic) NSString *itemTitle;

@property (strong, nonatomic) UIImage *itemImage;

@property SEL action;

@end

@implementation MenuItem

+ (MenuItem *)instantiateMenuItemWithTile:(NSString *)title image:(UIImage *)image action:(SEL)action {
    MenuItem *menuItem = [[MenuItem alloc] init];
    menuItem.itemTitle = title;
    menuItem.itemImage = image;
    menuItem.action = action;

    return menuItem;
}
@end


#pragma mark - WorkerMenuViewController

@interface WorkerMenuViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIApplicationDelegate, AVAudioPlayerDelegate, RESideMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *viewPerson;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *label_userName;

@property (weak, nonatomic) IBOutlet UILabel *label_UserCompany;

@property (nonatomic, strong) NSDictionary *currentUserInfo;

@property (nonatomic, strong) NSTimer *trackingTimer;

@property (nonatomic) NSInteger currentSelectedIndex;

@property (nonatomic) BMKUserLocation *lastLocation;

@property (nonatomic) CLLocationCoordinate2D lastCoords;

@property (nonatomic) __block UIBackgroundTaskIdentifier bgTask;

@property (nonatomic, strong) UITabBarController *alarmListVC;

@property (nonatomic, strong) UINavigationController *homePageVC;

@property (strong, nonatomic) UINavigationController *maintenanceVC;

@property (strong, nonatomic) UINavigationController *knowledgeVC;

@property (strong, nonatomic) NSMutableArray *menuItemArray;

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

@end

@implementation WorkerMenuViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    if (nil == self.trackingTimer) {
        self.trackingTimer = [NSTimer scheduledTimerWithTimeInterval:5 * 60 target:self
                                                            selector:@selector(getUserLocationUpdate) userInfo:nil repeats:YES];
    }

    //启动定位
    //self.trackingTimer =  [NSTimer scheduledTimerWithTimeInterval:1 * 60 target:self selector:@selector(getUserLocationUpdate) userInfo:nil repeats:YES];

    //在这里加载头像，解决更新头像后头像无法及时显示的问题
    [self setPersonIcon:[User sharedUser].picUrl];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self getUserLocationUpdate];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMenuItemArray];

    BOOL suc = [self copyKnowledge];

    self.currentSelectedIndex = 0;

    self.label_userName.text = [User sharedUser].userName;
    self.label_UserCompany.text = [User sharedUser].branch;


    if ([self respondsToSelector:@selector(getALarmNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getALarmNotification:)
                                                     name:@"alarmNotification" object:nil];
    }

    //添加定位成功返回监听
    if ([self respondsToSelector:@selector(uploadLocationWhenReceivedNotify:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadLocationWhenReceivedNotify:)
                                                     name:@"userLocationUpdate" object:nil];
    }

    self.viewPerson.userInteractionEnabled = YES;
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalCenter)];
    [self.viewPerson addGestureRecognizer:recognizer];

    //设置头像为圆形
    self.imageViewIcon.layer.masksToBounds = YES;
    self.imageViewIcon.layer.cornerRadius = 40;
    [self setPersonIcon:[User sharedUser].picUrl];


    [self startTimer];
}

/**
 *  init the menu item
 */
- (void)initMenuItemArray {
    self.menuItemArray = [[NSMutableArray alloc] init];

    MenuItem *alarm = [MenuItem instantiateMenuItemWithTile:@"项目报警" image:[UIImage imageNamed:@"icon_homePage"]
                                                     action:@selector(homePage)];
    MenuItem *alarmList = [MenuItem instantiateMenuItemWithTile:@"报警列表" image:[UIImage imageNamed:@"icon_AlarmList"]
                                                         action:@selector(alarmList)];
    MenuItem *maintenance = [MenuItem instantiateMenuItemWithTile:@"维保管理" image:[UIImage imageNamed:@"icon_lift"]
                                                           action:@selector(maintenancePage)];
    MenuItem *knowledge = [MenuItem instantiateMenuItemWithTile:@"电梯百科" image:[UIImage imageNamed:@"icon_knowledge"]
                                                         action:@selector(knowledgePage)];

    [self.menuItemArray addObject:alarm];
    [self.menuItemArray addObject:alarmList];

    //shanghai has no the maintence function
    if (![self isInShanghai]) {
        [self.menuItemArray addObject:maintenance];
    }
    [self.menuItemArray addObject:knowledge];

}

//点击进入首页
- (void)homePage {

    if (!self.homePageVC) {
        self.homePageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"workerHomePageViewController"];

    }
    [self.sideMenuViewController setContentViewController:self.homePageVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

//点击进入报警列表
- (void)alarmList {

    if (!self.alarmListVC) {
        self.alarmListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkerAlarmList"];
    }

    [self.sideMenuViewController setContentViewController:self.alarmListVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}

/**进入维保管理页面**/
- (void)maintenancePage {
    if (!self.maintenanceVC) {
        self.maintenanceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"worker_mantenance_controller"];
    }
    [self.sideMenuViewController setContentViewController:self.maintenanceVC];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)knowledgePage {
    if (!self.knowledgeVC) {
        self.knowledgeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KnowledgeNavigationController"];
    }
    [self.sideMenuViewController setContentViewController:self.knowledgeVC];
    [self.sideMenuViewController hideMenuViewController];
}


/**
 *  进入个人中心
 */
- (void)personalCenter {
//    if (!self.personalVC) {
//        UIStoryboard *personalStoryBoard = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
//        self.personalVC = [personalStoryBoard instantiateViewControllerWithIdentifier:@"personalCenter"];
//    }
    UIStoryboard *personalStoryBoard = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
    UIViewController *personVC = [personalStoryBoard instantiateViewControllerWithIdentifier:@"personalCenter"];
    //[self.sideMenuViewController setContentViewController:self.personalVC];
    //[self.sideMenuViewController hideMenuViewController];
    //[self showViewController:self.personalVC sender:self];
    [self presentViewController:personVC animated:YES completion:nil];
}

/**
 *  获取详细报警信息
 *
 *  @param alarmId   <#alarmId description#>
 *  @param userState <#userState description#>
 */
- (void)getAlarmDetail:(NSString *)alarmId userState:(NSInteger)userState {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"workerAlarmProcessViewController"];
    AlarmProcessViewController *vc = [[nav viewControllers] objectAtIndex:0];
    self.delegate = vc;

    vc.alarmId = alarmId;
    vc.userState = userState;

    [self.sideMenuViewController presentViewController:nav animated:YES completion:nil];

}


#pragma mark - getALarmNotification

//接收到报警
- (void)getALarmNotification:(NSNotification *)notification {

    self.currentUserInfo = nil;

    self.currentUserInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];

    if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"WORKER_CHOSEN_FALSE"]) {
        [HUDClass showHUDWithLabel:@"您接单的任务未被指派" view:self.view];

    } else if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"WORKER_CHOSEN_TRUE"]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"任务指派" message:@"您已被指派新任务，请点击查看"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];

        alert.tag = 1;

        [alert show];

    } else if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"WORKER_ALARM"]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新的报警" message:@"有一条新的报警信息，请点击查看"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alert.tag = 1;

        [alert show];

    } else if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"MAIN_DENIED"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"维保消息" message:@"您有电梯维保计划被拒绝，请点击查看"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];

        alert.tag = 1;

        [alert show];

    } else if ([[notification.userInfo objectForKey:@"notifyType"] isEqualToString:@"ALARM_CANCEL"]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息" message:@"当前报警已经撤消"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 2;
        [alert show];
    }

}


#pragma mark - getUserLocationUpdate


- (void)getUserLocationUpdate {

    [[location sharedLocation] startLocationService];
}

- (void)uploadLocationWhenReceivedNotify:(NSNotification *)notify {
    BMKUserLocation *location = (BMKUserLocation *) [notify.userInfo objectForKey:@"userLocation"];
    if (nil == location) {
        return;
    }

    float latitude = location.location.coordinate.latitude;
    float longitude = location.location.coordinate.longitude;


    if (latitude < 0.00001 && longitude < 0.00001) {
        NSLog(@"may be wrong coords");
        return;
    }

    [self uploadLocationWithLatitude:latitude longitude:longitude success:nil];
}


#pragma mark - UIappdelegate

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [self backgroundHandler];
}

/**
 *  执行后台任务？有个毛线用写在这里
 */
- (void)backgroundHandler {

    //self.loca.locationSpace = YES; //这个属性设置再后台定位的时间间隔 自己在定位类中加个定时器就行了

    UIApplication *app = [UIApplication sharedApplication];

    //声明一个任务标记 可在.h中声明为全局的  __block    UIBackgroundTaskIdentifier bgTask;
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{

        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.bgTask != UIBackgroundTaskInvalid) {
                self.bgTask = UIBackgroundTaskInvalid;
            }
        });

    }];

    // 开始执行长时间后台执行的任务 项目中启动后定位就开始了 这里不需要再去执行定位 可根据自己的项目做执行任务调整
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        while (1) {

            [self getUserLocationUpdate];
            //NSLog(@"finish cheking location");
            sleep(30);
        }
    });
}


#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (0 == buttonIndex) {
        if (2 == alertView.tag) {
            [self.delegate onReceiveAlarmCancelMessage];
        }
    }
    if (buttonIndex == 1) {
        [self getAlarmDetail:[self.currentUserInfo objectForKey:@"alarmId"] userState:alertView.tag];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

//    if ([self isInShanghai]) {
//        return 3;
//    } else {
//       return 4;
//    }
    return self.menuItemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkerMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workerMenuCell" forIndexPath:indexPath];

    // Configure the cell...

    MenuItem *menuItem = self.menuItemArray[indexPath.row];
    cell.imageView_menuIcon.image = menuItem.itemImage;
    cell.label_menuTitle.text = menuItem.itemTitle;

    if (0 == indexPath.row) {
        cell.imageView_accessory.hidden = NO;
    } else {
        cell.imageView_accessory.hidden = YES;
    }

//    cell.imageView_accessory.hidden = YES;
//    
//    if (indexPath.row == 0)
//    {
//        cell.imageView_menuIcon.image = [UIImage imageNamed:@"icon_homePage.png"];
//        cell.label_menuTitle.text = @"首页";
//        cell.imageView_accessory.hidden = NO;
//    }
//    else if (indexPath.row == 1)
//    {
//        cell.imageView_menuIcon.image = [UIImage imageNamed:@"icon_AlarmList.png"];
//        cell.label_menuTitle.text = @"报警列表";
//        //cell.imageView_accessory.hidden = YES;
//    }
//    else if (2 == indexPath.row)
//    {
//        cell.imageView_menuIcon.image = [UIImage imageNamed:@"icon_lift"];
//        cell.label_menuTitle.text = @"维保管理";
//    }
//    else if (3 == indexPath.row)
//    {
//        cell.imageView_menuIcon.image = [UIImage imageNamed:@"icon_knowledge"];
//        cell.label_menuTitle.text = @"电梯百科";
//    }

    return cell;
}

- (void)startTimer {
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
}

- (void)timerAdvanced:(NSTimer *)timer {
    //NSLog([NSString stringWithFormat:@"backgroundTimeRemaining:%f",[[UIApplication sharedApplication] backgroundTimeRemaining]]);
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0) {
        //NSLog(@"<61");
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"Alarm" ofType:@"mp3"];
        NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];

        if (self.avAudioPlayer == nil) {
            self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
            self.avAudioPlayer.delegate = self;
            self.avAudioPlayer.volume = 0.0f;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        }
        //NSLog(@"start playing");
        [self.avAudioPlayer play];
        self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{

            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.bgTask != UIBackgroundTaskInvalid) {
                    self.bgTask = UIBackgroundTaskInvalid;
                }
            });

        }];
    } else {
        //NSLog(@"=======>61");
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //self.delegate = nil;

    if (self.currentSelectedIndex != indexPath.row) {
        WorkerMenuCell *oldCell = (WorkerMenuCell *) [tableView
                cellForRowAtIndexPath:
                        [NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0]];

        WorkerMenuCell *newCell = (WorkerMenuCell *) [tableView cellForRowAtIndexPath:indexPath];

        oldCell.imageView_accessory.hidden = YES;
        newCell.imageView_accessory.hidden = NO;

        self.currentSelectedIndex = indexPath.row;

        MenuItem *menuItem = self.menuItemArray[indexPath.row];
        [self performSelector:menuItem.action];

//        if (indexPath.row == 0) {
//            [self homePage];
//            
//        } else if (indexPath.row == 1) {
//            [self alarmList];
//            
//        } else if (2 == indexPath.row) {    //维保管理
//            [self maintenancePage];
//        }

    }

    [self.sideMenuViewController hideMenuViewController];

}


/**
 *  根据URL下载图片并保存
 *
 *  @param urlString <#urlString description#>
 *  @param dirPath   <#dirPath description#>
 *  @param fileName  <#fileName description#>
 */

- (void)downloadIconByUrlString:(NSString *)urlString dirPath:(NSString *)dirPath fileName:(NSString *)fileName {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {

        if (data.length > 0 && nil == connectionError) {
            [FileUtils writeFile:data Path:dirPath fileName:fileName];
            [self performSelectorOnMainThread:@selector(setPersonIcon:) withObject:urlString waitUntilDone:NO];

        } else if (connectionError != nil) {
            //NSLog(@"download picture error = %@", connectionError);
        }
    }];
}


/**
 *  设置头像/
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
 *  在后台上传位置信息，不在使用HUDClass阻塞UI刷新
 *
 *  @param latitude  <#latitude description#>
 *  @param longitude <#longitude description#>
 */
- (void)uploadLocationWithLatitude:(float)latitude longitude:(float)longitude
                           success:(void (^)(void))success {

    NSString *urlString = [[Utils getServer] stringByAppendingString:@"updateLocation"];
    NSURL *url = [NSURL URLWithString:urlString];


    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];

    //设置head
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];

    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];

    [head setObject:[NSString stringWithFormat:@"%@", [User sharedUser].accessToken] forKey:@"accessToken"];
    [head setObject:[User sharedUser].userId forKey:@"userId"];



    //设置body
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];

    //    [body setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"lat"];
    //    [body setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"lng"];

    [body setObject:[NSNumber numberWithFloat:latitude] forKey:@"lat"];
    [body setObject:[NSNumber numberWithFloat:longitude] forKey:@"lng"];


    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:head forKey:@"head"];
    [params setObject:body forKey:@"body"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [urlRequest setHTTPBody:jsonData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {


        if (data.length > 0 && nil == connectionError) {
            if (success != nil) {
                success();
            }

//            NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
//            NSDictionary *head = [jsonDic objectForKey:@"head"];
            //NSString *rspCode = [head objectForKey:@"rspCode"];
            //NSLog(@"rspCode:%@", rspCode);
        }
    }];
}


/**
 *  确定是否在上海
 *
 *  @return <#return value description#>
 */
- (BOOL)isInShanghai {
    NSString *zone = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlString"];
    if ([zone isEqualToString:@"上海"]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  copy the sqlite files in the resouce to the SQLITE_PATH
 *
 *  @return
 */
- (bool)copyKnowledge {
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"knowledge" ofType:@"db"];
    NSString *sqlitePath = [NSHomeDirectory() stringByAppendingString:SQLITE_PATH];
    NSString *sqliteName = SQLITE_KN_NAME;
    return [FileUtils copyFilesFrom:sourcePath to:sqlitePath fileName:sqliteName];
}


/**
 *  显示提示
 */
- (void)showMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有未处理完成的报警任务，请到报警列表查看!"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


@end
