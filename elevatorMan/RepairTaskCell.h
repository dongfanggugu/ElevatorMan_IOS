//
//  RepairTaskCell.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairTaskCell_h
#define RepairTaskCell_h

@interface RepairTaskCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbState;

@property (weak, nonatomic) IBOutlet UILabel *lbWorker;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@end

#endif /* RepairTaskCell_h */
