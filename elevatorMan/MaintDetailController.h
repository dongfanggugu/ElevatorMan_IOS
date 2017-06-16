//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@protocol MaintDetailControllerDelegate <NSObject>

- (void)onClickPay;

@end

@interface MaintDetailController : BaseViewController

@property (strong, nonatomic) NSDictionary *orderInfo;

@property (weak, nonatomic) id <MaintDetailControllerDelegate> delegate;

@end