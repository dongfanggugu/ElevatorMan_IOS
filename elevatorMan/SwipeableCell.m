//
//  SwipeableCell.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/10.
//
//

#import <Foundation/Foundation.h>
#import "SwipeableCell.h"

static CGFloat const kBounceValue = 20.0f;

@interface SwipeableCell()

@end

@implementation SwipeableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.myContentView addGestureRecognizer:self.panRecognizer];
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRight.constant;
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            
            BOOL panningLeft = NO;
            
            if (currentPoint.x < self.panStartPoint.x) {
                
                //向左滑动时，显示按钮，用来解决当选择时，上层view透明导致按钮会显示出来的问题
                [self setButtonVisible:YES];
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) {
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0);
                    
                    if (0 == constant) {
                        [self resetConstraintsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRight.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRight.constant = constant;
                    }
                }
            } else {
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0);
                    
                    if (0 == constant) {
                        [self resetConstraintsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRight.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]);
                    
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRight.constant = constant;
                    }
                }
            }
            self.contentViewLeft.constant = -self.contentViewRight.constant;
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            CGFloat halfOfButton = [self buttonTotalWidth] / 2;
            if (self.contentViewRight.constant >= halfOfButton) {
                
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            } else {
                
                [self resetConstraintsToZero:YES notifyDelegateDidClose:YES];
            }
        }
            
            //            if (self.startingRightLayoutConstraintConstant == 0) {
            //
            //
            //            } else {
            //
            //                CGFloat buttonOnePlusHalfOfButton2 = 75;
            //                //4
            //                if (self.contentViewRight.constant >= buttonOnePlusHalfOfButton2) {
            //                    //5
            //
            //                    //Re-open all the way
            //                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            //                } else {
            //
            //                    //Close
            //                    [self resetConstraintsToZero:YES notifyDelegateDidClose:YES];
            //                }
            //            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            
            if (self.startingRightLayoutConstraintConstant == 0) {
                
                [self resetConstraintsToZero:YES notifyDelegateDidClose:YES];
            } else {
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
            
        default:
            break;
    }
}

- (void)resetConstraintsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)endEditing {
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRight.constant == 0) {
        
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRight.constant = -kBounceValue;
    self.contentViewLeft.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRight.constant = 0;
        self.contentViewLeft.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRight.constant;
        }];
    }];
    
    //恢复状态时，隐藏按钮,用来解决当选择时，上层view透明导致按钮会显示出来的问题
    [self setButtonVisible:NO];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth]
        && self.contentViewRight.constant == [self buttonTotalWidth]) {
        return;
    }
    
    self.contentViewLeft.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRight.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewLeft.constant = -[self buttonTotalWidth];
        self.contentViewRight.constant = [self buttonTotalWidth];
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRight.constant;
        }];
    }];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self resetConstraintsToZero:NO notifyDelegateDidClose:NO];
}

- (CGFloat)buttonTotalWidth {
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.btnEdit.frame);
}

- (void)setSwipeable:(BOOL)swipeable {
    if (swipeable) {
        [self.myContentView addGestureRecognizer:self.panRecognizer];
    } else {
        [self.myContentView removeGestureRecognizer:self.panRecognizer];
    }
}

- (void)setButtonVisible:(BOOL)visible {
    if (visible) {
        self.btnEdit.hidden = NO;
        self.btnDel.hidden = NO;
    } else {
        self.btnEdit.hidden = YES;
        self.btnDel.hidden = YES;
    }
}

/**
 按钮点击的回调
 **/
- (IBAction)buttonClicked:(id)sender {
    
    if (sender == self.btnEdit) {
        [self.swipeableCellDelegate buttonClicked:@"edit" tag:self.btnEdit.tag];
    } else if (sender == self.btnDel) {
        [self.swipeableCellDelegate buttonClicked:@"del" tag:self.btnDel.tag];
    }
}

@end
