//
//  BaseCollectionViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/29.
//
//

#ifndef BaseCollectionViewController_h
#define BaseCollectionViewController_h

@interface BaseCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSString *notifyAlarmId;

- (void)setNavTitle:(NSString *)title;

- (void)hideBackIcon;

@end


#endif /* BaseCollectionViewController_h */
