//
// Created by changhaozhang on 2017/6/9.
//

#import <Foundation/Foundation.h>


@interface ComMaintInfoCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbIndex;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbWorker;

@end