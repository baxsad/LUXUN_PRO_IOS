//
//  NSString+HYSCat.h
//  iUR_Util
//
//  Created by iURCoder on 11/11/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const NSInteger SECOND;
extern const NSInteger MINUTE;
extern const NSInteger HOUR;
extern const NSInteger DAY;
extern const NSInteger WEEK;
extern const NSInteger MONTH;
extern const NSInteger YEAR;

@interface NSString (HYSCat)
@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

/**
 * @brief  字符串进行 MD5 加密
 * @return 小写字符的加密字符串
 */
- (NSString *)md5;
/**
 * @brief  字符串进行 MD5 加密
 * @return 大写字符的加密字符串
 */
- (NSString*)MD5;
/**
 * @brief  返回一个NSString base64编码。
 * @param  text 需要转换的字符串
 * @return base64格式字符串
 */
- (NSString *)BASE64;
/**
 * @brief  将base64格式字符串转换为字符串
 * @param  base64 需要转换的base64格式字符串
 * @return 转换结果字符串
 */
- (NSString *)unBASE64;
/**
 * @brief  判断字符串是否为手机号
 * @return 是电话类型返回 yes 否返回 no
 */
- (BOOL)isTelephone;
/**
 * @brief  是否是密码6~20，字母数字
 * @return 是密码类型返回 yes 否返回 no
 */
- (BOOL)isPassword;
/**
 * @brief  把字符串(yyyy-MM-dd HH:mm:ss)转换成日期
 * @return 时间
 */
- (NSDate *)stringToDate;
/**
 * @brief  根据日期格式化方式,把字符串转换成日期（date）
 * @return 时间
 */
- (NSDate *)stringToDateWithFormatterType:(NSString *)type;
/**
 * @brief  判断是否是邮箱
 * @return 是密码类型返回 yes 否返回 no
 */
- (BOOL)isEmail;
/**
 * @brief  解码 json 数据，返回一个 NSArray/NSDictionary 如果发生错误，返回零。
 * @return 时间字符串
 */
- (id)jsonValueDecoded;
/**
 * @brief  字符串转换为 data 数据
 * @return data
 */
- (NSData *)dataValue;
/**
 URL编码UTF-8字符串。
 @return 编码后的字符串.
 */
- (NSString *)stringByURLEncode;
/**
 URL解码UTF-8字符串。
 @return 解码后的字符串.
 */
- (NSString *)stringByURLDecode;
/**
 字符串转换为 html 的编码
 @return 编码后的字符串.（"a<b" will be escape to "a&lt;b".）
 */
- (NSString *)stringByEscapingHTML;
/**
 根据字体及大小，和 NSLineBreakMode 计算字符串的大小
 @return 字符串的大小
 */
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
/**
 根据字体类型返回字符串的 width
 @return 字符串的宽度
 */
- (CGFloat)widthForFont:(UIFont *)font;
/**
 根据字体型号，lable 宽度返回字符串的高度
 @return 字符串的高度
 */
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

- (NSArray *)apiStringToArray;


#pragma mark - NSNumber Compatible
///=============================================================================
/// @name NSNumber Compatible
///=============================================================================

// Now you can use NSString as a NSNumber.
@property (readonly) char charValue;
@property (readonly) unsigned char unsignedCharValue;
@property (readonly) short shortValue;
@property (readonly) unsigned short unsignedShortValue;
@property (readonly) unsigned int unsignedIntValue;
@property (readonly) long longValue;
@property (readonly) unsigned long unsignedLongValue;
@property (readonly) unsigned long long unsignedLongLongValue;
@property (readonly) NSUInteger unsignedIntegerValue;
/**
 字符串转换为 NSNumber
 @return NSNumber 数据
 */
- (NSNumber *)numberValue;
/**
 去掉特殊符号，空格
 @return 过滤后的字符串
 */
- (NSString *)stringByTrim;
/**
 转换为utf－8
 @return 过滤后的字符串
 */
- (NSString *)utf8String;
/**
 去除字符串中的 html 
 @return 过滤后的字符串
 */
- (NSString*)stripHtml;

+ (NSString *)stringWithUUID;
/**
 *  匹配URL
 *
 *  @return YES 成功 NO 失败
 */
- (BOOL)isUrl;

#pragma mark - 计算字符串尺寸
/**
 *  计算字符串高度 （多行）
 *
 *  @param width 字符串的宽度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
- (CGSize)heightWithWidth:(CGFloat)width andFont:(CGFloat)font;

/**
 *  计算字符串宽度
 *
 *  @param height 字符串的高度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
- (CGSize)widthWithHeight:(CGFloat)height andFont:(CGFloat)font;

/**
 *  检测是否含有某个字符
 *
 *  @param string 检测是否含有的字符
 *
 *  @return YES 含有 NO 不含有
 */
- (BOOL)containString:(NSString *)string;
/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
+ (NSString*)deviceVersion;

- (NSString *)timeAgo;
@end
