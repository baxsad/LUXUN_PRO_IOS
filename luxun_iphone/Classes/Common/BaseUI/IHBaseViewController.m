//
//  IHBaseViewController.m
//  BiHu_iPhone
//
//  Created by iURCoder on 11/14/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "IHBaseViewController.h"
#import "WrSystemInfo.h"
#import "UIButton+IHBarButton.h"

@implementation IHBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorHex(0xf2f2f2)];
    if (!IOS7_OR_LATER) {
        // support full screen on iOS 6
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)showBarButton:(IHNavigationBar)position
                title:(NSString*)name
            fontColor:(UIColor*)color
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5;//右边距
    if (NAV_LEFT == position) {
        UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonTouch)];
        [barbutton setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = @[fixedSpace,barbutton];
        if (IOS7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if (NAV_RIGHT == position) {
        UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonTouch)];
        [barbutton setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems =@[fixedSpace,barbutton];
    }
    
}
- (void)showBarButton:(IHNavigationBar)position
            imageName:(NSString*)imageName
{
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5;//右边距
    if (NAV_LEFT == position) {
        UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonTouch)];
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = @[fixedSpace,barbutton];
        if (IOS7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if (NAV_RIGHT == position) {
        UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonTouch)];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[fixedSpace,barbutton];
    }
}

- (void)showBarButton:(IHNavigationBar)position button:(UIButton*)button
{
    if (NAV_LEFT == position) {
        [button addTarget:self
                   action:@selector(leftButtonTouch)
         forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithCustomView:button];
        if (IOS7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if (NAV_RIGHT == position) {
        [button addTarget:self
                   action:@selector(rightButtonTouch)
         forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)setTitleView:(UIView*)titleView
{
    self.navigationItem.titleView = titleView;
}
- (void)setTitle:(NSString*)title font:(UIFont*)font fontColor:(UIColor*)color
{
    UILabel* laber = [[UILabel alloc] init];
    laber.text = title;
    laber.textAlignment = NSTextAlignmentCenter;
    laber.font = font;
    laber.textColor = color;
    [laber sizeToFit];
    [self setTitleView:laber];
}
- (void)leftButtonTouch
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonTouch
{
    
}
- (void)setRightImage:(NSString *)imageName{
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonTouch)];
}


@end
