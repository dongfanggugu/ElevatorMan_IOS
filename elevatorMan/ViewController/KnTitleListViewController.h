//
//  KnTitleListViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/29.
//
//

#ifndef KnTitleListViewController_h
#define KnTitleListViewController_h

#import "BaseTableViewController.h"

@interface KnTitleListViewController : BaseTableViewController

@property NSInteger mType;

@property (strong, nonatomic) NSString *brand;

@property (strong, nonatomic) NSString *keywords;

@end


#endif /* KnTitleListViewController_h */
