//
//  AddressLocationController.m
//  owner
//
//  Created by 长浩 张 on 2017/4/19.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "AddressLocationController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "KeyValueCell.h"
#import "ContentCell.h"
#import "Location.h"

@interface AddressLocationController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,
        BMKPoiSearchDelegate, BMKMapViewDelegate, BMKGeoCodeSearchDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) location *location;

@property (weak, nonatomic) BMKPoiInfo *bmkPointInfo;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UITextField *inputText;

@end

@implementation AddressLocationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"地址选择"];
    [self initNavRightWithText:@"确定"];
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onClickNavRight
{
    NSString *searchText = _searchBar.text;

    if (0 == searchText.length)
    {
        [self showMsgAlert:@"请先选择地址的附近位置"];
        return;
    }

    NSString *input = _inputText.text;

    if (0 == input.length)
    {
        [self showMsgAlert:@"请填写具体地址楼号房间号"];
        return;
    }

    NSString *address = [NSString stringWithFormat:@"%@%@", searchText, input];
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseAddress:Lat:lng:)])
    {
        [_delegate onChooseAddress:address Lat:_mapView.centerCoordinate.latitude lng:_mapView.centerCoordinate.longitude];
    }

    if (_delegate && [_delegate respondsToSelector:@selector(onChooseCell:address:Lat:lng:)])
    {
        [_delegate onChooseCell:searchText address:input Lat:_mapView.centerCoordinate.latitude lng:_mapView.centerCoordinate.longitude];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 40, 40)];
    lb.text = @"小区";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:13];

    [self.view addSubview:lb];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 63, self.screenWidth - 40, 40)];

    _searchBar.barTintColor = [UIColor whiteColor];

    _searchBar.backgroundColor = [UIColor whiteColor];

    _searchBar.delegate = self;

    [self.view addSubview:_searchBar];

    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 104, self.screenWidth, self.screenHeight - 104)];

    _mapView.delegate = self;

    _mapView.zoomLevel = 15;

    [self.view addSubview:_mapView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationComplete:) name:@"userLocationUpdate" object:nil];

    [self.location startLocationService];

    //添加具体地址输入框
    _inputText = [[UITextField alloc] initWithFrame:CGRectMake(0, 104, self.screenWidth, 30)];
    _inputText.font = [UIFont systemFontOfSize:14];

    _inputText.placeholder = @"请填写别墅具体楼号房间号";

    _inputText.leftViewMode = UITextFieldViewModeAlways;

    _inputText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];

    _inputText.rightViewMode = UITextFieldViewModeAlways;

    _inputText.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];

    _inputText.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:_inputText];

    //添加中心标记
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    imageView.image = [UIImage imageNamed:@"icon_location_pin"];

    imageView.center = _mapView.center;

    [self.view addSubview:imageView];

    //添加提示
    UILabel *lbTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];

    lbTip.text = @"可以拖动地图标记具体位置";

    lbTip.font = [UIFont systemFontOfSize:13];

    lbTip.textAlignment = NSTextAlignmentCenter;

    lbTip.center = CGPointMake(self.screenWidth / 2, 134 + 15);

    [self.view addSubview:lbTip];

    [self initTableView];
}

- (void)onLocationComplete:(NSNotification *)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLocationUpdate"object:nil];
    if (!notify.userInfo)
    {
        return;
    }

    BMKUserLocation *location = notify.userInfo[@"userLocation"];

    [self markOnMap:location.location.coordinate];
    [self codeSearchWithLat:location.location.coordinate];
}

- (void)codeSearchWithLat:(CLLocationCoordinate2D)coor
{
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc] init];
    search.delegate = self;

    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = coor;

    BOOL flag = [search reverseGeoCode:option];

    if (flag)
    {
        NSLog(@"反编码启动成功!");

    }
    else
    {
        NSLog(@"反编码启动失败");

    }

}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        _searchBar.text = result.address;

    }
    else
    {
        NSLog(@"反编码 error code:%u", error);
    }
}

- (void)markOnMap:(CLLocationCoordinate2D)coor;
{
    [_mapView setCenterCoordinate:coor animated:YES];
    [_mapView removeAnnotations:_mapView.annotations];

//    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
//    annotation.coordinate = coor;
//    [_mapView addAnnotation:annotation];
//    [_mapView showAnnotations:[NSArray arrayWithObjects:annotation, nil] animated:YES];
}


- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, self.screenWidth, self.screenHeight / 2)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];

    _tableView.hidden = YES;
}

- (void)initData
{
    _dataArray = [NSMutableArray array];
}

- (void)poiSearch:(NSString *)keyword
{
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];

    poiSearch.delegate = self;

    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
    option.city = @"北京";
    option.keyword = keyword;
    option.pageCapacity = 50;


    BOOL result = [poiSearch poiSearchInCity:option];
    if (!result)
    {
        [self showMsgAlert:@"查询失败,请稍后再试!"];
    }
}

#pragma mark -- BMKSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{

    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        [_dataArray removeAllObjects];

        [_dataArray addObjectsFromArray:poiResult.poiInfoList];

    }
    else
    {
        [_dataArray removeAllObjects];
    }

    [_tableView reloadData];
    _tableView.hidden = NO;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (0 == searchText.length)
    {
        _tableView.hidden = YES;
        return;
    }

    [self poiSearch:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContentCell identifier]];

    if (!cell)
    {
        cell = [ContentCell cellFromNib];
    }

    BMKPoiInfo *info = _dataArray[indexPath.row];

    cell.lbContent.text = info.name;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = _dataArray[indexPath.row];

    return [ContentCell cellHeight:info.name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableView.hidden = YES;

    _bmkPointInfo = _dataArray[indexPath.row];

    _searchBar.text = _bmkPointInfo.name;

    CLLocationCoordinate2D coor;

    coor.latitude = _bmkPointInfo.pt.latitude;
    coor.longitude = _bmkPointInfo.pt.longitude;

    [self markOnMap:coor];
}

@end
