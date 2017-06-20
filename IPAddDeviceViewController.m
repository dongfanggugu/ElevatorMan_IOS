//
//  IPAddDeviceViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "IPAddDeviceViewController.h"
#import "Device.h"
@interface IPAddDeviceViewController ()
@property (strong, nonatomic) IBOutlet UIView *ipAddDeviceBgView;
@property (strong, nonatomic) IBOutlet UITextField *ipTextField;
@property (strong, nonatomic) IBOutlet UITextField *portTextField;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passWordTextField;
@property (strong, nonatomic) UIActivityIndicatorView *ipAddDeviceViewIndicatorView;

@end

@implementation IPAddDeviceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _ipAddDeviceViewIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _ipAddDeviceViewIndicatorView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    [_ipAddDeviceViewIndicatorView hidesWhenStopped];
    _ipAddDeviceViewIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:_ipAddDeviceViewIndicatorView];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _ipAddDeviceBgView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
}
- (IBAction)ipAddDeviceClick:(id)sender {
   
    if (_ipTextField.text.length > 0 && _portTextField.text.length > 0 && _userTextField.text.length > 0 && _passWordTextField.text.length > 0) {
        
        //进行设备添加
        [self startAnimation];
        Device *ipDevice = [[Device alloc] init];
        ipDevice.domain = _ipTextField.text;
        ipDevice.domainPort = [_portTextField.text intValue];
        ipDevice.userName = _userTextField.text;
        ipDevice.password = _passWordTextField.text;
        //登录
        
        [ipDevice loginWithBlick:^(BOOL loginStatus) {
            
            if (loginStatus) {
                //登录成功
                //获取设备序列号
                NSString *deviceSerial = [ipDevice getDeviceSerialNO];
                
                [[AccountManager sharedManager].ydtNetSdk getSpecifiedDeviceWithoutLoginWithDeviceSn:deviceSerial completionHandler:^(YdtDeviceInfo *deviceInfo) {
                    
                    if (deviceInfo.errorCode == 0) {
                        //获取设备信息成功
                        YdtDeviceParam *deviceParam = deviceInfo.deviceArray[0];
                        
                        ipDevice.serialNO = deviceParam.deviceSn;
                        ipDevice.userName = deviceParam.deviceUser;
                        ipDevice.deviceID = deviceParam.deviceId;
                        ipDevice.domain = deviceParam.deviceDomain;
                        ipDevice.domainPort = deviceParam.deviceDomainPort;
                        ipDevice.vveyeID = deviceParam.deviceVNIp;
                        ipDevice.password = deviceParam.devicePassword;
                        ipDevice.vveyeRemotePort = deviceParam.deviceVNPort;
                        
                      //添加设备
                        if (ipDevice.domainPort == 0 || ipDevice.domain.length == 0 || ipDevice.domain == nil) {
                            
                            //局域网ip添加设备，使用设备序列号进行添加
                            [[AccountManager sharedManager].ydtNetSdk addDeviceBySnWithDeviceId:ipDevice.deviceID deviceName:deviceParam.deviceName deviceUser:deviceParam.deviceUser devicePassword:deviceParam.devicePassword channelCount:deviceParam.deviceChannelCount completionHandler:^(YdtDeviceInfo *deviceInfo) {
                                
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
                            
                            [[AccountManager sharedManager].ydtNetSdk addDeviceByDomainWithDeviceSn:ipDevice.serialNO deviceName:deviceParam.deviceName deviceUser:ipDevice.userName devicePassword:ipDevice.password deviceDomain:ipDevice.domain deviceDomainPort:ipDevice.domainPort channelCount:deviceParam.deviceChannelCount completionHandler:^(YdtDeviceInfo *deviceInfo) {
                                
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
                        }
                       
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopAnimation];
                            [self showAlertViewWithString:[NSString stringWithFormat:@"%d",deviceInfo.errorCode]];
                        });
                    }
                    
                }];
            } else {
                
                //登录失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopAnimation];
                    [self showAlertViewWithString:@"设备登录失败"];
                });
                
            }
        }];
        
    } else {
        
        //提示信息
        [self showAlertViewWithString:@"请完善信息"];
    }

}

- (void)startAnimation {
    
    [_ipAddDeviceViewIndicatorView startAnimating];
    _ipAddDeviceBgView.userInteractionEnabled = NO;
}
- (void)stopAnimation {
    
    [_ipAddDeviceViewIndicatorView stopAnimating];
    _ipAddDeviceBgView.userInteractionEnabled = YES;
}
- (void)showAlertViewWithString:(NSString *)string {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [self performSelector:@selector(ipAddDeviceViewDismissAlertView:) withObject:alertView afterDelay:1.0];
}
- (void)ipAddDeviceViewDismissAlertView:(UIAlertView *)alertView {
    
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
