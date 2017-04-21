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


- (void)initView
{
    _painterView = [[PainterView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64 - 40)];
    
    [self.view addSubview:_painterView];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.screenHeight - 40, self.screenWidth, 40)];
    
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

-(void)erase
{
	[_painterView erase];
}

-(void)clear
{
	[_painterView resetView];
    [_painterView setColor:[UIColor blackColor]];
}

-(void)finish
{
    [_painterView save];
}

- (void)save
{
    [_painterView save];
}

- (void)dealloc 
{
}


@end
