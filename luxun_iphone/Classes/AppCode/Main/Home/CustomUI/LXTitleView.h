//
//  LXTieleView.h
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXTitleView : UIView

@property (nonatomic, strong) UITabBarController * rootViewController;
@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setButtons:(NSArray *)titles;

@end
