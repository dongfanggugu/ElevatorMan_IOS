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

@end


#endif /* AddressViewController_h */
