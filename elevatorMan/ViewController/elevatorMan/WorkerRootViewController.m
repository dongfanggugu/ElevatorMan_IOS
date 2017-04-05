//
//  WorkerRootViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/23.
//
//

#import "WorkerRootViewController.h"

@interface WorkerRootViewController ()

@end

@implementation WorkerRootViewController


- (void)awakeFromNib
{
    
    //设置全局导航栏特性
    //[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:56/255.0 green:142/255.0 blue:212/255.0 alpha:1], NSForegroundColorAttributeName, font, NSFontAttributeName, nil]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    //self.scaleContentView = NO;
    self.bouncesHorizontally = NO;
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    self.rightMenuViewController = nil;
    self.backgroundImage = [UIImage imageNamed:@"background.png"];
    
    
    //AppDelegate* appdelegate = [UIApplication sharedApplication].delegate;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"workerHomePageViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"workerMenuViewController"];
    
    
    //self.delegate = self;
    //设置workerMenuViewController代理，用来处理头像修改后重新加载的问题
    self.delegate = self.leftMenuViewController;
}



@end
