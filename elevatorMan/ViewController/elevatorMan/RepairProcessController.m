//
//  RepairProcessController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "RepairProcessController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface RepairProcessController ()

@property (strong, nonatomic) UIButton *btn;

@end

@implementation RepairProcessController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (Repair_Start == _process)
    {
        [self setNavTitle:@"维修出发"];
    }
    else
    {
        [self setNavTitle:@"维修到达"];
    }

    [self initView];
}

- (void)initView
{
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    [self.view addSubview:mapView];
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    _btn.layer.masksToBounds = YES;
    
    _btn.layer.cornerRadius = 40;

    if (Repair_Start == _process)
    {
        [_btn setTitle:@"出发" forState:UIControlStateNormal];
    }
    else
    {
        [_btn setTitle:@"到达" forState:UIControlStateNormal];
    }

    [_btn setBackgroundColor:[UIColor colorWithRed:245 / 255.0 green:100 / 255.0 blue:95 / 255.0 alpha:0.8]];
    _btn.center = CGPointMake(self.screenWidth / 2, self.screenHeight - 60);
    
    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btn];
}

- (void)clickBtn
{
    __weak typeof (self) weakSelf = self;

    if (Repair_Start == _process)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确定出发前往别墅进行维修?" message:nil preferredStyle:UIAlertControllerStyleAlert];

        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf start];
        }]];

        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];

        [self presentViewController:controller animated:YES completion:nil];

    }
    else
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"您已经到达别墅?" message:nil preferredStyle:UIAlertControllerStyleAlert];

        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf arrive];
        }]];

        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];

        [self presentViewController:controller animated:YES completion:nil];
    }
}


- (void)start
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"repairOrderProcessId"] = _taskInfo[@"id"];

    __weak typeof (self) weakSelf = self;

    [[HttpClient sharedClient] post:@"editRepairOrderProcessWorkerSetOut" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.btn setTitle:@"到达" forState:UIControlStateNormal];
    }];
}

- (void)arrive
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"repairOrderProcessId"] = _taskInfo[@"id"];

    __weak typeof (self) weakSelf = self;

    [[HttpClient sharedClient] post:@"editRepairOrderProcessWorkerArrive" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}


@end
