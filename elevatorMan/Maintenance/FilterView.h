
//
//  FilterView.h
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/26.
//
//

#ifndef FilterView_h
#define FilterView_h

#pragma mark FilterDelegate

@protocol FilterDelegate <NSObject>

- (void)afterSelection:(NSString *)value;

- (void)onClickSearch;

@end

#pragma mark - FilterView

@interface FilterView : UIView


+ (id)viewFromNib;

+ (CGFloat)viewHeight;

- (void)setView:(UIView *)view;

@property (weak, nonatomic) id<FilterDelegate> delegate;

@end


#endif /* FilterView_h */
