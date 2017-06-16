//
//  HomeViewController.m
//  Painter
//
//  Created by  ibokan on 10-9-7.
//  Copyright 2010 tencent.com. All rights reserved.
//

#import "PaintViewController.h"
#import "PainterView.h"

@interface PaintViewController ()
{
    PainterView *_painterView;
    UIToolbar *_toolbar;
}

@end


@implementation PaintViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"签名"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self landscapeRight];
}

- (void)initView
{
    _painterView = [[PainterView alloc] initWithFrame:CGRectMake(0, 32, self.screenHeight, self.screenWidth - 32 - 40)];

    [self.view addSubview:_painterView];

    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.screenWidth - 40, self.screenHeight, 40)];

    _toolbar.barStyle = UIBarStyleBlack;

    [self.view addSubview:_toolbar];

    UIBarButtonItem *eraseButton = [[UIBarButtonItem alloc] initWithTitle:@"擦除"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(erase)];

    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"清除"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(clear)];
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(finish)];


    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];

    [_toolbar setItems:[NSArray arrayWithObjects:space, eraseButton, space, clearButton, space, finishButton, space, nil]];
}


- (void)erase
{
    [_painterView erase];
}

- (void)clear
{
    [_painterView resetView];
    [_painterView setColor:[UIColor blackColor]];
}

- (void)finish
{
    UIImage *image = [_painterView save];

    NSString *code = [Utils image2Base64:image];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    param[@"autograph"] = code;

    [[HttpClient sharedClient] view:self.view post:@"updateLoadAutograph" parameter:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *signUrl = [responseObject[@"body"] objectForKey:@"autograph"];

        [self saveSign:signUrl];

    }                        failed:^(id responseObject) {

    }];
}

- (void)saveSign:(NSString *)signUrl;
{
    [User sharedUser].signUrl = signUrl;

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc
{
}


@end
