//
//  ComMaintTitleView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import <UIKit/UIKit.h>

@protocol ComMaintTitleViewDelegate <NSObject>

- (void)onClickBtn1;

- (void)onClickBtn2;

- (void)onClickBtn3;

- (void)onClickBtn4;

@end

@interface ComMaintTitleView : UIView

+ (id)viewFromNib;

@property (weak,nonatomic) IBOutlet UILabel *lbCompany;

@property (weak,nonatomic) IBOutlet UILabel *lbWorker;

@property (weak, nonatomic) id<ComMaintTitleViewDelegate> delegate;

@end
