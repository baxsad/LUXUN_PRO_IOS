//
//  UIButton+IHBarButton.m
//  BiHu_iPhone
//
//  Created by iURCoder on 11/14/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "UIButton+IHBarButton.h"
#import "WrSystemInfo.h"


#undef NAV_BUTTON_MIN_WIDTH
#define NAV_BUTTON_MIN_WIDTH (40.0f)

#undef NAV_BUTTON_MIN_HEIGHT
#define NAV_BUTTON_MIN_HEIGHT (40.0f)

#undef NAV_BAR_HEIGHT
#define NAV_BAR_HEIGHT (44.0f)

@implementation UIButton (IHBarButton)

- (UIButton *)initNavigationButton:(UIImage *)image {
    CGRect buttonFrame = CGRectZero;
    
    if (IOS7_OR_LATER) {
        buttonFrame = CGRectMake(0, 0, image.size.width, NAV_BAR_HEIGHT);
    } else {
        buttonFrame = CGRectMake(0, 0, image.size.width + 10.0f, NAV_BAR_HEIGHT);
    }
    if (buttonFrame.size.width < NAV_BUTTON_MIN_WIDTH) {
        buttonFrame.size.width = NAV_BUTTON_MIN_WIDTH;
    }
    
    if (buttonFrame.size.height < NAV_BUTTON_MIN_HEIGHT) {
        buttonFrame.size.height = NAV_BUTTON_MIN_HEIGHT;
    }
    self = [self initWithFrame:buttonFrame];
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor clearColor];
    [self setImage:image forState:UIControlStateNormal];
    return self;
}
- (UIButton *)initNavigationButtonWithTitle:(NSString *)str
                                      color:(UIColor *)color {
    CGRect buttonFrame = CGRectZero;
    
    CGSize titleSize =
    [str boundingRectWithSize:CGSizeMake(999999.0f, NAV_BAR_HEIGHT)
                      options:NSStringDrawingUsesLineFragmentOrigin
                   attributes:@{
                                NSFontAttributeName : [UIFont boldSystemFontOfSize:16]
                                } context:nil].size;
    
    if (IOS7_OR_LATER) {
        buttonFrame = CGRectMake(0, 0, titleSize.width, NAV_BAR_HEIGHT);
    } else {
        buttonFrame = CGRectMake(0, 0, titleSize.width + 10.0f, NAV_BAR_HEIGHT);
    }
    
    self = [self initWithFrame:buttonFrame];
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitle:str forState:UIControlStateNormal];
    return self;
}


@end
