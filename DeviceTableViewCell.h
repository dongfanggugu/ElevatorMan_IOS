//
//  DeviceTableViewCell.h
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceTableViewCellDelegate <NSObject>

- (void)delegateDeviceBySerail:(NSString *)serial;

@end

@interface DeviceTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *deviceSerailNo;

@property (nonatomic, weak) id<DeviceTableViewCellDelegate>delegate;

@end
