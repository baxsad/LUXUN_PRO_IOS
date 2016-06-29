//
//  UIImage+HYSCat.h
//  BiHu_iPhone
//
//  Created by iURCoder on 1/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYSCat)
/**
 *  图片变为灰色
 */
- (UIImage *)toGrayscale;
/**
 *  图片着色
 *
 *  @param color  颜色.
 */
- (UIImage *)tintWithColor:(UIColor *)tintColor;
/**
 *  根据一个url返回一个图片
 *
 *  @param color  图片路径.
 */
+ (UIImage *)imageWithUrl:(NSString *)url;
/**
 *  返回一个1x1像素的图片
 *
 *  @param color  The color.
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  返回一个图片
 *
 *  @param color  图片颜色.
 *
 *  @param size  图片大小.
 */
+ (UIImage *)imageWithColor:( UIColor  *)color size:( CGSize )size;
/**
 *  按比例缩放到最大
 */
- (UIImage *)imageByScalingToMaxSize;
/**
 *  按比例缩放
 */
- (UIImage *)imageByScalingAndCroppingToSize:(CGSize)targetSize;
/**
 *  图片高亮
 */
-(UIImage*)applyLightEffect;
/**
 *  图片高亮
 */
-(UIImage*)applyExtraLightEffect;
/**
 *  图片应用暗效果
 */
-(UIImage*)applyDarkEffect;
-(UIImage*)applyTintEffectWithColor:(UIColor*)tintColor;
-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;
+ (UIImage *) imageFromData: (NSString *) imgSrc;
- (BOOL) imageHasAlpha;
- (NSString *)image2DataURL;
- (BOOL)imageSaveToDirectory:(NSString *)directory;
//等比压缩图片
+ (UIImage *)imageWithMaxSide:(CGFloat)length sourceImage:(UIImage *)image;
-(UIImage*)getSubImage:(CGRect)rect;
/**
 给图片设置一个圆角
 
 @param radius  每个角点的半径。值大于一半长方形的宽度或高度适当的一半宽度或高度。
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

/**
 给图片设置一个圆角
 
 @param radius       每个角点的半径。值大于一半长方形的宽度或高度适当的一半宽度或高度。
 
 @param borderWidth  插图边框线宽度。值大于半矩形的宽度或高度适当的半宽度或者高度
 
 @param borderColor  边框笔画颜色。零意味着无色。
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;

/**
 给图片设置一个圆角
 
 @param radius       每个角点的半径。值大于一半长方形的宽度或高度适当的一半宽度或高度。
 
 @param corners      A bitmask value that identifies the corners that you want
 rounded. You can use this parameter to round only a subset
 of the corners of the rectangle.
 
 @param borderWidth  插图边框线宽度。值大于半矩形的宽度或高度适当的半宽度或者高度
 
 @param borderColor  边框笔画颜色。零意味着无色。
 
 @param borderLineJoin The border line join.
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;

- (UIImage *)imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

- (NSString *)bytes;

@end
