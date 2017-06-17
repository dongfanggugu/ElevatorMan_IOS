//
// Created by changhaozhang on 2017/6/17.
//

#import <Foundation/Foundation.h>
#import "BMKAnnotationView.h"


@interface RepairAnnotationView : BMKAnnotationView

- (void)showInfoView;

- (void)hideInfoView;

+ (NSString *)identifier;

@property (weak, nonatomic) UIImage *image;

@property (strong, nonatomic) NSDictionary *info;

@property (strong, nonatomic) void (^onClickDetail)();


@end