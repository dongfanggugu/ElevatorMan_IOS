//
//  ForgetPassWordViewController.h
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/15.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VIEWTYPE) {
    
    FORGETPASSWORD_TYPE,
    REGISTER_TYPE,
    
};
@interface ForgetPassWordViewController : UIViewController
{
    
    IBOutlet UIView *forgetBgView;
    
    IBOutlet UITextField *phoneNoTextField;
    
    IBOutlet UITextField *codeTextField;
    
    IBOutlet UITextField *passWordTextField;
    
    IBOutlet UIButton *getCodeButton;
    
    IBOutlet UIButton *OKButton;
    
}
@property (nonatomic, assign) VIEWTYPE viewtype;

@end
