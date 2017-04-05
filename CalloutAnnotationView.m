//
//  CalloutAnnotationView.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#import <Foundation/Foundation.h>
#import "CalloutAnnotationView.h"
#import "AlarmInfoView.h"
#import "HttpClient.h"

@interface CalloutAnnotationView()


@end

@implementation CalloutAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    
    return self;
}

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //self.backgroundColor = [UIColor greenColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, 1);
        self.frame = CGRectMake(0, 0, 25, 25);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        imageView.image = [UIImage imageNamed:@"icon_project"];
        [self addSubview:imageView];
    }
    
    return self;
}

- (void)showInfoWindow
{
    
    _alarmInfoView = [AlarmInfoView viewFromNib];
    _alarmInfoView.backgroundColor = [UIColor clearColor];
    
    _alarmInfoView.frame = CGRectMake(-98, -120, 210, 120);
    
    NSString *project = [_info objectForKey:@"name"];
    NSString *brands = [_info objectForKey:@"brand"];
    NSString *tel = [_info objectForKey:@"projectTela"];
    
    _alarmInfoView.projectLabel.text = project;
    _alarmInfoView.addressLabel.text = brands;
    _alarmInfoView.propertyTel.text = tel;
    
    [_alarmInfoView onClickTel:^(NSString *tel) {
        NSLog(@"contacts tel:%@", tel);
        
        if (0 == tel.length)
        {
            [HUDClass showHUDWithLabel:@"非法的手机号码,无法拨打!" view:self];
            return;
        }
        
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [self addSubview:webView];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"communityId"] = [_info objectForKey:@"id"];
        
        [[HttpClient sharedClient] view:nil post:@"addContactMaint" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        }];
        
    }];
    
    [self addSubview:_alarmInfoView];
}

- (void)hideInfoWindow
{
    [_alarmInfoView removeFromSuperview];
}


/**
 *  解决自定义View里面事件被mapview截断的问题
 *
 *  @param point
 *  @param event
 *
 *  @return
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
