//
//  NSDate+HYSCat.h
//  BiHu_iPhone
//
//  Created by iURCoder on 11/23/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , LogType) {
    LogStringType = 77,
    LogCGfloatType,
    LogNumberType
};

@interface NSDate (HYSCat)
@property (nonatomic, assign) NSString * diff;
/**
 * @brief  日期转字符串
 * @return 时间字符串
 */
- (NSString *)dateToString;
/**
 * @brief  根据日期格式化方式,把日期转字符串
 * @return 时间字符串
 */
- (NSString *)dateToStringWithFormatterType:(NSString *)type;
/**
 * @brief  获取系统当前的时间
 * @return 时间
 */
+ (NSDate *)systemDate;
/**
 * @brief  获取系统当前的时间的时间戳
 * @return 时间戳
 */
+ (NSString *)systemTimeStamp;
/**
 * @brief  日期转换为时间戳
 * @return 时间戳
 */
- (NSString *)dateToTimeStamp;
/**
 * @brief  比较两个时间的时间差
 * @return 时间
 */
- (NSDate * (^)(NSDate*))equalTo;
/**
 * @brief  比较两个时间的时间差
 * @return 秒字符串
 */
- (NSString *)diffString;
/**
 * @brief  比较两个时间的时间差
 * @return 秒float类型
 */
- (CGFloat   )diffFloat;
/**
 * @brief  比较两个时间的时间差
 * @return 秒number类型
 */
- (NSNumber *)diffNumber;

@end
