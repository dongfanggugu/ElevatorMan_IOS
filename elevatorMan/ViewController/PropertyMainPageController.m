//
//  PropertyMainPageController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/4.
//
//

#import <Foundation/Foundation.h>
#import "PropertyMainPageController.h"
#import "ProAlarmTabBarController.h"

@interface PropertyMainPageController()

@property (weak, nonatomic) IBOutlet UIView *viewRescue;

@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (weak, nonatomic) IBOutlet UIView *viewAround;

@property (weak, nonatomic) IBOutlet UIView *viewMarket;

@property (weak, nonatomic) IBOutlet UIView *viewOther;

@property (weak, nonatomic) IBOutlet UIView *viewPerson;


@end



@implementation PropertyMainPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯易管家"];
    [self iniView];
}

- (void)iniView
{
    
    self.tableView.allowsSelection = NO;
    self.tableView.bounces = NO;

    _viewRescue.layer.masksToBounds = YES;
    _viewRescue.layer.cornerRadius = 8;
    _viewRescue.userInteractionEnabled = YES;
    [_viewRescue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rescue)]];
    
    
    _viewMarket.layer.masksToBounds = YES;
    _viewMarket.layer.cornerRadius = 8;
    _viewMarket.userInteractionEnabled = YES;
    [_viewMarket addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(market)]];
    
    
    _viewOther.layer.masksToBounds = YES;
    _viewOther.layer.cornerRadius = 8;
    _viewOther.userInteractionEnabled = YES;
    [_viewOther addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(other)]];
    
    
    _viewMain.layer.masksToBounds = YES;
    _viewMain.layer.cornerRadius = 8;
    _viewMain.userInteractionEnabled = YES;
    [_viewMain addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maintenance)]];
    
    _viewAround.layer.masksToBounds = YES;
    _viewAround.layer.cornerRadius = 8;
    _viewAround.userInteractionEnabled = YES;
    [_viewAround addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(around)]];
    
    _viewPerson.layer.masksToBounds = YES;
    _viewPerson.layer.cornerRadius = 8;
    _viewPerson.userInteractionEnabled = YES;
    [_viewPerson addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(person)]];

}

- (void)rescue
{
    ProAlarmTabBarController *controller = [[ProAlarmTabBarController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)market
{
    [HUDClass showHUDWithLabel:@"功能开发中" view:self.view];
}

- (void)other
{
    [HUDClass showHUDWithLabel:@"功能开发中" view:self.view];
}


- (void)maintenance
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Property" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"mantenanceController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)around
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyProperty" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"around_controller"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)person
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"person_center"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
