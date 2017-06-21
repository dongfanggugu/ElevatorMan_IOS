//
// Created by changhaozhang on 2017/6/21.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@protocol DistributeControllerDelegate <NSObject>

- (void)onChooseZone:(NSString *)zone;

@end

@interface DistributeController : BaseViewController


@property (weak, nonatomic) id <DistributeControllerDelegate> delegate;

@end