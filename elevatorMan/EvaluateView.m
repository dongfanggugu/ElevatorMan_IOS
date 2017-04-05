//
//  EvaluateView.m
//  owner
//
//  Created by 长浩 张 on 2017/1/11.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvaluateView.h"

@interface EvaluteView()

@property (weak, nonatomic) IBOutlet UIButton *btnStar1;

@property (weak, nonatomic) IBOutlet UIButton *btnStar2;

@property (weak, nonatomic) IBOutlet UIButton *btnStar3;

@property (weak, nonatomic) IBOutlet UIButton *btnStar4;

@property (weak, nonatomic) IBOutlet UIButton *btnStar5;

@property (weak, nonatomic) IBOutlet UITextField *tfContent;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property NSInteger starCount;

@end

@implementation EvaluteView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"EvaluateView" owner:nil options:nil];
    
    if (0 == array)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)viewHight
{
    return 200;
}

- (void)setModeShow
{
    _btnSubmit.hidden = YES;
    _tfContent.enabled = false;
    _btnStar1.enabled = false;
    _btnStar2.enabled = false;
    _btnStar3.enabled = false;
    _btnStar4.enabled = false;
    _btnStar5.enabled = false;
}


- (void)setContent:(NSString *)content
{
    _tfContent.text = content;
}

- (void)setStar:(NSInteger)star
{
    _starCount = star;
    if (1 == star)
    {
        [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
        [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
        [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
        [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    }
    else if (2 == star)
    {
        [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
        [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
        [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    }
    else if (3 == star)
    {
        [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
        [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    }
    else if (4 == star)
    {
        [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    }
    else if (5 == star)
    {
        [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
        [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];

    }
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _starCount = 0;
    
    [_btnStar1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [_btnStar2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
    [_btnStar3 addTarget:self action:@selector(clickBtn3) forControlEvents:UIControlEventTouchUpInside];
    [_btnStar4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];
    [_btnStar5 addTarget:self action:@selector(clickBtn5) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickBtn1
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    _starCount = 1;
}

- (void)clickBtn2
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    _starCount = 2;
}

- (void)clickBtn3
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    
    _starCount = 3;
}

- (void)clickBtn4
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    
    _starCount = 4;

}

- (void)clickBtn5
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    
    _starCount = 5;
}
- (void)submit
{
    if (_delegate)
    {
        [_delegate onSubmit:_starCount content:_tfContent.text];
    }
}

- (NSInteger)getStarCount
{
    return _starCount;
}

- (NSString *)getContent
{
    return _tfContent.text;
}

@end
