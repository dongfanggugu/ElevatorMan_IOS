//
//  AddressLocationController.h
//  owner
//
//  Created by 长浩 张 on 2017/4/19.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddressLocationControllerDelegate <NSObject>

@optional

- (void)onChooseAddress:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng;

- (void)onChooseCell:(NSString *)cell address:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng;

@end

@interface AddressLocationController : BaseViewController

@property (weak, nonatomic) id<AddressLocationControllerDelegate> delegate;

@end
