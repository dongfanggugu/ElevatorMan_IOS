//
//  DeviceTableViewCell.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleateDeviceButtonClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegateDeviceBySerail:)]) {
        
        [self.delegate delegateDeviceBySerail:_deviceSerailNo.text];
    }
    
}
@end
