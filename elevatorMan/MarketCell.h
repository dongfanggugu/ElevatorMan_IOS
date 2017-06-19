//
//  MarketCell.h
//  owner
//
//  Created by 长浩 张 on 2017/1/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MarketCell_h
#define MarketCell_h

@interface MarketCell : UITableViewCell

+ (instancetype)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end

#endif /* MarketCell_h */
