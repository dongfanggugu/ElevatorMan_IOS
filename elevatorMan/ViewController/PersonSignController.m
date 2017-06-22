//
//  PersonSignController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/4/21.
//
//

#import "PersonSignController.h"
#import "UIImageView+AFNetworking.h"
#import "HUDClass.h"
#import "PaintViewController.h"

@interface PersonSignController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation PersonSignController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"个人签名"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (0 == [User sharedUser].signUrl)
    {

        [self initNavRightWithText:@"添加"];
        [self showMsgAlert:@"您还未添加您的个人手写签名,请录入您的签名"];
        return;
    }
    else
    {
        [self initNavRightWithText:@"修改"];
        [_imageView setImageWithURL:[NSURL URLWithString:[User sharedUser].signUrl]];
    }
}

- (void)initView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    [self.view addSubview:_imageView];
}

- (void)onClickNavRight
{

    PaintViewController *controller = [[PaintViewController alloc] init];

    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
