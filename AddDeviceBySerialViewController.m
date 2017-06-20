//
//  AddDeviceBySerialViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "AddDeviceBySerialViewController.h"
#import "Device.h"
@interface AddDeviceBySerialViewController ()
@property (strong, nonatomic) IBOutlet UIView *serialBgView;
@property (strong, nonatomic) IBOutlet UITextField *serialTextField;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passWordTextField;
@property (strong, nonatomic) UIActivityIndicatorView *addDeviceViewIndicatorView;

@end

@implementation AddDeviceBySerialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addDeviceViewIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _addDeviceViewIndicatorView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    [_addDeviceViewIndicatorView hidesWhenStopped];
    _addDeviceViewIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:_addDeviceViewIndicatorView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _serialBgView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
}
- (IBAction)addDeviceBySerialClick:(id)sender {
    //获取设备信息
    //登录
    //添加
     if (_serialTextField.text.length > 0 && _serialTextField != nil && _userTextField.text.length >0 && _userTextField != nil && _passWordTextField.text.length > 0 && _passWordTextField != nil) {
        [self startAnimation];
        
       [[AccountManager sharedManager].ydtNetSdk getSpecifiedDeviceWithoutLoginWithDeviceSn:_serialTextField.text completionHandler:^(YdtDeviceInfo *deviceInfo) {
        
           if (deviceInfo.errorCode == 0) {
               
               YdtDeviceParam *deviceParam = deviceInfo.deviceArray[0];
               Device *deviceInfo = [[Device alloc] init];
               deviceInfo.serialNO = deviceParam.deviceSn;
               deviceInfo.userName = deviceParam.deviceUser;
               deviceInfo.deviceID = deviceParam.deviceId;
               deviceInfo.domain = deviceParam.deviceDomain;
               deviceInfo.domainPort = deviceParam.deviceDomainPort;
               deviceInfo.vveyeID = deviceParam.deviceVNIp;
               deviceInfo.password = deviceParam.devicePassword;
               deviceInfo.vveyeRemotePort = deviceParam.deviceVNPort;
               
               [deviceInfo loginWithBlick:^(BOOL loginStatus) {
                  
                   if (loginStatus) {
                       
                       [[AccountManager sharedManager].ydtNetSdk addDeviceBySnWithDeviceId:deviceInfo.deviceID deviceName:deviceParam.deviceName deviceUser:deviceParam.deviceUser devicePassword:deviceParam.devicePassword channelCount:deviceParam.deviceChannelCount completionHandler:^(YdtDeviceInfo *deviceInfo) {
                           
                           if (deviceInfo.errorCode == 0) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self stopAnimation];
                                   [self showAlertViewWithString:@"添加设备成功"];
                               });
                              
                           } else {
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self stopAnimation];
                                   [self showAlertViewWithString:[NSString stringWithFormat:@"%d",deviceInfo.errorCode]];
                               });
                           }
                       }];
                       
                   } else {
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self stopAnimation];
                           [self showAlertViewWithString:@"设备登录失败"];
                       });
 
                       
                   }
               }];
               
           } else {
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self stopAnimation];
                   [self showAlertViewWithString:[NSString stringWithFormat:@"%d",deviceInfo.errorCode]];
               });
               
           }
           
       }];
        
    } else {
        [self showAlertViewWithString:@"请完善信息"];
    }
}

- (void)startAnimation {
    
    [_addDeviceViewIndicatorView startAnimating];
    _serialBgView.userInteractionEnabled = NO;
}
- (void)stopAnimation {
    
    [_addDeviceViewIndicatorView stopAnimating];
    _serialBgView.userInteractionEnabled = YES;
}

- (void)showAlertViewWithString:(NSString *)string {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [self performSelector:@selector(addDeviceBySerialViewDismissAlertView:) withObject:alertView afterDelay:1.0];
}
- (void)addDeviceBySerialViewDismissAlertView:(UIAlertView *)alertView {
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
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
