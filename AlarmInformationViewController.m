//
//  AlarmInformationViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "AlarmInformationViewController.h"
#import "AlarmInformationTableViewCell.h"
#define ALARMINFORMATIONTABLEVIEWTAG 100
#define DEVICELISTTABLEVIEWTAG 200
@interface AlarmInformationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *alarmBgView;
@property (strong, nonatomic) IBOutlet UITableView *deviceListTableView;
@property (strong, nonatomic) IBOutlet UIButton *chooseDeviceButton;
@property (strong, nonatomic) IBOutlet UITableView *alarmInformationListView;
@property (strong, nonatomic) IBOutlet UILabel *deviceSerialLabel;
@property (strong, nonatomic) NSMutableArray *alarmInformationArray;
@property (strong, nonatomic) NSMutableArray *deviceListArray;
@property (nonatomic, strong) YdtDeviceParam *selectDeviceParam;
@property (strong, nonatomic) UIActivityIndicatorView *alarmInfomationViewIndicatorView;
@end

@implementation AlarmInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configData];
    // Do any additional setup after loading the view from its nib.
}

- (void)configData {
    
    _alarmInfomationViewIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _alarmInfomationViewIndicatorView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    [_alarmInfomationViewIndicatorView hidesWhenStopped];
    _alarmInfomationViewIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:_alarmInfomationViewIndicatorView];
    
    _alarmInformationArray = [NSMutableArray arrayWithCapacity:0];
    _deviceListArray = [NSMutableArray arrayWithCapacity:0];
    _alarmInformationListView.delegate = self;
    _alarmInformationListView.dataSource = self;
    _alarmInformationListView.tag = ALARMINFORMATIONTABLEVIEWTAG;
    _deviceListTableView.delegate = self;
    _deviceListTableView.dataSource = self;
    _deviceListTableView.tag = DEVICELISTTABLEVIEWTAG;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _deviceListTableView.hidden = YES;
  _deviceListArray = [NSMutableArray arrayWithArray:[[AccountManager sharedManager] getdeviceListFromLocal]];
    _alarmBgView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == ALARMINFORMATIONTABLEVIEWTAG) {
        
        return _alarmInformationArray.count;
        
    } else {
        
        return _deviceListArray.count;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == ALARMINFORMATIONTABLEVIEWTAG) {
        YdtAlarmParam *alarmParam = _alarmInformationArray[indexPath.row];
        NSString *alarmInforOfIndex = alarmParam.alarmJson;
        CGSize  alarmInfoSize =[alarmInforOfIndex boundingRectWithSize:CGSizeMake(320,1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        CGFloat cellHeight = alarmInfoSize.height;
        return cellHeight+10;
    } else {
        
        return 30;
    }

    return 10;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == ALARMINFORMATIONTABLEVIEWTAG) {
        YdtAlarmParam *alarmParam = _alarmInformationArray[indexPath.row];
        NSString *alarmInforOfIndex = alarmParam.alarmJson;
        static NSString *alarmInfoCell = @"alarmInfoCell";
        AlarmInformationTableViewCell *alarmCell = [tableView dequeueReusableCellWithIdentifier:alarmInfoCell];
        if (alarmCell  == nil) {
            
            alarmCell = [[AlarmInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:alarmInfoCell];
        }
        [alarmCell alarmLabelNewHeghtWithContent:alarmInforOfIndex];
        return alarmCell;
        
    } else {
        
        static NSString *deviceidentifierCell = @"deviceCell";
        UITableViewCell *deviceCell = [tableView dequeueReusableCellWithIdentifier:deviceidentifierCell];
        if (deviceCell  == nil) {
            
            deviceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deviceidentifierCell];
            deviceCell.backgroundColor = [UIColor grayColor];
            deviceCell.textLabel.font = [UIFont systemFontOfSize:13];
        }
        YdtDeviceParam *deviceParam = _deviceListArray[indexPath.row];
        deviceCell.textLabel.text = deviceParam.deviceSn;
        return deviceCell;
    }
 
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == ALARMINFORMATIONTABLEVIEWTAG) {
        
    } else {
        
        if (!_deviceListTableView.hidden) {
            
            _deviceListTableView.hidden = YES;
        }
        _selectDeviceParam = _deviceListArray[indexPath.row];
        _deviceSerialLabel.text = _selectDeviceParam.deviceSn;
        
    }
}
- (IBAction)bindingClick:(id)sender {
    
    [self startAnimation];
    [[AccountManager sharedManager].ydtNetSdk bindDeviceAlarmWithDeviceSn:_deviceSerialLabel.text devicePassword:_selectDeviceParam.devicePassword shareType:0 bindFlag:1 completionHandler:^(int result) {
        
        if (result == YdtErrorSuccess) {
         
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopAnimation];
                [self showAlertViewWithString:@"绑定成功"];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopAnimation];
                [self showAlertViewWithString:[NSString stringWithFormat:@"%d",result]];
            });
        }
    }];
}
- (IBAction)getMoreAlarmInformationClick:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *beginTime = [NSDate dateWithTimeIntervalSinceNow:-3*24*60*60];
    NSDate *endTime = [NSDate date];
    
    // 获取设备从最后报警报警时间至现在的报警数据
    [self startAnimation];
    [[AccountManager sharedManager].ydtNetSdk getMultiAlarmInfoWithDeviceSn:_deviceSerialLabel.text beginTime:[beginTime timeIntervalSince1970] endTime:[endTime timeIntervalSince1970]startIndex:0 count:100000 competionHander:^(YdtAlarmInfo *alarmInfo) {
        
        if (alarmInfo.errorCode == 0) {
            _alarmInformationArray = [NSMutableArray arrayWithArray:alarmInfo.alarmArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopAnimation];
                [self showAlertViewWithString:@"获取报警信息成功"];
                [_alarmInformationListView reloadData];
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self stopAnimation];
                [self showAlertViewWithString:@"获取报警信息失败"];
                
            });
            
        }
    }];
}
- (IBAction)chooseDeviceButtonClick:(id)sender {
    if (_deviceListTableView.hidden) {
        
        _deviceListTableView.hidden = NO;
    } else {
        _deviceListTableView.hidden = YES;
    }
}

- (IBAction)unBindingClick:(id)sender {

    [self startAnimation];
       [[AccountManager sharedManager].ydtNetSdk bindDeviceAlarmWithDeviceSn:_deviceSerialLabel.text devicePassword:_selectDeviceParam.devicePassword shareType:0 bindFlag:0 completionHandler:^(int result) {
        
        if (result == YdtErrorSuccess) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopAnimation];
                [self showAlertViewWithString:@"解绑成功"];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopAnimation];
                [self showAlertViewWithString:[NSString stringWithFormat:@"%d",result]];
            });
        }
    }];
}

- (void)startAnimation {
    
    [_alarmInfomationViewIndicatorView startAnimating];
    _alarmBgView.userInteractionEnabled = NO;
}
- (void)stopAnimation {
    
    [_alarmInfomationViewIndicatorView stopAnimating];
    _alarmBgView.userInteractionEnabled = YES;
}
- (void)showAlertViewWithString:(NSString *)string {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [self performSelector:@selector(alarmInformationViewDismissAlertView:) withObject:alertView afterDelay:1.0];
}
- (void)alarmInformationViewDismissAlertView:(UIAlertView *)alertView {
    
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
