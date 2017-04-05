//
//  AddressViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/5.
//
//

#ifndef AddressViewController_h
#define AddressViewController_h

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


typedef NS_ENUM(NSInteger, AddressType)
{
    TYPE_HOME,
    TYPE_WORK,
    TYPE_PRO
};

@interface AddressViewController : BaseViewController

@property (nonatomic) AddressType addType;

@property (weak, nonatomic) IBOutlet UIView *lngView;

@property (weak, nonatomic) IBOutlet UIView *latView;

@property (weak, nonatomic) IBOutlet UILabel *lngValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *latValueLabel;

@end


#endif /* AddressViewController_h */
