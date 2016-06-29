//
//  UITableViewCell+HYSCat.h
//  2HUO
//
//  Created by iURCoder on 3/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (HYSCat)
- (void)setCustomSeparatorInset:(CGFloat)value;
- (void)setCustomSeparatorInsetLeftValue:(CGFloat)leftValue rightValue:(CGFloat)rightValue;
- (void)setDefauleSeparatorInset;
- (void)setFillSeparatorInset;
- (void)setWithoutSeparator;
@end
