//
//  AboutViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/6.
//
//

#import <Foundation/Foundation.h>
#import "AboutViewController.h"

@interface AboutViewController()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end


@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"关于"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = version;
}

@end
