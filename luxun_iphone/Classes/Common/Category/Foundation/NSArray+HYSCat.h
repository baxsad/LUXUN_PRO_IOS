//
//  NSArray+HYSCat.h
//  iUR_Util
//
//  Created by iURCoder on 11/11/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HYSCat)

/**
 从指定的属性列表数据，创建并返回一个数组。
 
 @param plist   属性列表数据
 @return 返回一个新的数组数据
 */
+ (NSArray *)arrayWithPlistData:(NSData *)plist;

/**
 从指定的属性列表的字符串，创建并返回一个数组。
 
 @param plist   一个属性列表的 xml 字符串
 @return 返回一个新的数组数据
 */
+ (NSArray *)arrayWithPlistString:(NSString *)plist;

/**
 把一个数组序列化为一个属性列表数据
 
 @return 一个 plist 数据，错误或零。
 */
- (NSData *)plistData;

/**
 把一个数组转换为 xml 字符串格式的属性列表数据
 
 @return 一个 plist 字符串数据，错误或零。
 */
- (NSString *)plistString;

/**
 返回位于随机索引的对象。
 
 @return 具有随机索引值的数组中的对象。
 如果数组是空的，返回零。
 */
- (id)randomObject;

/**
 返回位于索引处的对象，或在边界时返回零。
 它类似于` objectatindex：`，但它不会抛出异常。
 
 @param 索引下标
 */
- (id)objectOrNilAtIndex:(NSUInteger)index;

/**
 对象转换为JSON字符串。如果发生错误，返回零。
 NSString NSArray NSDictionary NSNumber / / /
 */
- (NSString *)jsonStringEncoded;

/**
 对象转换为JSON字符串格式化。如果发生错误，返回零。
 */
- (NSString *)jsonPrettyStringEncoded;

/**
 将数组按照首字母排序
 */
- (NSArray *)sortedArrayByWord;
/**
 数组转化为字符串
 */
- (NSString *)arrayToString;
@end

@interface NSMutableArray (YYAdd)

/**
 创建并返回一个数组，从指定的属性列表数据。
 
 @param plist   属性列表数据
 @return 返回一个新的数组数据
 */
+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist;

/**
 从指定的属性列表的字符串，创建并返回一个数组。
 
 @param plist   一个属性列表的 xml 字符串
 @return 返回一个新的数组数据
 */
+ (NSMutableArray *)arrayWithPlistString:(NSString *)plist;

/**
 移除数组中的最小值索引的对象。
 如果数组是空的，该方法没有效果。
 
 @discussion 苹果已经实施了这种方法，但并没有使它成为公众。
 覆盖安全。
 */
- (void)removeFirstObject;

/**
 移除数组中的最高值索引的对象。
 如果数组是空的，该方法没有效果。
 
 @discussion 苹果表示，它提出了一个实现nsrangeexception如果
 数组是空的，但事实上没有什么会发生。覆盖安全。
 */
- (void)removeLastObject;

/**
 删除并返回数组中的最小值索引的对象。
 如果数组是空的，它只返回零。
 
 @return 对象，或为零。
 */
- (id)popFirstObject;

/**
 删除并返回数组中的最高值索引的对象。
 如果数组是空的，它只返回零。
 
 @return 对象，或为零。
 */
- (id)popLastObject;

/**
 在数组的末端插入一个给定的对象。
 
 @param 添加的对象，不能为 null
 */
- (void)appendObject:(id)anObject;

- (void)reverse;
@end
