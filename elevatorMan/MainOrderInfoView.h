//
//  MainOrderInfoView.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainOrderInfoView_h
#define MainOrderInfoView_h

#import "UIImageView+AFNetworking.h"

@class MainOrderInfoView;

@protocol MainOrderInfoViewDelegate <NSObject>

- (void)onClickLinkButton:(MainOrderInfoView *)view;

- (void)onClickPlanButton:(MainOrderInfoView *)view;

- (void)onClickDetailButton:(MainOrderInfoView *)view;

- (void)onClickChangeButton:(MainOrderInfoView *)view;

@end


@interface MainOrderInfoView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbExpire;

@property (weak, nonatomic) IBOutlet UILabel *lbTag;

@property (weak, nonatomic) IBOutlet UIButton *btnChange;

@property (weak, nonatomic) id<MainOrderInfoViewDelegate> delegate;

@property (strong, nonatomic) NSDictionary *data;

@end

#endif /* MainOrderInfoView_h */
