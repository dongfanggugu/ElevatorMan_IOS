//
// Created by changhaozhang on 2017/6/9.
//

#import "MaintLiftController.h"
#import "ComMaintInfoCell.h"

@interface MaintLiftController () <UITableViewDelegate, UITableViewDataSource>

@property  (strong, nonatomic) UITableView *tableView;

@property  (strong, nonatomic) NSMutableArray *arrayLift;


@end


@implementation MaintLiftController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"电梯维保"];
    [self initView];
}

- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

- (NSMutableArray *)arrayLift {
    if (!_arrayLift) {
        _arrayLift = [NSMutableArray array];
    }
    return _arrayLift;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.arrayLift;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComMaintInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ComMaintInfoCell identifier]];

    if (!cell) {
        cell = [ComMaintInfoCell cellFromNib];
    }

    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ComMaintInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end