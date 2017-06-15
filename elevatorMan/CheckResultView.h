//
//  CheckResultView.h
//  owner
//
//  Created by changhaozhang on 2017/6/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckResultView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@end
