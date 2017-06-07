//
//  ImageViewDelView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import "ImageViewDelView.h"

@interface ImageViewDelView ()

@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;

@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@end

@implementation ImageViewDelView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ImageViewDelView" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnDel.hidden = YES;
    
    [_btnDel addTarget:self action:@selector(clickDel) forControlEvents:UIControlEventTouchUpInside];
    
    _ivPhoto.userInteractionEnabled = YES;
    
    [_ivPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)]];
}

- (void)clickImage
{
    if (_onClickImage) {
        _onClickImage();
    }
}

- (void)clickDel
{
    if (_onClickDel) {
        _onClickDel();
    }
}

- (void)setImage:(UIImage *)image
{
    self.hasImage = YES;
    
    _btnDel.hidden = NO;
    
    _ivPhoto.image = image;
}

- (void)reset
{
    _hasImage = NO;
    
    _btnDel.hidden = YES;
    
    _ivPhoto.image = [UIImage imageNamed:@"icon_photo"];
}


@end
