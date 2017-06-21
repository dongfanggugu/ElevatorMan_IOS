//
//  AddressViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/5.
//
//

#import <Foundation/Foundation.h>
#import "AddressViewController.h"
#import "AddressLocationController.h"
#import "DistributeController.h"


@interface AddressViewController () <UITableViewDelegate, UITableViewDataSource, AddressLocationControllerDelegate, DistributeControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UIView *viewAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;


@end

@implementation AddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"地址修改"];
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = RGB(BG_GRAY);

    _cityLabel.text = @"北京市";
    if (_addType == TYPE_HOME)
    {
        _cityLabel.text = [User sharedUser].homeCity;
        _zoneLabel.text = [NSString stringWithFormat:@"%@(点击修改)", [User sharedUser].homeZone];
        _lbAddress.text = [NSString stringWithFormat:@"%@(点击修改)", [User sharedUser].homeAddress];
    }
    else if (_addType == TYPE_WORK)
    {
        _cityLabel.text = [User sharedUser].workCity;
        _zoneLabel.text = [NSString stringWithFormat:@"%@(点击修改)", [User sharedUser].workZone];
        _lbAddress.text = [NSString stringWithFormat:@"%@(点击修改)", [User sharedUser].workAddress];
    }

    _zoneLabel.userInteractionEnabled = YES;
    [_zoneLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readZones)]];

    _viewAddress.userInteractionEnabled = YES;
    [_viewAddress addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(location)]];

    _btnSubmit.hidden = YES;
    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius = 5;

    [_btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)readZones
{
    DistributeController *controller = [[DistributeController alloc] init];
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - DistributeControllerDelegate

- (void)onChooseZone:(NSString *)zone
{
    if (_btnSubmit.hidden)
    {
        _btnSubmit.hidden = NO;
    }
    _zoneLabel.text = zone;
}

- (void)location
{
    AddressLocationController *controller = [[AddressLocationController alloc] init];
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -  AddressLocationControllerDelegate

- (void)onChooseCell:(NSString *)cell address:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng
{
    if (_btnSubmit.hidden)
    {
        _btnSubmit.hidden = NO;
    }
    _lbAddress.text = [NSString stringWithFormat:@"%@%@", cell, address];
    _lat = lat;
    _lng = lng;
}

- (void)submit
{
    NSString *zone = _zoneLabel.text;
    if (0 == zone.length || [zone containsString:@"点击选择"])
    {
        [self showMsgAlert:@"请选择您所在的城区!"];
        return;
    }

    NSString *address = _lbAddress.text;
    if (0 == address.length || [address containsString:@"点击选择"])
    {
        [self showMsgAlert:@"请填写您的详细地址!"];
        return;
    }

    if (_addType == TYPE_HOME)
    {
        [self reportHome];
    }
    else if (_addType == TYPE_WORK)
    {
        [self reportWork];
    }
    else if (_addType == TYPE_PRO)
    {
        [self reportPro];
    }
}

- (void)reportHome
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"北京市" forKey:@"family_province"];

    [params setObject:@"北京市" forKey:@"family_city"];

    [params setObject:_zoneLabel.text forKey:@"family_county"];

    NSString *address = _lbAddress.text;
    [params setObject:address forKey:@"family_address"];

    params[@"lat"] = [NSNumber numberWithFloat:_lat];
    params[@"lng"] = [NSNumber numberWithFloat:_lng];

    [[HttpClient sharedClient] view:self.view post:@"saveOrUpdateFamilyAddress" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [User sharedUser].homeZone = _zoneLabel.text;
        [User sharedUser].homeAddress = address;
        [[User sharedUser] setUserInfo];
        [HUDClass showHUDWithLabel:@"您已经成功更新您的家庭住址!" view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)reportWork
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"北京市" forKey:@"family_province"];

    [params setObject:@"北京市" forKey:@"family_city"];

    [params setObject:_zoneLabel.text forKey:@"family_county"];

    NSString *address = _lbAddress.text;
    [params setObject:address forKey:@"family_address"];

    params[@"lat"] = [NSNumber numberWithFloat:_lat];
    params[@"lng"] = [NSNumber numberWithFloat:_lng];

    [[HttpClient sharedClient] view:self.view post:@"saveOrUpdateResidentAddress" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [User sharedUser].workZone = _zoneLabel.text;
        [User sharedUser].workAddress = address;
        [[User sharedUser] setUserInfo];
        [HUDClass showHUDWithLabel:@"您已经成功更新您的工作地址!" view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)reportPro
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"北京市" forKey:@"family_province"];

    [params setObject:@"北京市" forKey:@"family_city"];

    [params setObject:_zoneLabel.text forKey:@"family_county"];

    NSString *address = _lbAddress.text;
    [params setObject:address forKey:@"family_address"];

    params[@"lat"] = [NSNumber numberWithFloat:_lat];
    params[@"lng"] = [NSNumber numberWithFloat:_lng];

    [[HttpClient sharedClient] view:self.view post:@"addPropertyAddress" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



@end
