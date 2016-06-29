//
//  IHBaseViewController.h
//  BiHu_iPhone
//
//  Created by iURCoder on 11/14/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NAV_LEFT  = 0,
    NAV_RIGHT = 1,
} IHNavigationBar;

@interface IHBaseViewController : UIViewController

- (void)showBarButton:(IHNavigationBar)position
                title:(NSString *)name
            fontColor:(UIColor *)color;
- (void)showBarButton:(IHNavigationBar)position
            imageName:(NSString *)imageName;
- (void)showBarButton:(IHNavigationBar)position
               button:(UIButton *)button;
- (void)setTitleView:(UIView *)titleView;
- (void)setTitle:(NSString *)title
            font:(UIFont *)font
       fontColor:(UIColor *)color;
- (void)setRightImage:(NSString *)imageName;
- (void)leftButtonTouch;
- (void)rightButtonTouch;

@end
