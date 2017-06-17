//
//  ScrollAndPageView.m
//  WNES
//
//  Created by 长浩 张 on 16/8/3.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddBannerView.h"
#import "UIImageView+AFNetworking.h"

@interface AddBannerView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *firstView;

@property (strong, nonatomic) UIImageView *middleView;

@property (strong, nonatomic) UIImageView *lastView;

@property (nonatomic) CGFloat viewWidth;

@property (nonatomic) CGFloat viewHeight;

@property (strong, nonatomic) NSTimer *autoScrollTimer;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property NSInteger currentPage;

@end

@implementation AddBannerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        _viewWidth = self.bounds.size.width;
        _viewHeight = self.bounds.size.height;

        //设置scrollview
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(_viewWidth * 3, _viewHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];


        //设置分页
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _viewHeight - 30, _viewWidth, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [Utils getColorByRGB:TITLE_COLOR];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];

        //设置单击手势
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:_tap];

        _firstView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        _middleView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth, 0, _viewWidth, _viewHeight)];
        _lastView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth * 2, 0, _viewWidth, _viewHeight)];


        [_scrollView addSubview:_firstView];
        [_scrollView addSubview:_middleView];
        [_scrollView addSubview:_lastView];
    }

    return self;
}


- (CGFloat)viewWidth
{
    return self.bounds.size.width;
}

- (CGFloat)viewHeight
{
    return self.bounds.size.height;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"AddBannerView initWithCoder");
    self = [super initWithCoder:aDecoder];

    if (self)
    {
        _viewWidth = self.bounds.size.width;
        _viewHeight = self.bounds.size.height;


        //设置scrollview
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(_viewWidth * 3, _viewHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];


        //设置分页
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _viewHeight - 30, _viewWidth, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [Utils getColorByRGB:TITLE_COLOR];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];

        //设置单击手势
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:_tap];


        _firstView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        _middleView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth, 0, _viewWidth, _viewHeight)];
        _lastView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth * 2, 0, _viewWidth, _viewHeight)];

        _firstView.contentMode = UIViewContentModeCenter;
        _middleView.contentMode = UIViewContentModeCenter;
        _lastView.contentMode = UIViewContentModeCenter;

        _firstView.backgroundColor = [UIColor blueColor];
        _middleView.backgroundColor = [UIColor greenColor];
        _lastView.backgroundColor = [UIColor redColor];


        [_scrollView addSubview:_firstView];
        [_scrollView addSubview:_middleView];
        [_scrollView addSubview:_lastView];

        self.backgroundColor = [UIColor redColor];

    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

//    CGRect scrollFrame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
//    _scrollView.frame = scrollFrame;
//    
//    CGSize scrollContentSize = CGSizeMake(self.viewWidth * 3, self.viewHeight);
//    _scrollView.contentSize = scrollContentSize;
//    
//    
//    CGRect pageFrame = CGRectMake(0, self.viewHeight - 30, self.viewWidth, 30);
//    _pageControl.frame = pageFrame;
//    
//    CGRect firstFrame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
//    _firstView.frame = firstFrame;
//    
//    CGRect midFrame = CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight);
//    _middleView.frame = midFrame;
//    
//    CGRect lastFrame = CGRectMake(self.viewWidth * 2, 0, self.viewWidth, self.viewHeight);
//    _lastView.frame = lastFrame;

}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(didClickPage:url:)])
    {
        [_delegate didClickPage:self url:[[_arrayData objectAtIndex:_currentPage] getClickUrl]];
    }
}

- (void)setArrayData:(NSArray<id <AddBannerDataDelegate>> *)arrayData
{
    if (arrayData)
    {
        _arrayData = arrayData;
        _currentPage = 0;
        _pageControl.numberOfPages = _arrayData.count;

    }

    [self reloadData];
}

- (void)reloadData
{
    if (_arrayData.count < _currentPage + 1)
    {
        return;
    }

    if (0 == _currentPage)
    {
        [_firstView setImageWithURL:[NSURL URLWithString:[[_arrayData lastObject] getPicUrl]]];
        [_middleView setImageWithURL:[NSURL URLWithString:[[_arrayData objectAtIndex:_currentPage] getPicUrl]]];
        [_lastView setImageWithURL:[NSURL URLWithString:[[_arrayData objectAtIndex:_currentPage + 1] getPicUrl]]];

    }
    else if (_currentPage == _arrayData.count - 1)
    {
        [_firstView setImageWithURL:[NSURL URLWithString:[[_arrayData objectAtIndex:_currentPage - 1] getPicUrl]]];
        [_middleView setImageWithURL:[NSURL URLWithString:[[_arrayData objectAtIndex:_currentPage] getPicUrl]]];
        [_lastView setImageWithURL:[NSURL URLWithString:[[_arrayData firstObject] getPicUrl]]];

    }
    else
    {
        [_firstView setImageWithURL:[NSURL URLWithString:[[_arrayData objectAtIndex:_currentPage - 1] getPicUrl]]];
        [_middleView setImageWithURL:[NSURL URLWithString:[[_arrayData objectAtIndex:_currentPage] getPicUrl]]];
        [_lastView setImageWithURL:[NSURL URLWithString:[[_arrayData objectAtIndex:_currentPage + 1] getPicUrl]]];
    }

    _pageControl.currentPage = _currentPage;

    _scrollView.contentOffset = CGPointMake(_viewWidth, 0);

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_autoScrollTimer invalidate];
    _autoScrollTimer = nil;
    _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                                      selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];

    //得到当前页数
    CGFloat x = _scrollView.contentOffset.x;

    //往前翻
    if (x <= 0)
    {
        if (_currentPage - 1 < 0)
        {
            _currentPage = _arrayData.count - 1;
        }
        else
        {
            _currentPage--;
        }
    }

    //往前翻
    if (x >= _viewWidth * 2)
    {
        if (_currentPage == _arrayData.count - 1)
        {
            _currentPage = 0;
        }
        else
        {
            _currentPage++;
        }
    }

    [self reloadData];
}


- (void)shouldAutoShow:(BOOL)shouldStart
{
    if (shouldStart)
    {
        if (!_autoScrollTimer)
        {
            _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                                              selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];

        }
    }
    else
    {
        if (_autoScrollTimer.isValid)
        {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
    }
}

- (void)autoShowNextImage
{
    if (_currentPage == _arrayData.count - 1)
    {
        _currentPage = 0;
    }
    else
    {
        _currentPage++;
    }

    [self reloadData];
}

@end
