//
//  ComMaintTitleView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import <UIKit/UIKit.h>

@protocol ListDialogDataDelegate;

@protocol ComMaintTitleViewDelegate <NSObject>

- (void)onClickBtn1;

- (void)onClickBtn2;

- (void)onClickBtn3;

- (void)onClickBtn4;

- (void)onChooseCompany:(NSString *)comId name:(NSString *)name;

- (void)onChooseWorker:(NSString *)workerId name:(NSString *)name;

@end

@interface ComMaintTitleView : UIView

+ (id)viewFromNib;

@property (weak,nonatomic) IBOutlet UIButton *btn1;

@property (weak,nonatomic) IBOutlet UIButton *btn2;

@property (weak,nonatomic) IBOutlet UIButton *btn3;

@property (weak,nonatomic) IBOutlet UIButton *btn4;

@property (strong, nonatomic) NSArray<id <ListDialogDataDelegate>> *arrayCompany;

@property (strong, nonatomic) NSArray<id <ListDialogDataDelegate>> *arrayWorker;

@property (weak, nonatomic) IBOutlet UILabel *lbCompany;

@property (weak, nonatomic) IBOutlet UILabel *lbWorker;

@property (weak, nonatomic) id <ComMaintTitleViewDelegate> delegate;

@end
