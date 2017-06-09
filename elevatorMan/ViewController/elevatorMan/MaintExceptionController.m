//
//  MaintExceptionController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import "MaintExceptionController.h"
#import "MaintExceptionView.h"

@interface MaintExceptionController () <UITableViewDelegate, UITableViewDataSource, MaintExceptionViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MaintExceptionView *exceptionView;

@end

@implementation MaintExceptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"无法出发"];
    [self initView];
}

- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _exceptionView = [MaintExceptionView viewFromNib];

    _exceptionView.delegate = self;

    _tableView.tableHeaderView = _exceptionView;

    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - MaintExceptionViewDelegate

- (void)onClickSubmit {

}


@end
