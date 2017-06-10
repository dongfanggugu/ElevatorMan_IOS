//
//  KnowledgeController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "KnowledgeController.h"
#import "PullTableView.h"
#import "KnInfoCell.h"
#import "KnowledgeDetailController.h"

@interface KnowledgeController () <UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayKn;

@end

@implementation KnowledgeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:_knType];
    [self initView];
    [self getKnowledge];
}

- (NSMutableArray *)arrayKn
{
    if (!_arrayKn)
    {
        _arrayKn = [NSMutableArray array];
    }

    return _arrayKn;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    //_tableView.pullDelegate = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

- (void)getKnowledge
{
    if (0 == _knType.length)
    {
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"kntype"] = _knType;

    params[@"rows"] = [NSNumber numberWithInteger:100];

    params[@"page"] = [NSNumber numberWithInteger:1];

    [[HttpClient sharedClient] post:@"getKnowledgeByKntype" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.arrayKn removeAllObjects];
        [self.arrayKn addObjectsFromArray:responseObject[@"body"]];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayKn.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KnInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[KnInfoCell identifier]];

    if (!cell)
    {
        cell = [KnInfoCell cellFromNib];
    }

    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    NSDictionary *info = self.arrayKn[indexPath.row];

    cell.lbTitle.text = info[@"title"];

    cell.lbKeywords.text = info[@"keywords"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [KnInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.arrayKn[indexPath.row];

    KnowledgeDetailController *controller = [[KnowledgeDetailController alloc] init];

    controller.content = info[@"content"];

    controller.knTitle = info[@"title"];

    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}


- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{

}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{

}

@end
