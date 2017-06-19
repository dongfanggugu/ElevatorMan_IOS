//
//  GuideViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/6.
//
//

#import <Foundation/Foundation.h>
#import "GuideViewController.h"
#import "CDPGifScrollView.h"
#import "AppDelegate.h"
#import "TmateMainPageController.h"
#import "TmateMainTabBarController.h"
#import "BaseNavigationController.h"

@interface GuideViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end


@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGifView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


    [NSTimer scheduledTimerWithTimeInterval:4.5 target:self
                                   selector:@selector(login) userInfo:nil repeats:NO];

}

- (void)login
{

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];

    [[User sharedUser] getUserInfo];

    //判断是否已经登录
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogged"])
    {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"signviewcontroller"];
    }
    else
    {

        TmateMainTabBarController *controller = [[TmateMainTabBarController alloc] init];
        self.window.rootViewController = controller;


//        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin])//物业
//        {
//
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyProperty" bundle:nil];
//
//            [UIApplication sharedApplication].delegate.window.rootViewController =
//                    [story instantiateViewControllerWithIdentifier:@"property_main_page"];
//
//
//        }
//        else if ([[User sharedUser].userType isEqualToString:UserTypeWorker])//维修工
//        {
//            TmateMainTabBarController *controller = [[TmateMainTabBarController alloc] init];
//            self.window.rootViewController = controller;
//
////            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////
////            //[UIApplication sharedApplication].delegate.window.rootViewController = [story  instantiateViewControllerWithIdentifier:@"workerRootViewController"];
////            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"main_page"];
////            self.window.rootViewController = controller;
//        }
    }

}

- (void)initGifView
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];

    NSString *file = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide"] ofType:@"gif"];

    [dataArr addObject:file];

    CDPGifScrollView *gifScrollView = [[CDPGifScrollView alloc] initWithGifImageArr:dataArr
                                                                           andFrame:CGRectMake(0, 0,
                                                                                   self.view.bounds.size.width, self.view.bounds.size.height)];

    [self.view addSubview:gifScrollView];
}

- (void)initView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;

    _scrollView.contentSize = CGSizeMake(width * 7, height);
    [self.view addSubview:_scrollView];

    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView1.image = [UIImage imageNamed:@"nav1"];


    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    imageView2.image = [UIImage imageNamed:@"nav2"];

    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
    imageView3.image = [UIImage imageNamed:@"nav3"];

    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(width * 3, 0, width, height)];
    imageView4.image = [UIImage imageNamed:@"nav_4"];


    UIImageView *imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(width * 4, 0, width, height)];
    imageView5.image = [UIImage imageNamed:@"nav_5"];

    UIImageView *imageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(width * 5, 0, width, height)];
    imageView6.image = [UIImage imageNamed:@"nav_6"];

    UIImageView *imageView7 = [[UIImageView alloc] initWithFrame:CGRectMake(width * 6, 0, width, height)];
    imageView7.image = [UIImage imageNamed:@"nav_7"];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width * 6 + width / 2 - 70, height - 100, 140, 40)];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];

    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;

    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;

    [button addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];

    [_scrollView addSubview:imageView1];
    [_scrollView addSubview:imageView2];
    [_scrollView addSubview:imageView3];
    [_scrollView addSubview:imageView4];
    [_scrollView addSubview:imageView5];
    [_scrollView addSubview:imageView6];
    [_scrollView addSubview:imageView7];
    [_scrollView addSubview:button];

}

- (void)enter
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogged"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"signviewcontroller"];
    }
}

#pragma mark -- 设置状态栏字体为白色

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
