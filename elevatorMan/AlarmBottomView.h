//
//  AlarmBottomView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import <UIKit/UIKit.h>

@interface AlarmBottomView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbProperty;

@property (weak, nonatomic) IBOutlet UILabel *lbLift;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbState;

@end
