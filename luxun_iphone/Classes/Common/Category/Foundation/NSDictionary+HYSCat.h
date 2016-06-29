//
//  Created by iURCoder on 11/11/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HYSCat)

- (id)objectAtPath:(NSString*)path;
/**
 * @brief  将字典拼装成 GET 请求的字符串
 * @return 返回拼装后字符串
 */
- (NSString*)joinToPath;
/**
 * @brief  输出字典的键值对
 * @return 返回对象本身
 */
- (NSDictionary*)each:(void (^)(id key, id value))block;
#pragma mark - Dictionary Convertor
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 通过 plist 数据创建一个字典
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 */
+ (NSDictionary *)dictionaryWithPlistData:(NSData *)plist;

/**
 通过 plist 字符串创建一个字典
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (NSDictionary *)dictionaryWithPlistString:(NSString *)plist;

/**
 序列化为二进制属性列表的数据字典。
 
 @return A bplist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (NSData *)plistData;
/**
 序列化的XML属性列表的字符串字典。
 
 @return A plist xml string, or nil if an error occurs.
 */
- (NSString *)plistString;
/**
 字典是否包含某个对象
 @param key The key.
 */
- (BOOL)containsObjectForKey:(id)key;
/**
 字典转换为 json
 */
- (NSString *)jsonStringEncoded;

/**
 字典转换为格式化 json
 */
- (NSString *)jsonPrettyStringEncoded;
/**
 xml 转换为字典
 @param xmlDataOrString xml data 或者 string.
 @return 返回一个新的字典
 */
+ (NSDictionary *)dictionaryWithXML:(id)xmlDataOrString;

@end

/**
 可变字典
 */
@interface NSMutableDictionary (HYSCat)

/**
 通过 plist 数据创建一个字典
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (NSMutableDictionary *)dictionaryWithPlistData:(NSData *)plist;

/**
 通过 plist 字符串创建一个字典
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (NSMutableDictionary *)dictionaryWithPlistString:(NSString *)plist;


/**
 移除并返回给定的键关联的值。
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (id)popObjectForKey:(id)aKey;


@end


