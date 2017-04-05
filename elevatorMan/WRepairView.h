//
//  WRepairView.h
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/12.
//
//

#ifndef WRepairView_h
#define WRepairView_h

@interface WRepairView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@end


#endif /* WRepairView_h */
