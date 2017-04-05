//
//  AppDelegate.m
//  elevatorMan
//
//  Created by Cove on 15/3/15.
//
//
#import "AppDelegate.h"



#import "APService.h"
#import <BaiduMapAPI/BMapKit.h>
#import <KeyboardManager.h>
#import "EaseMob.h"
#import "HttpClient.h"
#import "Utils.h"
#import "GuideViewController.h"


#define BM_APPKEY @"STwt3Ei6SyYPAxMlAOTvGUNS"



BMKMapManager* _mapManager;


@interface AppDelegate ()<BMKGeneralDelegate, UIAlertViewDelegate>

@property (strong ,nonatomic) UIApplication *mApplication;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _mLaunchOptions = launchOptions;
    
    [self startupApplicaiton:application Options:launchOptions];
    
    [self checkUpdate];
    
    UIDevice *device = [UIDevice currentDevice];
    //NSLog(@"device model:%@", [device model]);
//    if ([[device model] isEqualToString:@"iPhone"])
//    {
//         [self redirectNSLogToDocumentFolder];
//    }
    
    //[self redirectNSLogToDocumentFolder];
    
    return YES;
}


//注册推送通知失败
- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//注册推送通知成功
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    //NSLog(@"deviceToken：%@",deviceToken);
    //获得deviceToken
    
    NSString *token = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    NSLog(@"device token:%@", token);
    [APService registerDeviceToken:deviceToken];
    
    //将deviceToken存入requestHead中
    
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler
{
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
//    // 取得 APNs 标准信息内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//    
//    // 取得自定义字段内容
//    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    //[[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
    // Required
    [APService handleRemoteNotification:userInfo];
    
    //[APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@",userInfo);
    //[rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler
{
    //播放的声音
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *sound = [aps valueForKey:@"sound"];
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
    [APService handleRemoteNotification:userInfo];
    NSLog(@"remote notify:%@",userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"alarmNotification" object:nil userInfo:userInfo];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //[BMKMapView willBackGround];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[BMKMapView didForeGround];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else
    {
        NSLog(@"联网失败:%d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"授权失败:%d",iError);
    }
}

- (void)startupApplicaiton:(UIApplication *)application Options:(NSDictionary *)launchOptions {

    //绘制窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //sleep(1);
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"123.57.10.16" forKey:@"urlType"];
    
    
    
    /////-------------设置通知注册相关内容
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
//        [APService
//         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                             UIUserNotificationTypeSound |
//                                             UIUserNotificationTypeAlert)
         [APService
          registerForRemoteNotificationTypes:(UIUserNotificationTypeSound |
                                              UIUserNotificationTypeAlert)
         categories:nil];
    }
    else
    {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
         categories:nil];
    }
#else
    [APService
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)
     categories:nil];
#endif
    
    [APService setupWithOption:launchOptions];
    ////---------------设置通知注册相关内容END
    
    
    
    ////---------------百度地图
    //要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BM_APPKEY generalDelegate:self];
    
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    ////---------------百度地图end
    
    //
    
    
    
    
   
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
    
    
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
    
    GuideViewController *controller = [[GuideViewController alloc] init];
    controller.window = _window;
    self.window.rootViewController = controller;
    
//    //第一次启动
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        
//        GuideViewController *controller = [[GuideViewController alloc] init];
//        controller.window = _window;
//        self.window.rootViewController = controller;
//        
//    }
//    else//不是第一次启动
//    {
//        GuideViewController *controller = [[GuideViewController alloc] init];
//        controller.window = _window;
//        self.window.rootViewController = controller;
//        
//    }

    
    
}

/**
 *  提示进行升级
 */
- (void)alertUpdate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新的版本可用，请进行升级" delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"升级", nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //升级，跳转到app下载页面
    if (1 == buttonIndex) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://fir.im/ElevatorMan"]];
    }
}

/**
 *  检测是否需要升级
 */
- (void)checkUpdate {
    
    NSString *urlString = [[Utils getServer] stringByAppendingString:@"checkVersion"];
    NSLog(@"url:%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *reqBody = @"{\"head\":{\"osType\":\"1\"}}";
    [urlRequest setHTTPBody:[reqBody dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        
        if (data.length > 0 && nil == connectionError) {
            NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"JSON:%@", json);
            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *head = [jsonDic objectForKey:@"head"];
            NSString *rspCode = [head objectForKey:@"rspCode"];
            if (![rspCode isEqualToString:@"0"]) {
                return;
            }
            
            NSDictionary *body = [jsonDic objectForKey:@"body"];
            
            NSNumber *remote = [body objectForKey:@"appVersion"];
            NSLog(@"remote version:%@", remote);
            
            NSNumber *local = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            NSLog(@"local version:%@", local);
            
            if(remote.integerValue > local.integerValue) {
                [self performSelectorOnMainThread:@selector(alertUpdate) withObject:nil waitUntilDone:NO];
            }

        }
    }];
}

- (void)redirectNSLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,
                                                         YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    //NSFileManager *defaultManager = [NSFileManager defaultManager];
    //[defaultManager removeItemAtPath:logFilePath error:nil];
    
    //output the log to the file
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSString *str = url.resourceSpecifier;
    NSLog(@"url:%@", str);
    return YES;
}


@end
