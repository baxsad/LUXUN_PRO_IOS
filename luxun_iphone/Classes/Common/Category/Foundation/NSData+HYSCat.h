//
//  NSData+HYSCat.h
//  iUR_Util
//
//  Created by iURCoder on 11/11/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HYSCat)
/**
 * @brief  对 data 数据进行 MD5 加密
 * @return 返回加密后的数据
 */
- (NSData*)MD5;
/**
 * @brief  data 数据转换为 base64 字符串
 * @return 返回 base64 字符串
 */
- (NSString *)base64EncodedString;
/**
 * @brief  base64 字符串 数据转换为 data
 * @return 返回 data 数据
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;
/**
 * @brief  json data 转换为对象
 * @return 返回数组或者字典
 */
- (id)jsonValueDecoded;
/**
 * @brief  data 转换为 utf－8 字符串
 * @return 返回 utf－8 字符串
 */
- (NSString *)utf8String;

@end
