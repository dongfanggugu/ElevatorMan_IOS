//
// Created by changhaozhang on 2017/6/14.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface MaintAnnotationView : BMKAnnotationView

- (void)showInfoView;

- (void)hideInfoView;

+ (NSString *)identifier;

@property (weak, nonatomic) UIImage *image;

@property (strong, nonatomic) NSArray *arrayInfo;

@property (strong, nonatomic) NSDictionary *info;

@property (strong, nonatomic) void (^onClickDetail)(NSArray *arrayInfo);

@end