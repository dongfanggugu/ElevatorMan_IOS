//
//  ReportAlarmViewController.h
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ReportAlarmViewController : BaseViewController


@property (nonatomic, strong)NSString *buildingNum;
@property (nonatomic, strong)NSString *projectName;
@property (nonatomic, strong)NSDictionary *liftDic;


@end


