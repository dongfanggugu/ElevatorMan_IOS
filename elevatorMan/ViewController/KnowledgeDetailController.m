//
//  KnowledgeDetailController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "KnowledgeDetailController.h"

@interface KnowledgeDetailController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation KnowledgeDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:_knTitle];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    _webView.scrollView.bounces = NO;

    if (_content.length > 0)
    {
        [_webView loadHTMLString:_content baseURL:nil];
    }

    [self.view addSubview:_webView];
}
@end
