//
//  MaintResultShowController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "MaintResultShowController.h"
#import "MaintResultView.h"

@interface MaintResultShowController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MaintResultView *resultView;

@end

@implementation MaintResultShowController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保结果"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:tableView];
    
    _resultView = [MaintResultView viewFromNib];
    
    tableView.tableHeaderView = _resultView;
    
    _resultView.showMode = YES;
    
    _resultView.tvContent.text = _content;
    //加载维保图片
    [_resultView.ivBefore setImageWithURL:[NSURL URLWithString:_urlBefore]];
    
    [_resultView.ivAfter setImageWithURL:[NSURL URLWithString:_urlAfter]];
}


#pragma mark - MaintResultViewDelegate


- (void)onClickBeforeImage
{
}

- (void)onClickAfterImage
{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
