//
// Created by changhaozhang on 2017/6/14.
//

    #import "MaintAnnotationView.h"

@interface MaintAnnotationView ()

@property (strong, nonatomic) UIView *infoView;

@property (strong, nonatomic) UIImageView *iv;

@end


@implementation MaintAnnotationView

- (id)initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

    if (self)
    {
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, 12);
        self.frame = CGRectMake(0, 0, 24, 24);

        self.iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];

        self.iv.image = [UIImage imageNamed:@"icon_com_project.png"];

        [self addSubview:self.iv];
    }

    return self;
}

- (void)setImage:(UIImage *)image
{
    self.iv.image = image;
}

+ (NSString *)identifier
{
    return @"maint_annotation_view";
}

- (void)showInfoView
{
    if (self.infoView)
    {
        return;
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 120, 0)];

    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;

    NSString *project = _arrayInfo[0][@"communityName"];

    label.text = [NSString stringWithFormat:@"%@(%ld)", project, _arrayInfo.count];

    [label sizeToFit];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 26)];
    [btn setTitle:@"查看详情" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];
    btn.center = CGPointMake(60, label.frame.size.height + 16 + 13);
    [btn addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];

    _infoView = [[UIView alloc] initWithFrame:CGRectMake(-60 + 12, - (8 + label.frame.size.height + 16 + 30) + 12, 136, 8 + label.frame.size.height + 16 + 30)];
    _infoView.backgroundColor = [UIColor whiteColor];

    _infoView.layer.masksToBounds = YES;
    _infoView.layer.cornerRadius = 5;

    [_infoView addSubview:label];
    [_infoView addSubview:btn];
    [self addSubview:_infoView];

    //保证弹出框显示在最上层
    [[self superview] bringSubviewToFront:self];
}

- (void)hideInfoView
{
    if (self.infoView)
    {
        [self.infoView removeFromSuperview];

        self.infoView = nil;
    }
}

- (void)clickDetail
{
    if (_onClickDetail)
    {
        _onClickDetail(_arrayInfo);
    }
}

- (void)setOnClickDetail:(void (^)(NSArray *))onClickDetail
{
    _onClickDetail = onClickDetail;
}

/**
 *  解决自定义View里面事件被mapview截断的问题
 *
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = self.bounds;

    BOOL isInside = CGRectContainsPoint(rect, point);
    if (!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if (isInside)
            {
                return isInside;
            }
        }
    }

    return isInside;
}

@end
