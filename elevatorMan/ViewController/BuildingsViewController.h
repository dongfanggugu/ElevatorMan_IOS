//
//  BuildingsViewController.h
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BaseCollectionViewController.h"

@interface BuildingsViewController : BaseCollectionViewController

@property (nonatomic, strong)NSArray *buildingArray;

@property (nonatomic, strong)NSString *projectName;


@end
