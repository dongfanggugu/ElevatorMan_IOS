//
//  ElevatorsViewController.h
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewController.h"

@interface ElevatorsViewController : BaseCollectionViewController


@property (nonatomic, strong)NSArray *elevatorListArray;
@property (nonatomic, strong)NSString *buildingNum;
@property (nonatomic, strong)NSString *projectName;

@end
