//
//  PersonHeaderView.h
//  elevatorMan
//
//  Created by 长浩 张 on 2016/11/1.
//
//

#ifndef PersonHeaderView_h
#define PersonHeaderView_h

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@protocol PersonHeaderDelegate <NSObject>

- (void)onClickIcon;

@end

@interface PersonHeaderView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *age;

@property (weak, nonatomic) id<PersonHeaderDelegate> delegate;

@end


#endif /* PersonHeaderView_h */
