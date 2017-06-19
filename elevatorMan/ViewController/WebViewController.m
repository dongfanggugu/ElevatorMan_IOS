//
//  WebViewController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_marketType != Market_Msg)
    {
        [self initNavRightWithText:@"联系我们"];
    }

    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)onClickNavRight
{
    if (Market_Lift == _marketType)
    {

        WebViewController *controller = [[WebViewController alloc] init];
        controller.urlStr = [NSString stringWithFormat:@"%@h5/message", [Utils getIp]];
        controller.marketType = Market_Msg;

        [self.navigationController pushViewController:controller animated:YES];

    }
    else
    {

        WebViewController *controller = [[WebViewController alloc] init];
        controller.urlStr = [NSString stringWithFormat:@"%@h5/elevatorDecorationmessage", [Utils getIp]];
        controller.marketType = Market_Msg;

        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)popup
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];

    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _webView.scrollView.bounces = NO;

    _webView.delegate = self;

    [self.view addSubview:_webView];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"url:%@", url);

    if ([url containsString:@"indexPage"])
    {
        [self setNavTitle:@"整梯销售"];

    }
    else if ([url containsString:@"message"])
    {
        [self setNavTitle:@"留言"];

    }
    else if ([url containsString:@"elevatorInfoPage"]
            || [url containsString:@"elevatorDetailPage"])
    {
        [self setNavTitle:@"详情"];

    }
    else if ([url containsString:@"indexelevatorDecorationPage"])
    {
        [self setNavTitle:@"电梯装潢"];
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];

    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    return NO;
}

@end
