//
//  MaintInfoController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import "MaintInfoController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "MaintInfoView.h"
#import "MaintExceptionController.h"
#import "MaintSubmitController.h"
#import "MaintResultShowController.h"
#import "EvaluateController.h"

@interface MaintInfoController () <MaintInfoViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) MaintInfoView *infoView;

//0待确认 1已确认 2已出发 3已到达 4已完成 5已评价
@property (assign, nonatomic) NSInteger state;

@end

@implementation MaintInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保任务单"];
    [self initView];
}

- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    [self.view addSubview:_mapView];

    _infoView = [MaintInfoView viewFromNib];

    _infoView.delegate = self;
    
    if (_orderInfo)
    {
        _infoView.lbAddress.text = _orderInfo[@"villaInfo"][@"cellName"];
        
        NSString *name = _orderInfo[@"villaInfo"][@"contacts"];
        
        if (0 == name.length)
        {
            name = _orderInfo[@"ownerInfo"][@"name"];
        }

        NSString *tel = _orderInfo[@"villaInfo"][@"contactsTel"];

        if (0 == tel.length)
        {
            tel = _orderInfo[@"ownerInfo"][@"tel"];
        }
        
        _infoView.lbLinkInfo.text = [NSString stringWithFormat:@"%@/%@", name, tel];


        _infoView.lbBrand.text = _orderInfo[@"villaInfo"][@"brand"];
        _infoView.lbLoad.text = [NSString stringWithFormat:@"%ldkg", [_orderInfo[@"villaInfo"][@"weight"] integerValue]];
        _infoView.lbLayer.text = [NSString stringWithFormat:@"%ld层", [_orderInfo[@"villaInfo"][@"layerAmount"] integerValue]];

        _infoView.lbPlan.text = [Utils today:@"yyyy-MM-dd HH:mm"];
    }

    if (_maintInfo)
    {
        _infoView.lbAddress.text = _maintInfo[@"maintOrderInfo"][@"villaInfo"][@"cellName"];

        NSString *name = _maintInfo[@"maintOrderInfo"][@"villaInfo"][@"contacts"];

        if (0 == name.length)
        {
            name = _maintInfo[@"maintOrderInfo"][@"smallOwnerInfo"][@"name"];
        }

        NSString *tel = _maintInfo[@"maintOrderInfo"][@"villaInfo"][@"contactsTel"];

        if (0 == tel.length)
        {
            tel = _maintInfo[@"maintOrderInfo"][@"smallOwnerInfo"][@"tel"];
        }

        _infoView.lbLinkInfo.text = [NSString stringWithFormat:@"%@/%@", name, tel];


        _infoView.lbBrand.text = _maintInfo[@"maintOrderInfo"][@"villaInfo"][@"brand"];
        _infoView.lbLoad.text = [NSString stringWithFormat:@"%ldkg", [_maintInfo[@"maintOrderInfo"][@"villaInfo"][@"weight"] integerValue]];
        _infoView.lbLayer.text = [NSString stringWithFormat:@"%ld层", [_maintInfo[@"maintOrderInfo"][@"villaInfo"][@"layerAmount"] integerValue]];

        _infoView.lbPlan.text = _maintInfo[@"planTime"];
    }



    CGRect frame = CGRectMake(0, self.screenHeight - [MaintInfoView basicInfoHeight], self.screenWidth, [MaintInfoView viewHeight]);


    _infoView.frame = frame;

    [self.view addSubview:_infoView];

    if (MaintTaskMode_Show == _mode)
    {
        _infoView.btnPlan.hidden = YES;
        _infoView.btnException.hidden = YES;
        _infoView.btnMake.hidden = YES;
        _infoView.btnStart.hidden = YES;
    }
    else
    {
        switch (self.state)
        {
            case 0:
                [self state0];
                break;

            case 1:
                [self state1];
                break;

            case 2:
                [self state2];
                break;

            case 3:
                [self state3];
                break;

            case 4:
                [self state4];
                break;

            case 5:
                [self state5];
                break;

            default:
                break;
        }
    }
}

- (NSInteger)state
{
    if (!_maintInfo)
    {
        return 0;
    }

    return [_maintInfo[@"state"] integerValue];
}


/**
 待确认
 */
- (void)state0
{
    _infoView.btnStart.hidden = YES;

    _infoView.btnException.hidden = YES;

    _infoView.btnMake.hidden = NO;
}

/**
 已确认
 **/
- (void)state1
{
    _infoView.btnPlan.hidden = YES;

    _infoView.btnStart.hidden = NO;

    _infoView.btnException.hidden = NO;

    _infoView.btnMake.hidden = YES;
}

/**
 已出发
 **/
- (void)state2
{
    _infoView.btnPlan.hidden = YES;

    _infoView.btnStart.hidden = YES;

    _infoView.btnException.hidden = YES;

    _infoView.btnMake.hidden = NO;

    [_infoView.btnMake setTitle:@"到达" forState:UIControlStateNormal];

}

/**
 已到达
 **/
- (void)state3
{
    _infoView.btnPlan.hidden = YES;

    _infoView.btnStart.hidden = YES;

    _infoView.btnException.hidden = YES;

    _infoView.btnMake.hidden = NO;

    [_infoView.btnMake setTitle:@"维保完成" forState:UIControlStateNormal];

}

/**
 已完成
 **/
- (void)state4
{
    _infoView.btnPlan.hidden = YES;

    _infoView.btnStart.hidden = YES;

    _infoView.btnException.hidden = YES;

    _infoView.btnMake.hidden = NO;

    [_infoView.btnMake setTitle:@"维保结果" forState:UIControlStateNormal];

}

/**
 已评价
 **/
- (void)state5
{
    _infoView.btnPlan.hidden = YES;

    _infoView.btnStart.hidden = NO;

    _infoView.btnException.hidden = NO;

    _infoView.btnMake.hidden = YES;

    [_infoView.btnStart setTitle:@"评价" forState:UIControlStateNormal];
    [_infoView.btnException setTitle:@"维保结果" forState:UIControlStateNormal];

}

#pragma mark - MaintInfoViewDelegate

- (void)onClickStretch
{
    CGFloat y = _infoView.frame.origin.y;

    CGFloat initY = self.screenHeight - [MaintInfoView basicInfoHeight];

    if (y < initY)
    {

        CGRect frame = CGRectMake(0, self.screenHeight - [MaintInfoView basicInfoHeight], self.screenWidth, [MaintInfoView viewHeight]);

        _infoView.frame = frame;

        [_infoView.btnStretch setImage:[UIImage imageNamed:@"icon_maint_up.png"] forState:UIControlStateNormal];
    }
    else
    {
        CGRect frame = CGRectMake(0, self.screenHeight - [MaintInfoView viewHeight], self.screenWidth, [MaintInfoView viewHeight]);

        _infoView.frame = frame;

        [_infoView.btnStretch setImage:[UIImage imageNamed:@"icon_maint_down.png"] forState:UIControlStateNormal];
    }
}

- (void)onClickStart
{
    if (1 == self.state)
    {  //已经确认状态
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定开始出发,前往别墅进行维保?" preferredStyle:UIAlertControllerStyleAlert];

        __weak typeof(self) weakSelf = self;
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [weakSelf start];
        }]];

        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

        }]];

        [self presentViewController:controller animated:YES completion:^{

        }];

    }
    else if (5 == self.state)
    {   //已经评价状态
        NSLog(@"查看评价");

        [self evaluate];
    }
}

- (void)onClickException
{
    if (1 == self.state)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认无法出发完成当前维保任务?" preferredStyle:UIAlertControllerStyleAlert];

        __weak typeof(self) weakSelf = self;
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [weakSelf exception];
        }]];

        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

        }]];

        [self presentViewController:controller animated:YES completion:^{

        }];

    }
    else if (5 == self.state)
    {   //已经评价
        NSLog(@"查看维保结果");
        [self maintResult];

    }
}

- (void)onClickMake
{
    switch (self.state)
    {
        case 0:
            [self makePlan];
            break;

        case 2:
            [self arrive];
            break;

        case 3:
            [self completePlan];
            break;

        case 4:
            [self maintResult];
            break;

        default:
            break;
    }
}

- (void)evaluate
{
    EvaluateController *controller = [[EvaluateController alloc] init];
    controller.content = _maintInfo[@"evaluateContent"];
    controller.star = [_maintInfo[@"evaluateResult"] integerValue];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 完成维保计划
 */
- (void)completePlan
{
    MaintSubmitController *controller = [[MaintSubmitController alloc] init];

    controller.maintInfo = _maintInfo;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    //[self state4];
}


/**
 查看维保结果
 */
- (void)maintResult
{

    MaintResultShowController *controller = [[MaintResultShowController alloc] init];

    controller.content = _maintInfo[@"maintUserFeedback"];

    controller.urlBefore = _maintInfo[@"beforeImg"];

    controller.urlAfter = _maintInfo[@"afterImg"];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 制定维保计划
 */
- (void)makePlan
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"maintOrderId"] = _orderInfo[@"id"];
    params[@"planTime"] = _infoView.lbPlan.text;

    [[HttpClient sharedClient] post:@"addMaintOrderProcess" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUDClass showHUDWithLabel:@"维保计划制定成功"];
        [self state1];
    }];
}


/**
 到达
 */
- (void)arrive
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"maintOrderProcessId"] = _maintInfo[@"id"];

    [[HttpClient sharedClient] post:@"editMaintOrderProcessWorkerArrive" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self.navigationController popViewControllerAnimated:YES];
    }];
}


/**
 出发
 */
- (void)start
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"maintOrderProcessId"] = _maintInfo[@"id"];

    [[HttpClient sharedClient] post:@"editMaintOrderProcessWorkerSetOut" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self state2];
    }];
}


/**
 无法出发
 */
- (void)exception
{
    MaintExceptionController *controller = [[MaintExceptionController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

@end
