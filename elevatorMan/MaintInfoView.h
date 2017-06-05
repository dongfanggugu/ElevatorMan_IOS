//
//  MaintInfoView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import <UIKit/UIKit.h>


@protocol MaintInfoViewDelegate <NSObject>

- (void)onClickStart;

- (void)onClickException;

- (void)onClickStretch;

- (void)onClickMake;

@end

@interface MaintInfoView : UIView

+ (id)viewFromNib;

+ (CGFloat)viewHeight;

+ (CGFloat)basicInfoHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbDis;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbLinkInfo;

@property (weak, nonatomic) IBOutlet UILabel *lbPlan;

@property (weak, nonatomic) IBOutlet UILabel *lbBrand;

@property (weak, nonatomic) IBOutlet UILabel *lbLoad;

@property (weak, nonatomic) IBOutlet UILabel *lbLayer;

@property (weak, nonatomic) IBOutlet UIButton *btnStretch;

@property (weak, nonatomic) IBOutlet UIButton *btnPlan;

@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (weak, nonatomic) IBOutlet UIButton *btnException;

@property (weak, nonatomic) IBOutlet UIButton *btnMake;

@property (weak, nonatomic) id<MaintInfoViewDelegate> delegate;

@end
