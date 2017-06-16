//
//  ReportAlarmViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "ReportAlarmViewController.h"
#import "HttpClient.h"


@interface ReportAlarmViewController () <UITextFieldDelegate, UIAlertViewDelegate>

//@property (weak, nonatomic) IBOutlet UITextField *textfield_detail;

@property (nonatomic) BOOL isInjured;

@property (weak, nonatomic) IBOutlet UILabel *AlarmDetail;

@property (weak, nonatomic) IBOutlet UITextField *textFiled_remark;

@end

@implementation ReportAlarmViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    self.title = @"一键报警";
    self.isInjured = NO;

    //显示报警位置
    [self showAlarmDetail];

}


- (void)showAlarmDetail
{
    self.AlarmDetail.text = [NSString stringWithFormat:@"%@%@号楼%@号电梯", self.projectName, self.buildingNum, [self.liftDic objectForKey:@"number"]];
}

#pragma mark - IBAction

- (IBAction)reportAlarm:(id)sender
{

    //设置参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[self.liftDic objectForKey:@"id"] forKey:@"liftId"];
    [dic setObject:[NSString stringWithFormat:@"%@", [NSNumber numberWithBool:self.isInjured]] forKey:@"isInjure"];
    [dic setObject:self.textFiled_remark.text forKey:@"remark"];


    __weak ReportAlarmViewController *weakself = self;
    //请求
    [[HttpClient sharedClient] post:@"alarm" parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                //报警完成后给予提示
                                UIAlertView *alert;
                                alert = [[UIAlertView alloc] initWithTitle:@"新消息" message:@"报警成功，系统正在指派最近的维修工前往维修，请耐心等待！如需跟踪报警进度，请进入‘当前报警’查看" delegate:weakself cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                                [alert show];

                            }];


}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)choiceInJured:(id)sender
{

    self.isInjured = !self.isInjured;

    UIButton *button = (UIButton *) sender;

    if (self.isInjured)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_choice.png"] forState:UIControlStateNormal];
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_noChoice.png"] forState:UIControlStateNormal];
    }
}


#pragma mark - UITextFiledDelegate

//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
