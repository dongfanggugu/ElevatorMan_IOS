//
//  MaintManagerController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "MaintManagerController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ComMaintTitleView.h"
#import "MaintLiftController.h"
#import "ListDialogData.h"
#import "MaintAnnotation.h"
#import "MaintAnnotationView.h"

@interface MaintManagerController () <BMKMapViewDelegate, ComMaintTitleViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *arrayBranch;

@property (strong, nonatomic) NSMutableArray *arrayWorker;

@property (strong, nonatomic) ComMaintTitleView *titleView;

@property (copy, nonatomic) NSString *branchId;

@property (copy, nonatomic) NSString *workerId;

@property (strong, nonatomic) NSMutableDictionary *dicMaint;

@property (strong, nonatomic) NSMutableDictionary *dicOverTime;

@property (strong, nonatomic) NSMutableDictionary *dicUnPlan;

@property (strong, nonatomic) NSMutableDictionary *dicFinished;

@property (strong, nonatomic) NSMutableDictionary *dicBeFinished;

@property (weak, nonatomic) MaintAnnotationView *curAnnView;

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation MaintManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"E维保"];
   // [self initNavRightWithText:@"维保历史"];
    [self initView];
    [self getBranches];
}

- (NSMutableDictionary *)dicOverTime
{
    if (!_dicOverTime)
    {
        _dicOverTime = [NSMutableDictionary dictionary];
    }

    return _dicOverTime;
}


- (NSMutableDictionary *)dicUnPlan
{
    if (!_dicUnPlan)
    {
        _dicUnPlan = [NSMutableDictionary dictionary];
    }

    return _dicUnPlan;
}

- (NSMutableDictionary *)dicBeFinished
{
    if (!_dicBeFinished)
    {
        _dicBeFinished = [NSMutableDictionary dictionary];
    }

    return _dicBeFinished;
}

- (NSMutableDictionary *)dicFinished
{
    if (!_dicFinished)
    {
        _dicFinished = [NSMutableDictionary dictionary];
    }

    return _dicFinished;
}

- (NSMutableArray *)arrayBranch
{
    if (!_arrayBranch)
    {
        _arrayBranch = [NSMutableArray array];
    }

    return _arrayBranch;
}

- (NSMutableArray *)arrayWorker
{
    if (!_arrayWorker)
    {
        _arrayWorker = [NSMutableArray array];
    }

    return _arrayWorker;
}

- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 10;
    
    [self.view addSubview:_mapView];
    
    //头部视图
    _titleView = [ComMaintTitleView viewFromNib];
    
    _titleView.frame = CGRectMake(0, 64, self.screenWidth, 75);
    
    _titleView.delegate = self;
    
    [self.view addSubview:_titleView];
}

- (void)getBranches
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;

    [[HttpClient sharedClient] post:@"getBranchsByBranchId" parameter:params success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self.arrayBranch removeAllObjects];
        [self.arrayBranch addObjectsFromArray:responseObject[@"body"]];
        [self initBranch];
        [self getWorkers:_branchId];
    }];
}

- (void)initBranch
{
    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *info in self.arrayBranch)
    {
        ListDialogData *data = [[ListDialogData alloc] initWithKey:info[@"id"] content:info[@"name"]];

        [array addObject:data];
    }

    _branchId = self.arrayBranch[0][@"id"];
    _titleView.arrayCompany = array;
}

- (void)getWorkers:(NSString *)branchId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = _branchId;

    [[HttpClient sharedClient] post:@"getWorkListByBranchId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.arrayWorker removeAllObjects];
        [self.arrayWorker addObjectsFromArray:responseObject[@"body"]];

        [self initWorker];
    }];
}
- (void)initWorker
{
    NSMutableArray *array = [NSMutableArray array];

    ListDialogData *whole = [[ListDialogData alloc] initWithKey:@"" content:@"全部"];
    [array addObject:whole];

    for (NSDictionary *info in self.arrayWorker)
    {
        ListDialogData *data = [[ListDialogData alloc] initWithKey:info[@"id"] content:info[@"name"]];

        [array addObject:data];
    }

    _workerId = @"";
    _titleView.arrayWorker = array;

    [self getMaintToday];
}

- (void)getMaintToday
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = _branchId;

    [[HttpClient sharedClient] post:@"getMaintListByBranchId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.dicMaint = responseObject[@"body"];
        [self filtMaint];
    }];

}

- (void)show
{
    switch (_currentIndex)
    {
        case 0:
            [self markOnMap:self.dicUnPlan];
            break;

        case 1:
            [self markOnMap:self.dicBeFinished];
            break;

        case 2:
            [self markOnMap:self.dicOverTime];
            break;

        case 3:
            [self markOnMap:self.dicFinished];
            break;
    }
}

- (void)overTime:(NSArray *)array
{
    [self.dicOverTime removeAllObjects];
    self.dicOverTime[@"count"] = [NSNumber numberWithInteger:array.count];
    for (NSDictionary *info in array)
    {
        NSString *comId = info[@"coummunityId"];

        NSArray *arrayKey = self.dicOverTime.allKeys;
        if ([arrayKey containsObject:comId])
        {
            [self.dicOverTime[comId] addObject:info];
        }
        else
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:info];

            self.dicOverTime[comId] = array;
        }
    }
}

- (void)unPlan:(NSArray *)array
{
    [self.dicUnPlan removeAllObjects];
    
    self.dicUnPlan[@"count"] = [NSNumber numberWithInteger:array.count];

    for (NSDictionary *info in array)
    {
        NSString *comId = info[@"coummunityId"];

        NSArray *arrayKey = self.dicUnPlan.allKeys;
        if ([arrayKey containsObject:comId])
        {
            [self.dicUnPlan[comId] addObject:info];
        }
        else
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:info];

            self.dicUnPlan[comId] = array;
        }
    }
}

- (void)beFinished:(NSArray *)arrayMaint
{
    [self.dicBeFinished removeAllObjects];
    
    self.dicBeFinished[@"count"] = [NSNumber numberWithInteger:arrayMaint.count];
    for (NSDictionary *info in arrayMaint)
    {
        NSString *comId = info[@"coummunityId"];

        NSArray *arrayKey = self.dicBeFinished.allKeys;
        if ([arrayKey containsObject:comId])
        {
            [self.dicBeFinished[comId] addObject:info];
        }
        else
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:info];

            self.dicBeFinished[comId] = array;
        }
    }
}

- (void)finished:(NSArray *)array
{
    [self.dicFinished removeAllObjects];
    
    self.dicFinished[@"count"] = [NSNumber numberWithInteger:array.count];
    for (NSDictionary *info in array)
    {
        NSString *comId = info[@"coummunityId"];

        NSArray *arrayKey = self.dicFinished.allKeys;
        if ([arrayKey containsObject:comId])
        {
            [self.dicFinished[comId] addObject:info];
        }
        else
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:info];

            self.dicFinished[comId] = array;
        }
    }
}


- (void)splitTodayMaint:(NSArray *)array
{
    NSMutableArray *finished = [NSMutableArray array];

    NSMutableArray *beFinished = [NSMutableArray array];

    for (NSDictionary *info in array)
    {
        NSString *maintTime = info[@"maintTime"];

        if (0 == maintTime.length)
        {
            [beFinished addObject:info];
        }
        else
        {
            [finished addObject:info];
        }
    }

    [self finished:finished];
    [self beFinished:beFinished];
}

- (void)markOnMap:(NSDictionary *)dicProject
{
    if (_curAnnView)
    {
        [_curAnnView hideInfoView];

        _curAnnView = nil;
    }
    [_mapView removeAnnotations:[_mapView annotations]];

    NSEnumerator *enumerator = [dicProject keyEnumerator];

    NSString *key;

    while ((key = [enumerator nextObject]))
    {
        if ([key isEqualToString:@"count"])
        {
            continue;
        }
        NSDictionary *lift = dicProject[key][0];


        CLLocationCoordinate2D coor;
        coor.latitude = [lift[@"lat"] floatValue];
        coor.longitude = [lift[@"lng"] floatValue];

        MaintAnnotation *annotation = [[MaintAnnotation alloc] initWithLat:[lift[@"lat"] floatValue] andLng:[lift[@"lng"] floatValue]];
        annotation.arrayInfo = dicProject[key];

        [_mapView addAnnotation:annotation];
    }
}

- (void)showTitleCount
{
    NSString *titleUnPlan = [NSString stringWithFormat:@"未制定(%ld)", [self.dicUnPlan[@"count"] integerValue]];
    [_titleView.btn1 setTitle:titleUnPlan forState:UIControlStateNormal];

    NSString *titleBefinished = [NSString stringWithFormat:@"待维保(%ld)", [self.dicBeFinished[@"count"] integerValue]];
    [_titleView.btn2 setTitle:titleBefinished forState:UIControlStateNormal];

    NSString *titleOverTime = [NSString stringWithFormat:@"超期(%ld)", [self.dicOverTime[@"count"] integerValue]];
    [_titleView.btn3 setTitle:titleOverTime forState:UIControlStateNormal];

    NSString *titleFinished = [NSString stringWithFormat:@"已完成(%ld)", [self.dicFinished[@"count"] integerValue]];
    [_titleView.btn4 setTitle:titleFinished forState:UIControlStateNormal];
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MaintAnnotation class]])
    {
        MaintAnnotation *ann = (MaintAnnotation *)annotation;

        MaintAnnotationView *annView = (MaintAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[MaintAnnotationView identifier]];

        if (!annView)
        {
            annView = [[MaintAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:[MaintAnnotationView identifier]];
        }


        __weak typeof(self) weakSelf = self;

        [annView setOnClickDetail:^(NSArray *arrayInfo) {
            MaintLiftController *controller = [[MaintLiftController alloc] init];

            if (weakSelf.curAnnView)
            {
                [weakSelf.curAnnView hideInfoView];
                weakSelf.curAnnView = nil;
            }

            controller.arrayMaint = arrayInfo;

            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        annView.arrayInfo = ann.arrayInfo;

        return annView;
    }

    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    MaintAnnotationView *annView = (MaintAnnotationView *)view;

    if (_curAnnView)
    {
        if (_curAnnView == annView)
        {
            return;
        }

        [_curAnnView hideInfoView];

        [annView showInfoView];

        _curAnnView = annView;
    }
    else
    {
        [annView showInfoView];
        _curAnnView = annView;
    }

}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (_curAnnView)
    {
        [_curAnnView hideInfoView];
        _curAnnView = nil;
    }
}

- (void)filtMaint
{
    NSMutableDictionary *dic = nil;

    if (0 == _workerId.length)
    {
        dic = self.dicMaint;
    }
    else
    {
        dic = [NSMutableDictionary dictionary];

        NSArray *overTime = [self filtMaintArray:self.dicMaint[@"overTime"]];
        NSArray *today = [self filtMaintArray: self.dicMaint[@"today"]];
        NSArray *unPlan = [self filtMaintArray:self.dicMaint[@"unPlan"]];

        dic[@"overTime"] = overTime;
        dic[@"today"] = today;
        dic[@"unPlan"] = unPlan;
    }

    [self overTime:dic[@"overtime"]];

    [self unPlan:dic[@"unPlan"]];

    [self splitTodayMaint:dic[@"today"]];

    [self showTitleCount];

    [self show];

}

- (NSMutableArray *)filtMaintArray:(NSArray *)arrayMaint;
{

    NSMutableArray *array = [NSMutableArray array];

    if (!arrayMaint || 0 == arrayMaint.count)
    {
        return array;
    }

    for (NSDictionary *maint in arrayMaint)
    {
        NSString *userId = maint[@"userId"];

        if ([userId isEqualToString:_workerId])
        {
            [array addObject:maint];
        }
    }

    return array;
}

#pragma mark - AlarmTitleViewDelegate

- (void)onChooseWorker:(NSString *)workerId name:(NSString *)name
{
    self.workerId = workerId;
    [self filtMaint];
}

- (void)onChooseCompany:(NSString *)comId name:(NSString *)name
{
    _branchId = comId;

    [self getWorkers:_branchId];
}

- (void)onClickBtn1
{
    _currentIndex = 0;
    [self markOnMap:self.dicUnPlan];
}

- (void)onClickBtn2
{
    _currentIndex = 1;
    [self markOnMap:self.dicBeFinished];
}

- (void)onClickBtn3
{
    _currentIndex = 2;
    [self markOnMap:self.dicOverTime];
}

- (void)onClickBtn4
{
    _currentIndex = 3;
    [self markOnMap:self.dicFinished];
}

@end
