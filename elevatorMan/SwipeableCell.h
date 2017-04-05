//
//  SwipeableCell.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/10.
//
//

#ifndef SwipeableCell_h
#define SwipeableCell_h


#endif /* SwipeableCell_h */

@protocol SwipeableCellDelegate <NSObject>

- (void)buttonClicked:(NSString *)buttonType tag:(NSInteger)tag;

@end

@interface SwipeableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *indexView;

@property (weak, nonatomic) IBOutlet UILabel *labelDays;

@property (weak, nonatomic) IBOutlet UILabel *labelCode;

@property (weak, nonatomic) IBOutlet UILabel *labelAddress;

@property (weak, nonatomic) IBOutlet UILabel *labelDateDes;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UILabel *labelTypeDes;

@property (weak, nonatomic) IBOutlet UILabel *labelType;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@property (weak, nonatomic) IBOutlet UILabel *labelTian;

@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;

@property (assign, nonatomic) CGPoint panStartPoint;

@property (assign, nonatomic) CGFloat startingRightLayoutConstraintConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeft;

@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) id<SwipeableCellDelegate> swipeableCellDelegate;

- (void)setSwipeable:(BOOL)swipeable;

@end
