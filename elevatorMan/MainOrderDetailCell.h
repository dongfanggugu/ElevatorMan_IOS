//
//  MainOrderDetailCell.h
//  owner
//
//  Created by 长浩 张 on 2017/5/25.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainOrderDetailCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UITextView *lbContent;

@property (weak, nonatomic) IBOutlet UILabel *lbAppoint;

@property (weak, nonatomic) IBOutlet UILabel *lbBrand;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbAmount;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UILabel *lbDiscourt;

@property (weak, nonatomic) IBOutlet UILabel *lbPay;

@property (weak, nonatomic) IBOutlet UILabel *lbPayType;

@property (weak, nonatomic) IBOutlet UILabel *lbPayState;

@property (weak, nonatomic) IBOutlet UILabel *lbPayDate;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
