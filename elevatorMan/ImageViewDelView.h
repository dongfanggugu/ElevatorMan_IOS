//
//  ImageViewDelView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import <UIKit/UIKit.h>

@interface ImageViewDelView : UIView

+ (id)viewFromNib;

- (void)reset;

@property (weak, nonatomic) UIImage *image;

@property (assign, nonatomic) BOOL hasImage;

@property (strong, nonatomic) void (^onClickDel)();

@property (strong, nonatomic) void (^onClickImage)();

@end
