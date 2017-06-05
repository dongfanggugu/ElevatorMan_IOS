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
    
    CGRect frame = CGRectMake(0, self.screenHeight - [MaintInfoView basicInfoHeight], self.screenWidth, [MaintInfoView viewHeight]);
    
    
    _infoView.frame = frame;
    
    [self.view addSubview:_infoView];
}

- (NSInteger)state
{
    if (!_maintInfo) {
        return -1;
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
    _infoView.btnStart.hidden = NO;
    
    _infoView.btnException.hidden = NO;
    
    _infoView.btnMake.hidden = YES;
    
}

/**
 已出发
 **/
- (void)state2
{
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
    
    if (y < initY) {
        CGRect frame = CGRectMake(0, self.screenHeight - [MaintInfoView basicInfoHeight], self.screenWidth, [MaintInfoView viewHeight]);
        
        _infoView.frame = frame;
        
    } else {
        CGRect frame = CGRectMake(0, self.screenHeight - [MaintInfoView viewHeight], self.screenWidth, [MaintInfoView viewHeight]);
        
        
        _infoView.frame = frame;
    }
}

- (void)onClickStart
{
    if (1 == self.state) {  //已经确认状态
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定开始出发,前往别墅进行维保?" preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof (self) weakSelf = self;
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf start];
        }]];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:controller animated:YES completion:^{
            
        }];
        
    } else if (5 == self.state) {   //已经评价状态
        NSLog(@"查看评价");
        
        [self evaluate];
    }
}

- (void)onClickException
{
    if (1 == self.state) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认无法出发完成当前维保任务?" preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof (self) weakSelf = self;
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf exception];
        }]];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:controller animated:YES completion:^{
            
        }];
        
    } else if (5 == self.state) {   //已经评价
        NSLog(@"查看维保结果");
        [self maintResult];
        
    }
}

- (void)onClickMake
{
    switch (self.state) {
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
    NSLog(@"查看评价");
}

/**
 完成维保计划
 */
- (void)completePlan
{
    NSLog(@"完成维保计划");
    [self state4];
}


/**
 查看维保结果
 */
- (void)maintResult
{
    NSLog(@"查看维保结果");
}

/**
 制定维保计划
 */
- (void)makePlan
{
    NSLog(@"制定维保计划");
    [self state1];
}


/**
 到达
 */
- (void)arrive
{
    NSLog(@"到达");
    [self state3];
}


/**
 出发
 */
- (void)start
{
    NSLog(@"出发");
    [self state2];
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
