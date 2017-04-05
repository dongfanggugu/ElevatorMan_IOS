//
//  ProLocationController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/5.
//
//

#import <Foundation/Foundation.h>
#import "ProLocationController.h"
#import "AddressViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HttpClient.h"

#pragma mark - ProLocationCell

@interface ProLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end

@implementation ProLocationCell


@end

#pragma mark - ProLocationController

@interface ProLocationController()<UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *arrayAddress;

@end

@implementation ProLocationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"驻点"];
    [self initNavRightWithText:@"添加"];
    
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getLocations];
}

- (void)onClickNavRight
{
    AddressViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"address_controller"];
    controller.addType = TYPE_PRO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initData
{
    _arrayAddress = [NSMutableArray array];
}

- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)setSelectedIndex:(NSInteger)index
{
    NSDictionary *info = _arrayAddress[index];
    CGFloat lat = [[info objectForKey:@"lat"] floatValue];
    CGFloat lng = [[info objectForKey:@"lng"] floatValue];
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    [_mapView removeAnnotations:[_mapView annotations]];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coor;
    [_mapView addAnnotation:annotation];
    [_mapView showAnnotations:[NSArray arrayWithObjects:annotation, nil] animated:YES];
}

#pragma mark - Network Request

- (void)getLocations
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"branchId"] = [User sharedUser].branchId;
    
    __weak typeof(self) weakSelf = self;
    [[HttpClient sharedClient] view:self.view post:@"getPropertyAddressList" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.arrayAddress removeAllObjects];
        [weakSelf.arrayAddress addObjectsFromArray:[responseObject objectForKey:@"body"]];
        if (0 == weakSelf.arrayAddress.count)
        {
            _tableView.hidden = YES;
        }
        else
        {
            _tableView.hidden = NO;
            [_tableView reloadData];
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self setSelectedIndex:0];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayAddress.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pro_location_cell"];
    
    if (nil == cell)
    {
        cell = [[ProLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pro_location_cell"];
    }
    
    cell.lbAddress.text = [_arrayAddress[indexPath.row] objectForKey:@"address"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedIndex:indexPath.row];
}

#pragma mark -  BMKMapViewDelegate
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
