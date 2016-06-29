//
//  NSObject+HYSCat.h
//  iUR_Util
//
//  Created by iURCoder on 11/11/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define keyPath(...) \
metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(keyPath1(__VA_ARGS__))(keyPath2(__VA_ARGS__))

#define keyPath1(PATH) \
(((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))

#define keyPath2(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

#define HYSObserve(TARGET, KEYPATH) \
({ \
__weak id target_ = (TARGET); \
[target_ hys_addObserver:target_ forKeyPath:@keypath(TARGET, KEYPATH)]; \
})

/**
 * Common tasks for NSObject.
 */
@interface NSObject (HYSCat)


- (instancetype)hys_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

- (void)subNext:(void (^)(id x))nextBlock;


#pragma mark - 判断一个对象是否为空
///=============================================================================
/// @name 用来判断一个对象是否为空
///=============================================================================

-(BOOL)isNotEmpty;

#pragma mark - 多参的方式给对象发送消息
///=============================================================================
/// @name 多参的方式给对象发送消息
///=============================================================================

/**
 发送一个指定的消息到接收者，然后返回该消息的结果。
 
 @param sel    通过方法选择器给对象发送消息。如果为空或无法识别，则会抛出异常。
 
 @param ...    变量参数列表。参数类型必须对应于选择器的方法声明，或可能出现的异常。
 
 @return       消息返回的一个对象
 
 @discussion   如果返回类型不是对象，返回值将被包装为NSNumber或NSValue。如果选择器的返回类型无效，它总是返回零
 
 Sample Code:
 
 [view performSelectorWithArgs:@selector(removeFromSuperView)];
 
 [view performSelectorWithArgs:@selector(setCenter:), CGPointMake(0, 0)];
 
 UIImage *image = [UIImage.class performSelectorWithArgs:@selector(imageWithData:scale:), data, 2.0];
 
 NSNumber *lengthValue = [@"hello" performSelectorWithArgs:@selector(length)];
 NSUInteger length = lengthValue.unsignedIntegerValue;
 
 NSValue *frameValue = [view performSelectorWithArgs:@selector(frame)];
 CGRect frame = frameValue.CGRectValue;
 */
- (id)performSelectorWithArgs:(SEL)sel, ...;

/**
 在当前线程延迟执行选择器方法
 
 @warning      它不能取消消息发送。
 
 @param sel    通过方法选择器给对象发送消息。如果为空或无法识别，则会抛出异常。
 
 @param delay  消息延迟发送的最短时间，0并不代表立马执行，因为线程仍在排队执行
 
 @param ...    如果返回类型不是对象，返回值将被包装为NSNumber或NSValue。如果选择器的返回类型无效，它总是返回零
 
 Sample Code:
 
 [view performSelectorWithArgs:@selector(removeFromSuperView) afterDelay:2.0];
 
 [view performSelectorWithArgs:@selector(setCenter:), afterDelay:0, CGPointMake(0, 0)];
 */
- (void)performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...;

/**
 在后台执行方法
 
 @param sel    通过方法选择器给对象发送消息。如果为空或无法识别，则会抛出异常。
 
 @param ...    变量参数列表。参数类型必须对应于选择器的方法声明，或可能出现的异常。
 
 @discussion   会创建一个新的线程来执行此方法
 
 Sample Code:
 
 [array  performSelectorWithArgsInBackground:@selector(sortUsingComparator:),
 ^NSComparisonResult(NSNumber *num1, NSNumber *num2) {
 return [num2 compare:num2];
 }];
 */
- (void)performSelectorWithArgsInBackground:(SEL)sel, ...;

#pragma mark - Runtime
/**
 交换两个实例方法的实现（谨慎使用）
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              交换成功返回 yes 失败返回 no
 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (void)iur_swizzleClassMethod:(Class)clas originSelector:(SEL)originSel with:(SEL)newSel;

/**
 交换两个类方法的实现（谨慎使用）
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              交换成功返回 yes 失败返回 no
 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;
+ (void)iur_swizzleInstanceMethod:(Class)clas originSelector:(SEL)originSel with:(SEL)newSel;

/**
 动态给类添加一个属性 （strong类型的）
 
 @param value   需要添加的对象
 @param key     关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
 */
- (void)setAssociateValue:(id)value withKey:(void *)key;

/**
 动态给类添加一个属性 （weak类型的）
 
 @param value  需要添加的对象
 @param key    关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
 */
- (void)setAssociateWeakValue:(id)value withKey:(void *)key;

/**
  获取相关联的对象
 
 @param 关键字是一个void类型的指针
 */
- (id)getAssociatedValueForKey:(void *)key;

/**
 移除关联对象
 */
- (void)removeAssociatedValues;


#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 返回一个类的字符串
 */
+ (NSString *)className;

/**
 返回一个类的字符串
 */
- (NSString *)className;

@end
