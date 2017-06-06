//
//  MainTaskCell.h
//  owner
//
//  Created by 长浩 张 on 2017/5/25.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTaskCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbIndex;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbWorker;

@property (weak, nonatomic) IBOutlet UILabel *lbState;

@end
