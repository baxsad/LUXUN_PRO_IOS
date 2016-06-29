//
//  2HHomeViewController.m
//  2HUO
//
//  Created by iURCoder on 3/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXMainScene.h"
#import "IHNavigationController.h"

#import "LXMineScene.h"
#import "LXHomeScene.h"
#import "LXTimeLineScene.h"
#import "LXSquareScene.h"

@interface LXMainScene ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UIView * colorFullView;

@end

@implementation LXMainScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.tabBar.translucent = NO;
    self.selectedIndex = 0;
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    [[UITextField appearance] setTintColor:UIColorHex(0xffb6b6)];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [self addAllChildViewControllers];
    
    self.colorFullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, self.tabBar.bounds.size.height)];
    self.colorFullView.backgroundColor = [UIColor whiteColor];
    
    [self.tabBar addSubview:self.colorFullView];
    
    [[self class] customizeTabBarAppearance];
    
    self.tabBar.hidden = YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = self.selectedIndex;
    self.colorFullView.frame = CGRectMake(index*(SCREEN_WIDTH/3), 0, SCREEN_WIDTH/3, self.tabBar.bounds.size.height);
}

- (void)addAllChildViewControllers
{
    LXMineScene * mine = [[LXMineScene alloc] init];
    [self addChildViewController:mine title:nil image:nil selectedImage:nil];
    
    LXHomeScene * home = [[LXHomeScene alloc] init];
    [self addChildViewController:home title:nil image:nil selectedImage:nil];
    
    LXTimeLineScene * timeLine = [[LXTimeLineScene alloc] init];
    [self addChildViewController:timeLine title:nil image:nil selectedImage:nil];
    
    LXSquareScene * square = [[LXSquareScene alloc] init];
    [self addChildViewController:square title:nil image:nil selectedImage:nil];
}


- (void)addChildViewController:(UIViewController *)childController
                         title:(NSString *)title
                         image:(NSString *)normalImageName
                 selectedImage:(NSString *)selectedImageName
{
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        childController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childController.tabBarItem.selectedImage = selectedImage;
    }
    
    childController.title = title;
    [self addChildViewController:childController];
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
+ (void)customizeTabBarAppearance {
    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBarTintColor:NAVCOLOR];
    
    UIImage * topLineImage = [UIImage imageWithColor:UIColorHex(0xF9F7F4) size:CGSizeMake(1/SCREEN_SCALE, 1/SCREEN_SCALE)];
    [[UITabBar appearance] setShadowImage:topLineImage];
    
    
    // 普通状态下的文字属性
    NSDictionary *normalAttrs = @{NSForegroundColorAttributeName: UIColorHex(0x888888)};
    
    // 选中状态下的文字属性
    NSDictionary *selectedAttrs = @{NSForegroundColorAttributeName: UIColorHex(0xD2B203)};//255fff
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [tabBar setTitlePositionAdjustment:UIOffsetMake(2, -2)];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
