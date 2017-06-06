//
//  EvaluateController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "EvaluateController.h"
#import "EvaluateView.h"


@interface EvaluateController ()

@property (strong, nonatomic) EvaluteView *evaluateView;

@end

@implementation EvaluateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"用户评价"];
    [self initView];
}


- (void)initView
{
    _evaluateView = [EvaluteView viewFromNib];
    
    _evaluateView.frame = CGRectMake(0, 64, self.screenWidth, 350);
        
    [_evaluateView setModeShow];
    
    [_evaluateView setStar:_star];
    
    [_evaluateView setContent:_content];
    
    [self.view addSubview:_evaluateView];
}

@end
