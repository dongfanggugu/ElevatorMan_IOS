//
//  DeviceViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "DeviceViewController.h"
#import "DeviceTableViewCell.h"
#import "AddDeviceMainViewController.h"
@interface DeviceViewController ()<UITableViewDelegate, UITableViewDataSource,DeviceTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *deviceListView;
@property (strong, nonatomic) IBOutlet UIView *deviceBgView;
@property (strong ,nonatomic) NSMutableArray *deviceDataArray;
@property (strong, nonatomic) UIActivityIndicatorView *deviceViewIndicatorView;

@end

@implementation DeviceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _deviceDataArray = [NSMutableArray arrayWithCapacity:0];

    _deviceViewIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _deviceViewIndicatorView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    [_deviceViewIndicatorView hidesWhenStopped];
    _deviceViewIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:_deviceViewIndicatorView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     _deviceBgView.center =  CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    _deviceListView.delegate = self;
    _deviceListView.dataSource = self;
    
    //获取设备列表
    [self startAnimation];
    [[AccountManager sharedManager].ydtNetSdk getDevicesBelongsToAccountWithCompletionHandler:^(YdtDeviceInfo *deviceInfo) {
        
        if (deviceInfo.errorCode == 0) {
           
            if (deviceInfo.deviceArray.count > 0 && deviceInfo.deviceArray != nil) {
                
                [[AccountManager sharedManager] setDeviceListOfAccoutFromServer:deviceInfo.deviceArray];
                _deviceDataArray = [NSMutableArray arrayWithArray:deviceInfo.deviceArray];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self stopAnimation];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取设备成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.0];
                    [_deviceListView reloadData];
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopAnimation];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"账户下无设备" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.0];
                });
            }
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopAnimation];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取设备失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.0];
            });
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _deviceDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"deviceCell";
    DeviceTableViewCell *deviceCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (deviceCell == nil) {
        deviceCell = (DeviceTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil] objectAtIndex:0];
        deviceCell.delegate = self;
    }
    
    YdtDeviceParam *deviceParam = _deviceDataArray[indexPath.row];
    deviceCell.deviceSerailNo.text = deviceParam.deviceSn;
    return deviceCell;
}

- (IBAction)addDeviceClick:(id)sender {
    
    AddDeviceMainViewController *addDeviceMain = [[AddDeviceMainViewController alloc] initWithNibName:@"AddDeviceMainViewController" bundle:nil];
    addDeviceMain.title = @"添加设备";
    [self.tabBarController.navigationController pushViewController:addDeviceMain animated:YES];
}

- (IBAction)getDeviceList:(id)sender {
    
    //
}

#pragma mark - DeviceTableViewCellDelegate -
- (void)delegateDeviceBySerail:(NSString *)serial {
    
    for (YdtDeviceParam *tempDeviceParam in _deviceDataArray) {
        
        if ([tempDeviceParam.deviceSn  isEqualToString:serial]) {
            [self startAnimation];
         [[AccountManager sharedManager].ydtNetSdk deleteDeviceWithDeviceId:tempDeviceParam.deviceId completionHandler:^(int result) {
             
             if (result == YdtErrorSuccess) {
                 //获取账户下设备
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设备删除成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                     [alertView show];
                     [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.0];
                     
                 });
                 [[AccountManager sharedManager].ydtNetSdk getDevicesBelongsToAccountWithCompletionHandler:^(YdtDeviceInfo *deviceInfo) {
                     
                     if (deviceInfo.errorCode == 0) {
                         
                         _deviceDataArray = [NSMutableArray arrayWithArray:deviceInfo.deviceArray];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self stopAnimation];
                             [_deviceListView reloadData];
                             
                         });
                         
                     } else {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self stopAnimation];
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取设备失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                             [alertView show];
                             [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.0];
                             
                         });
                     }
                 }];
                 
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self stopAnimation];
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设备删除失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                 [alertView show];
                 [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.0];
                 });
             }
             
         }];
          break;
        }
    }
}

- (void)dismissAlertView:(UIAlertView *)alertView {
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)startAnimation {
    
    [_deviceViewIndicatorView startAnimating];
    _deviceBgView.userInteractionEnabled = NO;
}
- (void)stopAnimation {
    
    [_deviceViewIndicatorView stopAnimating];
    _deviceBgView.userInteractionEnabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
