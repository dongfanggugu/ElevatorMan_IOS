//
//  LocationViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/5.
//
//

#import <Foundation/Foundation.h>
#import "LocationViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HUDClass.h"
#import "AddressViewController.h"

#pragma mark -- AddressCell

@interface AddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@end

@implementation AddressCell


@end

#pragma mark -- LocationViewController

@interface LocationViewController () <BMKMapViewDelegate, BMKPoiSearchDelegate, UITableViewDelegate,
        UITableViewDataSource>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *tipLable;

@property (strong, nonatomic) BMKPoiSearch *poiSearch;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) BMKPointAnnotation *annotation;

@property (strong, nonatomic) MBProgressHUD *progress;

@property (strong, nonatomic) BMKPinAnnotationView *annotationView;
//@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"地址选择"];
    [self setTitleRight];

    _poiSearch = [[BMKPoiSearch alloc] init];

    _poiSearch.delegate = self;

    _mapView.delegate = self;

    [_mapView setZoomLevel:15];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    [self search];

}

/**
 *  设置标题栏右侧
 */
- (void)setTitleRight {
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnSubmit setImage:[UIImage imageNamed:@"icon_add_confirm"] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)search {
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.city = @"北京";
    option.keyword = _address;

    _progress = [HUDClass showLoadingHUD:self.view];

    BOOL result = [_poiSearch poiSearchInCity:option];
    if (!result) {
        [HUDClass hideLoadingHUD:_progress];
        _progress = nil;
        [HUDClass showHUDWithLabel:@"查询失败,请稍后再试!" view:self.view];
    }
}

#pragma mark -- BMKSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    [HUDClass hideLoadingHUD:_progress];
    _progress = nil;

    if (errorCode == BMK_SEARCH_NO_ERROR) {
        _dataArray = poiResult.poiInfoList;
        [_tableView reloadData];

        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self setSelection:0];
    } else {
        [HUDClass showHUDWithLabel:@"查找失败,请退出再次进入!" view:self.view];
    }
}

- (void)setSelection:(NSInteger)index {
    if (_tipLable.hidden) {
        _tipLable.hidden = NO;
    }

    if (nil == _annotation) {
        _annotation = [[BMKPointAnnotation alloc] init];
    }

    [_mapView removeAnnotation:_annotation];

    BMKPoiInfo *info = _dataArray[index];

    _annotation.coordinate = info.pt;
    [_mapView addAnnotation:_annotation];
    NSArray *array = [[NSArray alloc] initWithObjects:_annotation, nil];
    [_mapView showAnnotations:array animated:YES];
}

- (void)submit {
    if (nil == _annotationView) {
        [HUDClass showHUDWithLabel:@"请先选择你的地址!" view:self.view];
        return;
    }

    CLLocationCoordinate2D coor = _annotationView.annotation.coordinate;


    if (0 == _enterType) {
        NSInteger count = [self.navigationController.viewControllers count];

        AddressViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 2];

        controller.latView.hidden = NO;
        controller.lngView.hidden = NO;

        controller.latValueLabel.hidden = NO;
        controller.lngValueLabel.hidden = NO;

        controller.lngValueLabel.text = [NSString stringWithFormat:@"%lf", coor.longitude];
        controller.latValueLabel.text = [NSString stringWithFormat:@"%lf", coor.latitude];
    } else {
        if (_delegate) {
            [_delegate onChooseAddressLat:coor.latitude lng:coor.longitude];
        }
    }

    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address_cell"];

    BMKPoiInfo *info = _dataArray[indexPath.row];

    cell.addLabel.text = info.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelection:indexPath.row];

    /**
    if (_tipLable.hidden)
    {
        _tipLable.hidden = NO;
    }
    
    if (nil ==  _annotation)
    {
        _annotation = [[BMKPointAnnotation alloc] init];
    }
    
    [_mapView removeAnnotation:_annotation];
    
    BMKPoiInfo *info = _dataArray[indexPath.row];
    
    _annotation.coordinate = info.pt;
    [_mapView addAnnotation:_annotation];
    NSArray *array = [[NSArray alloc] initWithObjects:_annotation, nil];
    [_mapView showAnnotations:array animated:YES];
     
     **/

}

#pragma mark -- BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        _annotationView = (BMKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"marker"];

        if (nil == _annotationView) {
            _annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"marker"];
        }


        [_annotationView setBounds:CGRectMake(0, 0, 40, 40)];
        [_annotationView setBackgroundColor:[UIColor clearColor]];
        [_annotationView setDraggable:YES];
        return _annotationView;
    }

    return nil;
}

//- (BMK)

@end
