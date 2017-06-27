//
//  VideoTestViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "VideoTestViewController.h"
#import "Device.h"
#import "Viewport.h"

#define VIDEOFIELOFHISTOYVIEWTAG 300
#define VIDEODEVICELISTTABLEVIEWTAG 400
@interface VideoTestViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *playView;
@property (strong, nonatomic) IBOutlet UIView *videoTestBgView;
@property (strong, nonatomic) IBOutlet UILabel *deviceSerialLable;
@property (strong, nonatomic) IBOutlet UIDatePicker *palyBackTimePicker;
@property (strong, nonatomic) IBOutlet UITableView *videoFileOfHistoryTableView;
@property (strong, nonatomic) IBOutlet UITableView *deviceListTableView;
@property (strong, nonatomic) IBOutlet UIView *playBackTImePickerBgView;
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@property (nonatomic, strong) NSMutableArray *videoFileOfHistoryArray;
@property (strong, nonatomic) IBOutlet UIButton *previewButton;
@property (strong, nonatomic) UILabel *fileCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *deviceLoginButton;
@property (nonatomic, strong) UIActivityIndicatorView *videoViewIndicatorView;
@property (nonatomic, strong) Viewport *viewPort;
@property (nonatomic, strong) YdtDeviceParam *chooseDeviceParam;
@property (nonatomic, assign) BOOL isInquiryVideoHistoyFile;
@property (nonatomic, assign) BOOL isPlayBack;
@property (nonatomic, assign) BOOL isPlayBackNow;
@property (nonatomic, assign) BOOL isRealPlay;
@end

@implementation VideoTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _videoTestBgView.frame = CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64 - 49);
//    _videoTestBgView.center = CGPointMake(HB_WIDTH/2.,HB_HEIGHT/2.);
     _deviceListArray = [NSMutableArray arrayWithArray:[[AccountManager sharedManager]getdeviceListFromLocal]];
    _deviceListTableView.hidden = YES;
    _videoFileOfHistoryTableView.hidden = YES;
//    _playBackTImePickerBgView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    
    [self deviceRegister];
}
- (void)createUI {
    
    _viewPort = [[Viewport alloc] initWithFrame:CGRectMake(0, 0, _playView.frame.size.width, _playView.frame.size.height)];
    _viewPort.backgroundColor = [UIColor blackColor];
    [_playView addSubview:_viewPort];
    
    _videoViewIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _videoViewIndicatorView.center = CGPointMake(self.screenWidth / 2., (self.screenHeight - 64 - 49) / 2.);
    [_videoViewIndicatorView hidesWhenStopped];
    _videoViewIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:_videoViewIndicatorView];

    _deviceListArray = [NSMutableArray arrayWithCapacity:0];
    _videoFileOfHistoryArray = [NSMutableArray arrayWithCapacity:0];
    
    _fileCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _videoFileOfHistoryTableView.frame.size.width, 30)];
    _fileCountLabel.text = @"查询到录像文件数:个";
    _fileCountLabel.backgroundColor = [UIColor whiteColor];
    _fileCountLabel.textColor = [UIColor blackColor];
    _fileCountLabel.font = [UIFont systemFontOfSize:13];
    _videoFileOfHistoryTableView.tableHeaderView = _fileCountLabel;
    
    _videoFileOfHistoryTableView.delegate = self;
    _videoFileOfHistoryTableView.dataSource = self;
    _videoFileOfHistoryTableView.tag = VIDEOFIELOFHISTOYVIEWTAG;
    
    _deviceListTableView.delegate = self;
    _deviceListTableView.dataSource = self;
    _deviceListTableView.tag = VIDEODEVICELISTTABLEVIEWTAG;
    
    
    NSDate *maxDate = [NSDate date];
    _palyBackTimePicker.backgroundColor = [UIColor lightGrayColor];
    [_palyBackTimePicker setMaximumDate:maxDate];
    [_palyBackTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    _playBackTImePickerBgView.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == VIDEODEVICELISTTABLEVIEWTAG) {
        
        return _deviceListArray.count;
        
    } else {
        
        return _videoFileOfHistoryArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableCellIdentifier = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    
    if (tableView.tag == VIDEODEVICELISTTABLEVIEWTAG) {
        
        cell.backgroundColor = [UIColor grayColor];
        YdtDeviceParam *deviceParam = _deviceListArray[indexPath.row];
        cell.textLabel.text = deviceParam.deviceSn;
        
    } else {
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = _videoFileOfHistoryArray[indexPath.row];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == VIDEODEVICELISTTABLEVIEWTAG) {
        
        if ([_deviceLoginButton.titleLabel.text  isEqualToString:@"注销登录"]) {
            
            [self showAlertViewWithString:@"请先注销当前设备"];
            
        } else {
            
            _chooseDeviceParam = _deviceListArray[indexPath.row];
            _currentDevice = [[Device alloc] init];
            _currentDevice.serialNO = _chooseDeviceParam.deviceSn;
            _currentDevice.userName = _chooseDeviceParam.deviceUser;
            _currentDevice.deviceID = _chooseDeviceParam.deviceId;
            _currentDevice.domain = _chooseDeviceParam.deviceDomain;
            _currentDevice.domainPort = _chooseDeviceParam.deviceDomainPort;
            _currentDevice.vveyeID = _chooseDeviceParam.deviceVNIp;
            _currentDevice.password = _chooseDeviceParam.devicePassword;
            _currentDevice.vveyeRemotePort = _chooseDeviceParam.deviceVNPort;
            
            _deviceSerialLable.text = _chooseDeviceParam.deviceSn;
            
        }
        
        if (!_deviceListTableView.hidden) {
            
            _deviceListTableView.hidden = YES;
        }
        
    } else {
        
        
    }
}
- (IBAction)okButttonClick:(id)sender {
    
    if (!_playBackTImePickerBgView.hidden) {
        
        _playBackTImePickerBgView.hidden = YES;
    }
    if (_isInquiryVideoHistoyFile) {
        
        _isInquiryVideoHistoyFile = NO;
        
        //查询文件
//        NSCalendar * calendar=[NSCalendar currentCalendar];
//        NSDateComponents *compontents=[calendar components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:self.palyBackTimePicker.date];
        
        [self startAnimation];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_currentDevice findRecordFileByChannel:0 atDay:self.palyBackTimePicker.date completedHandle:^(NSError *error, NSArray *filesList) {
                
                if ([error code] == ErrorSuccess) {
                    
                    _videoFileOfHistoryArray = [NSMutableArray arrayWithArray:filesList];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopAnimation];
                        _videoFileOfHistoryTableView.hidden = NO;
                        _fileCountLabel.text = [NSString stringWithFormat:@"查询到录像文件个数:%ld",_videoFileOfHistoryArray.count];
                        [_videoFileOfHistoryTableView reloadData];
                    });
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopAnimation];
                        [self showAlertViewWithString:[error.userInfo
                                                       objectForKey:@"NSLocalizedDescription"]];
                    });
                    
                }
                
            }];

        });
    }
    if (_isPlayBackNow) {
        
            _isPlayBackNow = NO;
      
        if (_isRealPlay) {
            
            [_currentDevice stopRealplay];
            
        } else if(_isPlayBack){
            
            [_currentDevice stopPlayback];
        }
        
        NSCalendar * calendar=[NSCalendar currentCalendar];
        NSDateComponents *compontents=[calendar components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:self.palyBackTimePicker.date];
        NSDate *currentDate = [self convertDataByYear:[compontents year] month:[compontents month] day:[compontents day] hour:[compontents hour] min:[compontents hour] second:[compontents second]];
        [self startAnimation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_currentDevice playbackByChannel:0 andView:_viewPort from:currentDate completedCallback:^(NSError *error, int width, int height) {
               
                if ([error code] == ErrorSuccess) {
                       _isPlayBack = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopAnimation];
                           [self showAlertViewWithString:@"开启回放"];
                          _previewButton.titleLabel.text = @"停止";
                    });
                    
                } else {
                    [self stopAnimation];
                    [self showAlertViewWithString:[NSString stringWithFormat:@"%ld",[error code]]];
                }
            }];
        });
    }
}

-(NSDate *)convertDataByYear:(int)ye month:(int)mo day:(int)d hour:(int)h min:(int)m second:(int)s
{
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:ye];
    [comp setMonth:mo];
    [comp setDay:d];
    [comp setHour: h];
    [comp setMinute:m];
    [comp setSecond:s];
    NSDate *date = [myCal dateFromComponents:comp];
    return date;
    
}
- (IBAction)cancelButtonClick:(id)sender {
    
    if (!_playBackTImePickerBgView.hidden) {
        
        _playBackTImePickerBgView.hidden = YES;
    }
    
    if (_isInquiryVideoHistoyFile) {
        
        _isInquiryVideoHistoyFile = NO;
    }
    if (_isPlayBackNow) {
        
        _isPlayBackNow = NO;
    }
}
- (IBAction)chooseDeviceClick:(id)sender {
    
    if (_deviceListTableView.hidden) {
        
        _deviceListTableView.hidden = NO;
        
    } else {
        _deviceListTableView.hidden = YES;
    }
}

- (IBAction)loginDeviceClick:(id)sender {
    
    if ([_deviceSerialLable.text  isEqualToString:@"设备序列号"]) {
        
        [self showAlertViewWithString:@"请选择设备"];
        
    } else {
    
        if (_currentDevice.isLogin && [_deviceLoginButton.titleLabel.text isEqualToString:@"注销登录"]) {
            
            [_currentDevice logout];
            _previewButton.titleLabel.text = @"预览";
            
        } else {
        
        [self startAnimation];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_currentDevice loginWithBlick:^(BOOL loginStatus) {
                
                if (loginStatus) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopAnimation];
                        _deviceLoginButton.titleLabel.text = @"注销登录";
                        [self showAlertViewWithString:@"登录成功"];
                        
                    });
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopAnimation];
                        [self showAlertViewWithString:@"登录失败"];
                        
                    });
                }
            }];
        });
    }
  }
}

- (void)deviceRegister
{
    [self startAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_currentDevice loginWithBlick:^(BOOL loginStatus) {
            
            if (loginStatus) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self stopAnimation];
                    _deviceLoginButton.titleLabel.text = @"注销登录";
                    //[self showAlertViewWithString:@"登录成功"];
                    [self playVideo];
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self stopAnimation];
                    [self showAlertViewWithString:@"登录失败"];
                    
                });
            }
        }];
    });
    
}

- (void)playVideo
{
    if (_currentDevice.deviceLoginType == smsLogin) {
        
        [_currentDevice smsRealplay:self.viewPort];
        
        
    } else {
        
        [self startAnimation];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_currentDevice realplay:self.viewPort completedHandle:^(NSError *error) {
                
                if ([error code] == ErrorSuccess) {
                    _isRealPlay = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopAnimation];
                        _previewButton.titleLabel.text = @"停止";
                    });
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopAnimation];
                        [self showAlertViewWithString:[error.userInfo
                                                       objectForKey:@"NSLocalizedDescription"]];
                    });
                }
            }];
        });
    }
}

- (IBAction)openPreviewClick:(id)sender {
    
    
    if ([_previewButton.titleLabel.text isEqualToString:@"停止"]) {
        
        if(_isRealPlay) {
            
           [_currentDevice stopRealplay];
            
        } else if (_isPlayBack) {
            
            [_currentDevice stopPlayback];
        }
       
        _previewButton.titleLabel.text = @"预览";
        
    } else {
        
    if ([self judgeDeviceStatus]) {
     
        if (_currentDevice.deviceLoginType == smsLogin) {
            
            [_currentDevice smsRealplay:self.viewPort];
            
            
        } else {
            
            [self startAnimation];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [_currentDevice realplay:self.viewPort completedHandle:^(NSError *error) {
                    
                    if ([error code] == ErrorSuccess) {
                        _isRealPlay = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                            [self stopAnimation];
                            _previewButton.titleLabel.text = @"停止";
                        });
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            [self stopAnimation];
                            [self showAlertViewWithString:[error.userInfo
                                                           objectForKey:@"NSLocalizedDescription"]];
                        });
                    }
                }];
            });
        }
        
    } else {
        
        [self showAlertViewWithString:@"请登录设备"];
    }
    
    }
}

- (IBAction)queryHistoryVideoFileClick:(id)sender {
    
    if ([self judgeDeviceStatus]) {
        
        _isInquiryVideoHistoyFile = YES;
        [_palyBackTimePicker setDatePickerMode:UIDatePickerModeDate];
        _playBackTImePickerBgView.hidden = NO;
        
    } else {
        
       [self showAlertViewWithString:@"请登录设备"];
    }
  
    
}

- (IBAction)openPlayBackVideoClick:(id)sender {
   
    if ([self judgeDeviceStatus]) {
        
        _isPlayBackNow = YES;
        [_palyBackTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        _playBackTImePickerBgView.hidden = NO;
        
    } else {
        
        [self showAlertViewWithString:@"请登录设备"];
    }
}

- (void)startAnimation {
    
    [_videoViewIndicatorView startAnimating];
    _videoTestBgView.userInteractionEnabled = NO;
}

- (void)stopAnimation {
    
    [_videoViewIndicatorView stopAnimating];
    _videoTestBgView.userInteractionEnabled = YES;
}

- (void)showAlertViewWithString:(NSString *)string {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [self performSelector:@selector(videoViewDismissAlertView:) withObject:alertView afterDelay:1.0];
}

- (void)videoViewDismissAlertView:(UIAlertView *)alertView {
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (BOOL)judgeDeviceStatus {
    
    if (![_deviceSerialLable.text isEqualToString:@"设备序列号"]) {
        
        if (_currentDevice.isLogin) {
            
            return YES;
            
        } else {
            
            return NO;
        }
        
    } else {
        
        return NO;
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [_currentDevice logout];
}

@end
