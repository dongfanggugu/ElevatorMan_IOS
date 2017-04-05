//
//  AroundController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/5.
//
//

#import <Foundation/Foundation.h>
#import "AroundController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HttpClient.h"
#import "CalloutAnnotationView.h"
#import "CalloutMapAnnotation.h"


@interface AroundController()<BMKMapViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) CalloutAnnotationView *calloutView;

@property (strong, nonatomic) NSMutableArray *arrayProject;

@property (strong, nonatomic) NSArray *arrayLocation;

@end


@implementation AroundController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"附近维保"];
    [self initNavRightWithText:@"驻点切换"];
    [self initData];
    [self initView];
    [self getProjectInfo];
}

- (void)initData
{
    _arrayProject = [NSMutableArray array];
}

- (void)onClickNavRight
{
    [self getLocations];
}
- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
}

- (void)showAddress
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"驻点选择" message:nil delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:nil];
    for (NSInteger i = 0; i < _arrayLocation.count; i++)
    {
        NSString *title  = [_arrayLocation[i] objectForKey:@"address"];
        
        [alertView addButtonWithTitle:title];
    }
    
    
    [alertView show];
    
}

#pragma mark - Network Request


- (void)getLocations
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;
    
    __weak typeof(self) weakSelf = self;
    [[HttpClient sharedClient] view:self.view post:@"getPropertyAddressList" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        weakSelf.arrayLocation = [responseObject objectForKey:@"body"];
        [self showAddress];
        
    }];
}

- (void)getProjectInfo
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[HttpClient sharedClient] view:self.view post:@"getAllCommunitysByProperty" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.arrayProject removeAllObjects];
        [weakSelf.arrayProject addObjectsFromArray:[responseObject objectForKey:@"body"]];
        [weakSelf showProjects];
    }];
}

- (void)showProjects
{
    for (NSInteger i = 0; i < _arrayProject.count; i++)
    {
        CGFloat lat = [[_arrayProject[i] objectForKey:@"lat"] floatValue];
        CGFloat lng = [[_arrayProject[i] objectForKey:@"lng"] floatValue];
        CalloutMapAnnotation *marker = [[CalloutMapAnnotation alloc] init];
        marker.latitude = lat;
        marker.longitude = lng;
        marker.info = _arrayProject[i];
        [_mapView addAnnotation:marker];
    }
    
    [self getLocations];
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotation *ann = (CalloutMapAnnotation *)annotation;
        CalloutAnnotationView *calloutView = (CalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        if (nil == calloutView)
        {
            calloutView = [[CalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
        }
        
        calloutView.info = ann.info;
        
        __weak typeof(self) weakSelf = self;
        
        return calloutView;
    }
    
    return nil;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
        CalloutAnnotationView *calloutView = (CalloutAnnotationView *)view;
    
        if (_calloutView == calloutView)
        {
            return;
        }
    
        if (nil == _calloutView)
        {
            _calloutView = calloutView;
            [_calloutView showInfoWindow];
        }
        else
        {
            [_calloutView hideInfoWindow];
            _calloutView = calloutView;
            [_calloutView showInfoWindow];
        }
    
    
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if (nil == _calloutView)
    {
        return;
    }

    _calloutView.alarmInfoView.hidden = YES;
    _calloutView = nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (nil == _calloutView)
    {
        return;
    }
    
    [_calloutView hideInfoWindow];
    _calloutView = nil;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index:%ld", buttonIndex);
    if (0 == buttonIndex)
    {
        return;
    }
    CLLocationCoordinate2D coor;
    coor.latitude = [[_arrayLocation[buttonIndex - 1] objectForKey:@"lat"] floatValue];
    coor.longitude = [[_arrayLocation[buttonIndex - 1] objectForKey:@"lng"] floatValue];
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    [_mapView addAnnotation:marker];
    [_mapView showAnnotations:[NSArray arrayWithObjects:marker, nil] animated:YES];
    
    //[self getProjectInfo];
}

@end
