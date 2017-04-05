//
//  LocationViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/5.
//
//

#ifndef LocationViewController_h
#define LocationViewController_h

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol LocationControllerDelegate <NSObject>

- (void)onChooseAddressLat:(CGFloat)lat lng:(CGFloat)lng;

@end

@interface LocationViewController : BaseViewController

@property (strong, nonatomic) NSString *address;

@property (weak, nonatomic) id<LocationControllerDelegate> delegate;

@property NSInteger enterType;

@end


#endif /* LocationViewController_h */
