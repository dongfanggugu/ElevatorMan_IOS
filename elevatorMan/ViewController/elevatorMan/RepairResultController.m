//
//  RepairResultController.m
//  owner
//
//  Created by changhaozhang on 2017/6/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairResultController.h"
#import "CheckResultView.h"

#define ImageView_Width 90
#define ImageView_Height 120

@interface RepairResultController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RepairResultController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维修结果"];

    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


    UIView *showView = [self addImageViews];

    CheckResultView *resultView = [CheckResultView viewFromNib];
    resultView.lbTitle.text = @"维修结果";
    resultView.tvContent.text = _repairResult;


    //处理两个view，添加到统一的UIView上
    CGFloat showHeight = showView.frame.size.height;

    CGRect frame = resultView.frame;

    frame.origin.y = showHeight;

    frame.size.width = self.screenWidth;

    resultView.frame = frame;

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, showHeight + frame.size.height)];

    [headView addSubview:showView];
    [headView addSubview:resultView];


    _tableView.tableHeaderView = headView;

    [self.view addSubview:_tableView];
}

- (UIView *)addImageViews
{
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 0)];

    NSArray *array = [self.urls componentsSeparatedByString:@","];

    if (0 == array.count)
    {
        return nil;
    }

    NSInteger rows = (array.count - 1) / 3 + 1;

    CGRect frame = showView.frame;

    frame.size.height = 16 + (ImageView_Height + 16) * rows;

    showView.frame = frame;

    //计算imageview的间隙
    CGFloat space = (self.screenWidth - ImageView_Width * 3) / 4;

    for (NSInteger i = 0;
            i < array.count;
            i++)
    {

        NSInteger row = i / 3;

        NSInteger column = i % 3;

        CGRect ivFrame = CGRectMake(space + (ImageView_Width + space) * column, 16 + (16 + ImageView_Height) * row, 90, 120);

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:ivFrame];


        [imageView setImageWithURL:[NSURL URLWithString:array[i]]];

        [showView addSubview:imageView];
    }

    return showView;

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
