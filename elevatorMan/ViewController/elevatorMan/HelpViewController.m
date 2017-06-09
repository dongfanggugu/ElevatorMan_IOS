//
//  HelpViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/30.
//
//

#import <Foundation/Foundation.h>
#import "HelpViewController.h"

@interface HelpViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"帮助中心"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavIcon];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)initView {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURLRequest *url = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:path]];
    [_webView loadRequest:url];
}

- (void)popup {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setNavIcon {
    if (!self.navigationController) {
        return;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageView.image = [UIImage imageNamed:@"back_normal"];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popup)]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = item;
}


//- (void)setNavTitle:(NSString *)title
//{
//    if (!self.navigationController)
//    {
//        return;
//    }
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    label.text = title;
//    label.font = [UIFont fontWithName:@"System" size:17];
//    label.textColor = [UIColor whiteColor];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [self.navigationItem setTitleView:label];
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return NO;
}
@end
