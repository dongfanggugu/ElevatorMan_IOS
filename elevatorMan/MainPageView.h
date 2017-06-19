//
// Created by changhaozhang on 2017/6/17.
//

#import <Foundation/Foundation.h>


@interface MainPageView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UIView *viewAlarm;

@property (weak, nonatomic) IBOutlet UIView *viewMaint;

@property (weak, nonatomic) IBOutlet UIView *viewHouseMaint;

@property (weak, nonatomic) IBOutlet UIView *viewHouseRepair;

@property (weak, nonatomic) IBOutlet UIView *viewQa;

@property (weak, nonatomic) IBOutlet UIView *viewFault;

@property (weak, nonatomic) IBOutlet UIView *viewOp;

@property (weak, nonatomic) IBOutlet UIView *viewSafety;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;

//不同角色时，此处功能需要改变
@property (weak, nonatomic) IBOutlet UIImageView *ivMaint;

@property (weak, nonatomic) IBOutlet UILabel *lbMaint;

@property (weak, nonatomic) IBOutlet UIImageView *ivRepair;

@property (weak, nonatomic) IBOutlet UILabel *lbRepair;

@end