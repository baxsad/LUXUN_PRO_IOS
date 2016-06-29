//
//  UIButton+IHBarButton.h
//  BiHu_iPhone
//
//  Created by iURCoder on 11/14/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (IHBarButton)
-(UIButton *)initNavigationButton:(UIImage *)image;
-(UIButton *)initNavigationButtonWithTitle:(NSString *)str color:(UIColor *)color;
@end
