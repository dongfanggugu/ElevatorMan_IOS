//
//  AlarmTitleView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import <UIKit/UIKit.h>

@protocol AlarmTitleViewDelegate <NSObject>

- (void)onClickNeed;

- (void)onClickSave;

- (void)onClickFinish;

- (void)onClickRevoke;

@end

@interface AlarmTitleView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) id<AlarmTitleViewDelegate> delegate;

@end
