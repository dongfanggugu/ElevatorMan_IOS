//
//  SideMenu.h
//  elevatorMan
//
//  Created by Cove on 15/6/5.
//
//

#import <UIKit/UIKit.h>

@interface SideMenu : UIViewController

@property (nonatomic, readwrite,strong) UIViewController *contentController;
@property (nonatomic, readwrite,strong) UIViewController *menuController;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) BOOL tapGestureEnabled;
@property (nonatomic, assign) BOOL panGestureEnabled;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

- (id)initWithContentController:(UIViewController*)contentController
                 menuController:(UIViewController*)menuController;

- (void)setContentController:(UIViewController*)contentController
                    animated:(BOOL)animated;

// show / hide manually
- (void)showMenuAnimated:(BOOL)animated;
- (void)hideMenuAnimated:(BOOL)animated;
- (BOOL)isMenuVisible;

// background
- (void)setBackgroundImage:(UIImage*)image;

@end

