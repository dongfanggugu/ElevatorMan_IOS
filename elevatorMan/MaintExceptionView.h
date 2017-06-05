//
//  MaintExceptionView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import <UIKit/UIKit.h>

@protocol MaintExceptionViewDelegate <NSObject>

- (void)onClickSubmit;

@end

@interface MaintExceptionView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UITextView *tvException;

@property (weak, nonatomic) IBOutlet UILabel *lbPlan;

@property (weak, nonatomic) IBOutlet UIButton *btnPlan;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) id<MaintExceptionViewDelegate> delegate;

@end
