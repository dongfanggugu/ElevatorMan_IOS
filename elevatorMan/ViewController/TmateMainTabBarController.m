//
// Created by changhaozhang on 2017/6/17.
//

#import "TmateMainTabBarController.h"
#import "PersonalCenterController.h"
#import "TmateMainPageController.h"
#import "EAssistViewController.h"
#import "BaseNavigationController.h"


@implementation TmateMainTabBarController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"首页"];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    TmateMainPageController *mainPage = [[TmateMainPageController alloc] init];

    BaseNavigationController *navMain = [[BaseNavigationController alloc] initWithRootViewController:mainPage];
    
    
    EAssistViewController *eAssist = [[EAssistViewController alloc] init];
    
    BaseNavigationController *navE = [[BaseNavigationController alloc] initWithRootViewController:eAssist];
    
    
    
    PersonalCenterController *person = [[PersonalCenterController alloc] init];

    BaseNavigationController *navPerson = [[BaseNavigationController alloc] initWithRootViewController:person];


    self.viewControllers = [NSArray arrayWithObjects:navMain, navE, navPerson, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;

    tabBar.tintColor = [Utils getColorByRGB:TITLE_COLOR];
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"icon_main_page_bottom_normal.png"]];
    [[tabBar.items objectAtIndex:0] setSelectedImage:[UIImage imageNamed:@"icon_main_page_bottom_sel.png"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"首页"];

    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_person_bottom_normal.png"]];
    [[tabBar.items objectAtIndex:1] setSelectedImage:[UIImage imageNamed:@"icon_person_bottom_sel.png"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"商机"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_person_bottom_normal.png"]];
    [[tabBar.items objectAtIndex:2] setSelectedImage:[UIImage imageNamed:@"icon_person_bottom_sel.png"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"我的"];

}

- (void)setNavTitle:(NSString *)title
{
    if (!self.navigationController)
    {
        return;
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    label.text = title;
    label.font = [UIFont fontWithName:@"System" size:17];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:label];
}

#pragma mark -- 设置状态栏字体为白色

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
