//
//  LiftDetailViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "LiftDetailViewController.h"

#pragma mark -- DetailCell

@interface DetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation DetailCell


@end

#pragma mark -- LiftDetailViewController

@interface LiftDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation LiftDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"电梯详情"];
    [self initView];
}

- (void)initView {
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail_cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSInteger index = indexPath.row;

    NSString *key = nil;
    NSString *value = nil;
    if (0 == index) {
        key = @"电梯编号";
        value = _liftCode;
    } else if (1 == index) {
        key = @"所属项目";
        value = _project;
    } else if (2 == index) {
        key = @"地址";
        value = _address;
    } else if (3 == index) {
        key = @"品牌";
        value = _brand;
    } else if (4 == index) {
        key = @"维保负责人";
        value = _worker;
    } else if (5 == index) {
        key = @"负责人电话";
        value = _tel;
    }

    cell.keyLabel.text = key;
    cell.valueLabel.text = value;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.row) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth - 8 - 100 - 8 - 8, 0)];

        label.text = _address;

        label.font = [UIFont systemFontOfSize:14];

        label.numberOfLines = 0;

        [label sizeToFit];

        return label.frame.size.height + 10 + 10;

    }

    return 44;
}

@end
