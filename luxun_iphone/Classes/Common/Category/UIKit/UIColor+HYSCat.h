//
//  UIColor+HYSCat.h
//  iUR_Util
//
//  Created by iURCoder on 11/11/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HYSCat)


#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

#define ONE_PX 1.0 / [UIScreen mainScreen].scale

#pragma mark - Create a UIColor Object

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue;

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexStr;

- (uint32_t)rgbValue;

- (NSString *)hexString;

- (NSString *)hexStringWithAlpha;

@property (nonatomic, readonly) CGFloat alpha;

@end
