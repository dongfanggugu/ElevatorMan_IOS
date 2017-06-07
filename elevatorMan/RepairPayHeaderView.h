//
//  RepairPayHeaderView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import <UIKit/UIKit.h>

@protocol RepairPayHeaderViewDelegate <NSObject>

- (void)onClickAdd;

@end

@interface RepairPayHeaderView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) id<RepairPayHeaderViewDelegate> delegate;

@end
