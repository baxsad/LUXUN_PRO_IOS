/**
 *
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */
//
//  GDRouter.h
//
//  Created by iURCoder on 3/21/16.
//  Copyright © 2016 iUR. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GDRouterReger.h"


@class UPRouter;

@interface NSString(GDExtent)

- (BOOL)isNotNull;

- (BOOL)isIncloud:(NSString *)str;

- (NSString *)GDMD5;

@end

/**
 *  过期提醒
 */
#define GDRouterDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

/**
 *  回调（定义）
 */
typedef void (^RouterComponentBlock)(NSDictionary *params);

/**
 *  模态跳转回调（定义）
 */
typedef void (^RouterCompletion)();

@interface UPRouter : NSObject

/**
 *  导航控制器（跳转的时候需要）
 */
@property (readwrite, nonatomic, strong) UINavigationController *navigationController;

/**
 *  控制器（模态跳转的时候需要）
 */
@property (readwrite, nonatomic, strong) UIViewController *controller;

/**
 *  如果设置为 YES 的话将会正常抛出异常
 */
@property (readwrite, nonatomic, assign) BOOL openException;

/**
 *  控制器返回操作，默认带动画效果（如果是模态跳转就 dismiss ，push 的话 就 pop）
 */
- (void)pop;

/**
 *  控制器返回操作，动画效果由参数决定（如果是模态跳转就 dismiss ，push 的话 就 pop）
 */
- (void)pop:(BOOL)animated;

/**
 *  通过 url 注册一个 block，open 的时候通过 url 影射到回调执行回调方法
 *
 *  @param url 传入格式 ( "app://users/?id=001" 或者 "app://logout")
 *
 *  @param callback 会在触发 open: 的时候执行
 */
- (void)reg:(NSString *)urlPattern toHandler:(RouterComponentBlock)callback;

/**
 *  通过 url 注册一个类，open 的时候通过类实例化对象执行 push 操作
 *
 *  @param url 传入格式 ( "app://users/?id=001" 或者 "app://logout")
 *
 *  @param cls 注册的类
 */
- (void)reg:(NSString *)urlPattern toClass:(Class)cls;

/**
 *  通过 url 注册一个类，open 的时候通过类实例化对象执行 push 操作
 *
 *  @param url 传入格式 ( "app://users/?id=001" 或者 "app://logout")
 *
 *  @param cls 注册的类
 *
 *  @param navcls 导航控制器类
 */
- (void)reg:(NSString *)urlPattern toClass:(Class)cls navClass:(Class)navcls;

/**
 *  通过 url 注册一个控制器对象，open 的时候通过此对象执行 push 操作
 *
 *  @param url 传入格式 ( "app://users/?id=001" 或者 "app://logout")
 *
 *  @param controller 注册的控制器对象
 */
- (void)reg:(NSString *)urlPattern toController:(UIViewController *)controller;

/**
 *  通过 url 注册一个控制器对象，open 的时候通过此对象执行 push 操作
 *
 *  @param url 传入格式 ( "app://users/?id=001" 或者 "app://logout")
 *
 *  @param controller 注册的控制器对象
 *
 *  @param navController 注册的导航控制器对象
 */
- (void)reg:(NSString *)urlPattern toController:(UIViewController *)controller navController:(UINavigationController *)navController;

/**
 *  一种使用'UIApplication'的'OpenURL:'打开URL方便的方法
 *
 *  @param url格式 (i.e. "http://google.com")
 */
- (void)openExternal:(NSString *)url;

/**
 *  触发一个 url 映射到 block 或者一个类或者一个控制器，执行 block 或者 present 到控制器，默认带动画效果
 *
 *  @param url 将会被打开
 *
 *  @param completion 跳转后的回调
 *
 *  @exception 如果 url 没有被影射到结果将会抛出异常
 *
 *  @exception 如果没有控制器将会抛出异常
 *
 *  @exception 如果没有获取到控制器对象将会抛出异常
 */
- (void)show:(NSString *)url completion:(RouterCompletion)completion;

/**
 *  触发一个 url 映射到 block 或者一个类或者一个控制器，执行 block 或者 present 到控制器，动画效果由参数决定
 *
 *  @param url 将会被打开
 *
 *  @param animated YES 时会有动画效果
 *
 *  @param completion 跳转后的回调
 *
 *  @exception 如果 url 没有被影射到结果将会抛出异常
 *
 *  @exception 如果没有控制器将会抛出异常
 *
 *  @exception 如果没有获取到控制器对象将会抛出异常
 */
- (void)show:(NSString *)url animated:(BOOL)animated completion:(RouterCompletion)completion;

/**
 *  触发一个 url 映射到 block 或者一个类或者一个控制器，执行 block 或者 present 到控制器，动画效果由参数决定
 *
 *  @param url 将会被打开
 *
 *  @param extraParams 跳转时传递的参数
 *
 *  @param completion 跳转后的回调
 *
 *  @exception 如果 url 没有被影射到结果将会抛出异常
 *
 *  @exception 如果没有控制器将会抛出异常
 *
 *  @exception 如果没有获取到控制器对象将会抛出异常
 */
- (void)show:(NSString *)url extraParams:(NSDictionary *)extraParams completion:(RouterCompletion)completion;

/**
 *  触发一个 url 映射到 block 或者一个类或者一个控制器，执行 block 或者 present 到控制器，动画效果由参数决定
 *
 *  @param url 将会被打开
 *
 *  @param animated YES 时会有动画效果
 *
 *  @param extraParams 跳转时传递的参数
 *
 *  @param completion 跳转后的回调
 *
 *  @exception 如果 url 没有被影射到结果将会抛出异常
 *
 *  @exception 如果没有控制器将会抛出异常
 *
 *  @exception 如果没有获取到控制器对象将会抛出异常
 */
- (void)show:(NSString *)url animated:(BOOL)animated extraParams:(NSDictionary *)extraParams completion:(RouterCompletion)completion;

/**
 *  触发一个 url 映射到 block 或者一个类或者一个控制器，执行 block 或者 push 到控制器，默认带动画效果
 *
 *  @param url 将会被打开
 *
 *  @exception 如果 url 没有被影射到结果将会抛出异常
 *
 *  @exception 如果没有导航控制器将会抛出异常
 *
 *  @exception 如果没有获取到控制器对象将会抛出异常
 */
- (void)open:(NSString *)url;

/**
 *  触发一个 url 映射到 block 或者一个类或者一个控制器，执行 block 或者 push 到控制器，动画效果由参数决定
 *
 *  @param url 将会被打开
 *
 *  @param animated YES 时会有动画效果
 *
 *  @exception 如果 url 没有被影射到结果将会抛出异常
 *
 *  @exception 如果没有导航控制器将会抛出异常
 *
 *  @exception 如果没有获取到控制器对象将会抛出异常
 */
- (void)open:(NSString *)url animated:(BOOL)animated;

/**
 *  触发一个 url 映射到 block 或者一个类或者一个控制器，执行 block 或者 push 到控制器，默认带动画效果
 *
 *  @param url 将会被打开
 *
 *  @param extraParams 需要传递的参数
 *
 *  @exception 如果 url 没有被影射到结果将会抛出异常
 *
 *  @exception 如果没有导航控制器将会抛出异常
 *
 *  @exception 如果没有获取到控制器对象将会抛出异常
 */
- (void)open:(NSString *)url extraParams:(NSDictionary *)extraParams;

/**
 *  触发一个 url 映射到 block 或者一个类或者一个控制器，执行 block 或者 push 到控制器，动画效果由参数决定
 *
 *  @param url 将会被打开
 *
 *  @param animated YES 时会有动画效果
 *
 *  @param extraParams 需要传递的参数
 *
 *  @exception 如果 url 没有被影射到结果将会抛出异常
 *
 *  @exception 如果没有导航控制器将会抛出异常
 *
 *  @exception 如果没有获取到控制器对象将会抛出异常
 */
- (void)open:(NSString *)url animated:(BOOL)animated extraParams:(NSDictionary *)extraParams;

/**
 *  获取一个 url 的所有参数包括 url 参数，传递的其他参数
 *
 *  @param url
 */
- (NSDictionary*)paramsOfUrl:(NSString*)url;

@end

@interface GDRouter : UPRouter

/**
 *  应用启动的是时候注册路由表（url 和 params 的映射）
 */
- (void)reg;

/**
 *  清除缓存路由表（节省内存消耗）
 */
- (void)clearCache;

/**
 *  获取路由的单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  实例化一个新的路由对象
 */
+ (instancetype)newRouter GDRouterDeprecated("## 请使用 sharedInstance ##");;

@end
