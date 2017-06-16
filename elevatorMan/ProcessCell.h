//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Process_Location)
{
    Location_Head,
    Location_Middle,
    Location_Tail
};

@interface ProcessCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (assign, nonatomic) BOOL isHere;

@property (strong, nonatomic) void(^onClickBtn)();

@property (assign, nonatomic) Process_Location location;

@property (weak, nonatomic) IBOutlet UILabel *lbProcess;

@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@property (weak, nonatomic) IBOutlet UILabel *lbDes;

@end