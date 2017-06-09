//
// Created by changhaozhang on 2017/6/9.
//

#import <Foundation/Foundation.h>

@protocol HouseTitleViewDelegate <NSObject>

- (void)onClickNeed;

- (void)onClickSave;

- (void)onClickFinish;

- (void)onClickRevoke;

@end

@interface HouseTitleView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) id<HouseTitleViewDelegate> delegate;

@end