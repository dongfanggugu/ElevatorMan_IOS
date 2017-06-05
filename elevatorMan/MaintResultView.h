//
//  MaintResultView.h
//  owner
//
//  Created by changhaozhang on 2017/6/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintResultView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@property (weak, nonatomic) IBOutlet UIImageView *ivBefore;

@property (weak, nonatomic) IBOutlet UIImageView *ivAfter;

@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UIButton *btnBefore;

@property (weak, nonatomic) IBOutlet UIButton *btnAfter;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end
