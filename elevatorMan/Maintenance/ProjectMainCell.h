//
//  ProjectMainCell.h
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/26.
//
//

#ifndef ProjectMainCell_h
#define ProjectMainCell_h

@interface ProjectMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbInfo;


+ (id)viewFromNib;

+ (NSString *)getIdentifier;

+ (CGFloat)cellHeight;

- (void)setOnClickDetailListener:(void(^)())onClickDetail;

@end


#endif /* ProjectMainCell_h */
