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

@property (weak, nonatomic) NSArray<id<ListDialogDataDelegate>> *arrayCompany;

@property (weak, nonatomic) NSArray<id<ListDialogDataDelegate>> *arrayWorker;

@property (weak,nonatomic) IBOutlet UILabel *lbCompany;

@property (weak,nonatomic) IBOutlet UILabel *lbWorker;

@property (weak, nonatomic) id<ComMaintTitleViewDelegate> delegate;

@end
