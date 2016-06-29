//
//  UITableViewCell+HYSCat.m
//  2HUO
//
//  Created by iURCoder on 3/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "UITableViewCell+HYSCat.h"

@implementation UITableViewCell (HYSCat)
- (void)setCustomSeparatorInset:(CGFloat)value{
    [self setCustomSeparatorInsetLeftValue:value rightValue:value];
}
- (void)setCustomSeparatorInsetLeftValue:(CGFloat)leftValue rightValue:(CGFloat)rightValue{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, leftValue, 0, rightValue)];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) { //ios 8
        [self setLayoutMargins:UIEdgeInsetsMake(0, leftValue, 0, rightValue)];
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.preservesSuperviewLayoutMargins = false;
    }
    
}
- (void)setDefauleSeparatorInset
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) { //ios 8
        [self setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.preservesSuperviewLayoutMargins = false;
    }
}
- (void)setWithoutSeparator
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 1000, 0, 0)];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsMake(0, 1000, 0, 0)];
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.preservesSuperviewLayoutMargins = false;
    }
}
- (void)setFillSeparatorInset
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.preservesSuperviewLayoutMargins = false;
    }
}

@end
