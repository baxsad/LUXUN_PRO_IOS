//
//  IHUINavigationController.m
//  BiHu_iPhone
//
//  Created by iURCoder on 11/14/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "IHNavigationController.h"

@interface IHNavigationController () <UINavigationControllerDelegate,
UIGestureRecognizerDelegate>
@end

@implementation IHNavigationController

+(void)initialize{
    
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:UIColorHex(0x333333)};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    UIImage *backButtonImage = [[UIImage imageNamed:@"lx_player_back"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    backButtonImage = [backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [UINavigationBar appearance].layer.opacity = 1;
    [[UINavigationBar appearance] setBarTintColor:TEMCOLOR];
    [[UINavigationBar appearance] setTintColor:UIColorHex(0xF9F7F4)];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationBar.translucent = NO;
    __weak IHNavigationController* weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController*)viewController
                  animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController*)navigationController
       didShowViewController:(UIViewController*)viewController
                    animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        
        if (navigationController.viewControllers.count == 1) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }else{
            self.interactivePopGestureRecognizer.enabled = YES;
            if ([viewController.class isSubclassOfClass:NSClassFromString(@"ILGuideScene")]) {
                self.interactivePopGestureRecognizer.enabled = NO;
            }
            
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
