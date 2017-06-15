//
//  RepairTaskMakeView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import <UIKit/UIKit.h>

@protocol RepairTaskMakeViewDelegate <NSObject>

- (void)onClickSubmit;

@end

@interface RepairTaskMakeView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbPlan;

@property (weak, nonatomic) IBOutlet UIButton *btnModify;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) id<RepairTaskMakeViewDelegate> delegate;

@end
