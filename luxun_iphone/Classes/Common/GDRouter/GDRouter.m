//
//  GDRouter.m
//  2HUO
//
/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */

#import "GDRouter.h"
#import "GDRouterCenter.h"
#import <CommonCrypto/CommonDigest.h>

///-------------------------------
/// @name 打开方式
/// @name GDOpendTypePush：push跳转
/// @name GDOpendTypeModal：模态跳转
///-------------------------------

typedef NS_ENUM(NSInteger, GDOpendType) {
    GDOpendTypePush,
    GDOpendTypeModal
};

///-------------------------------
/// @name NSString类目实现md5加密
///-------------------------------

@implementation NSString(GDExtent)
-(BOOL)isNotNull
{
    
    return !(self == nil
             || ([self respondsToSelector:@selector(length)]
                 && [(NSString *)self length] == 0)
             || [self isKindOfClass:[NSNull class]]);
    
}

- (NSString *)GDMD5
{
    NSData * value;
    
    value = [NSData dataWithBytes:[self UTF8String] length:[self length]];
    
    unsigned char	md5Result[CC_MD5_DIGEST_LENGTH + 1];
    CC_LONG			md5Length = (CC_LONG)[self length];
    
    CC_MD5( [value bytes], md5Length, md5Result );
    
    NSMutableData * retData = [[NSMutableData alloc] init];
    if ( nil == retData )
        return nil;
    
    [retData appendBytes:md5Result length:CC_MD5_DIGEST_LENGTH];
    
    value = retData;
    
    if ( value )
    {
        char			tmp[16];
        unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
        unsigned char *	bytes = (unsigned char *)[value bytes];
        unsigned long	length = [value length];
        
        hex[0] = '\0';
        
        for ( unsigned long i = 0; i < length; ++i )
        {
            sprintf( tmp, "%02X", bytes[i] );
            strcat( (char *)hex, tmp );
        }
        
        NSString * result = [NSString stringWithUTF8String:(const char *)hex];
        free( hex );
        return result;
    }
    else
    {
        return nil;
    }
}

- (BOOL)isIncloud:(NSString *)str
{
    if ([self rangeOfString:str].location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

@end

///-------------------------------
/// @name 路由类
/// @desc 路由类的单利，创建路由对象，注册路由表方法
///-------------------------------

@implementation GDRouter

#pragma mark - public methods

+ (instancetype)sharedInstance
{
    static GDRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[GDRouter alloc] init];
    });
    return router;
}

+ (instancetype)newRouter
{
    return [[self alloc] init];
}

- (void)reg
{
    [GDRouterReger reg];
}

- (void)clearCache
{
    [GDRouterReger clearCache];
}


@end

///-------------------------------
/// @name 路由参数信息类
/// @description 路由的url，参数，block代码块，class，控制器对象
///-------------------------------

@interface RouterParams : NSObject

/**
 *  URL<e.g. GD://productDetail/?pid=997>
 */
@property (readonly , nonatomic, strong) NSString               * url;

/**
 *  需要传递的参数
 */
@property (readwrite, nonatomic, strong) NSMutableDictionary    * params;

/**
 *  URL对应的回调
 */
@property (readonly , nonatomic, copy  ) RouterComponentBlock     block;

/**
 *  URL对应的的类
 */
@property (readonly , nonatomic, strong) Class                    cls;

/**
 *  导航控制器类（模态跳转时需要）
 */
@property (readonly , nonatomic, strong) Class                    navCls;

/**
 *  URL对应的控制器对象
 */
@property (readonly , nonatomic, strong) UIViewController       * controller;

/**
 *  导航控制器对象（模态跳转时需要）
 */
@property (readonly , nonatomic, strong) UINavigationController * navController;

@end

@implementation RouterParams

- (instancetype)initWithUrl:(NSString *)url
                     Params:(NSDictionary *)params
                      Class:(Class)cls
                   navClass:(Class)navCls
                 controller:(UIViewController *)controller
              navController:(UINavigationController *)navController
                  callBlock:(RouterComponentBlock)block
{
    
    _url           = url;
    _params        = [NSMutableDictionary dictionaryWithDictionary:params];
    _block         = block;
    _cls           = cls;
    _navCls        = navCls;
    _controller    = controller;
    _navController = navController;
    return self;
    
}

- (NSDictionary *)controllerParams {
    return self.params;
}

- (NSDictionary *)getParams {
    return [self controllerParams];
}

- (RouterComponentBlock)getBlock
{
    return self.block;
}

- (Class)getCls
{
    return self.cls;
}

- (Class)getNavCls
{
    return self.navCls;
}

- (UIViewController *)getController
{
    return self.controller;
}

- (UINavigationController *)getNavController
{
    return self.navController;
}

-(NSString *)regKey
{
    NSAssert(self.url.isNotNull, @"url is empty");
    NSURL * url = [NSURL URLWithString:self.url];
    return url.host.GDMD5;
}
@end


@interface UPRouter ()

/**
 *  路由映射表，保存所有的应用启动的时候注册的路由
 */
@property (readwrite, nonatomic, strong) NSMutableDictionary * routes;

/**
 *  路由缓存表，缓存了打开过的 url （ open 时优先从缓存查找 ）
 */
@property (readwrite, nonatomic, strong) NSMutableDictionary * cachedRoutes;

@end

@implementation UPRouter

- (id)init
{
    if ((self = [super init])) {
        self.routes       = [NSMutableDictionary dictionary];
        self.cachedRoutes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)cacheClear
{
    [[GDRouter sharedInstance].cachedRoutes removeAllObjects];
}

#pragma mark  通过 block 注册 url

- (void)reg:(NSString *)urlPattern toHandler:(RouterComponentBlock)callback
{
    [self map:urlPattern class:nil controller:nil navClass:nil navController:nil toHandler:callback];
}

#pragma mark  通过 class 注册 url

- (void)reg:(NSString *)urlPattern toClass:(Class)cls
{
    [self map:urlPattern class:cls controller:nil navClass:nil navController:nil toHandler:nil];
}

- (void)reg:(NSString *)urlPattern toClass:(Class)cls navClass:(Class)navcls
{
    [self map:urlPattern class:cls controller:nil navClass:navcls navController:nil toHandler:nil];
}

#pragma mark  通过 controller 注册 url

- (void)reg:(NSString *)urlPattern toController:(UIViewController *)controller
{
    [self map:urlPattern class:nil controller:controller navClass:nil navController:nil toHandler:nil];
}

- (void)reg:(NSString *)urlPattern toController:(UIViewController *)controller navController:(UINavigationController *)navController
{
    [self map:urlPattern class:nil controller:controller navClass:nil navController:navController toHandler:nil];
}

/**
 *  写入路由表方法
 */

-   (void)map:(NSString *)urlPattern
        class:(Class)cls
   controller:(UIViewController *)controller
     navClass:(Class)navCls
navController:(UINavigationController* )navController
    toHandler:(RouterComponentBlock)callback
{
    if (!urlPattern.isNotNull) {
        if (!_openException) {
            NSLog(@"注册时必须传入url");
            return;
        }
        @throw [NSException exceptionWithName:@"⚠️路由器故障！！！"
                                       reason:@"注册时必须传入url"
                                     userInfo:nil];
        return;
    }
    RouterParams * routerParam = [[RouterParams alloc] initWithUrl:urlPattern
                                                            Params:nil
                                                             Class:cls
                                                          navClass:navCls
                                                        controller:controller
                                                     navController:navController
                                                         callBlock:callback];
    [self.routes setObject:routerParam forKey:[routerParam regKey]];
    
}

- (void)openExternal:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)show:(NSString *)url completion:(RouterCompletion)completion
{
    [self show:url animated:YES completion:completion];
}

- (void)show:(NSString *)url animated:(BOOL)animated completion:(RouterCompletion)completion
{
    [self show:url animated:animated extraParams:nil completion:completion];
}

- (void)show:(NSString *)url extraParams:(NSDictionary *)extraParams completion:(RouterCompletion)completion
{
     [self show:url animated:YES extraParams:extraParams completion:completion];
}

- (void)show:(NSString *)url animated:(BOOL)animated extraParams:(NSDictionary *)extraParams completion:(RouterCompletion)completion
{
    [self open:url
      animated:animated
   extraParams:extraParams
         style:GDOpendTypeModal
    completion:completion];
}

- (void)open:(NSString *)url
{
    [self open:url animated:YES];
}

- (void)open:(NSString *)url animated:(BOOL)animated
{
    [self open:url animated:animated extraParams:nil];
}

- (void)open:(NSString *)url extraParams:(NSDictionary *)extraParams
{
    [self open:url animated:YES extraParams:extraParams];
}

- (void)open:(NSString *)url
    animated:(BOOL)animated
 extraParams:(NSDictionary *)extraParams
{
    [self open:url
      animated:animated
   extraParams:extraParams
         style:GDOpendTypePush
    completion:nil];
}


- (void)open:(NSString *)url
    animated:(BOOL)animated
 extraParams:(NSDictionary *)extraParams
       style:(GDOpendType)type
  completion:(RouterCompletion)completion
{
    CGFloat occupancy = self.cachedRoutes.count/self.routes.count;
    occupancy > 0.9 ? [self cacheClear] : NO;
    NSURL * Url = [NSURL URLWithString:url];
    NSMutableDictionary * completeParams = [self paramsForUrl:url extraParams:extraParams];
    RouterParams *params = [self routerParamsForUrl:Url.host.GDMD5 extraParams:completeParams];
    
    // 如果传入的 URL 没有映射到对应的数据说明此 URL 没有注册或者 URL 错误
    if (!params || params == nil) {
        // 没有注册的url走这一步，例如：taobao://target/action?id=667
        [self go:url animated:animated params:extraParams completion:completion];
        return;
    }
    
    // 回调的优先级比较高，如果注册了回调则直接执行回调
    if ([params block]) {
        RouterComponentBlock callback = [params block];
        callback([params controllerParams]);
        return;
    }
    
    // 如果没有导航控制器就获取当前显示的controller的导航控制器（没有获取到导航控制器就抛出异常）
    if (!self.navigationController) {
        UIViewController       * currentVc = [self currentViewController];
        UINavigationController * navC = currentVc.navigationController;
        if (navC && type == GDOpendTypePush) {
            self.navigationController = navC;
        }else if (currentVc && type == GDOpendTypeModal){
            self.controller = currentVc;
        }else{
            if (!_openException) {
                NSLog(@"当前页面没有找到控制器！");
                return;
            }
            @throw [NSException exceptionWithName:@"⚠️路由器故障！！！"
                                           reason:@"当前页面没有找到控制器！"
                                         userInfo:nil];
        }
    }
    
    UIViewController * vc = nil;
    vc = [self controllerForRouterParams:params];
    vc.hidesBottomBarWhenPushed = YES;
    
    if (!vc || vc == nil) {
        NSLog(@"没有要跳转的视图控制器！");
        [self def:self];
        return;
    }
    
    if (type == GDOpendTypePush) {
        if (self.navigationController.presentedViewController) {
            [self.navigationController dismissViewControllerAnimated:animated completion:nil];
        }
        [self.navigationController pushViewController:vc animated:animated];
    }else{
        if (self.controller.presentedViewController) {
            [self.controller dismissViewControllerAnimated:animated completion:nil];
        }
        
        UINavigationController * nav = nil;
        
        if ([params navController]) {
            Class navCls = [[params navController] class];
            nav = [[navCls alloc] init];
        }else if ([params navCls]){
            Class navCls = [params navCls];
            nav = [[navCls alloc] init];
        }
        
        if (nav) {
            nav.viewControllers = @[vc];
            if (self.navigationController) {
                [self.navigationController presentViewController:nav animated:animated completion:completion];
            }else{
                [self.controller presentViewController:nav animated:animated completion:completion];
            }
        }else{
            if (self.navigationController) {
                [self.navigationController presentViewController:vc animated:animated completion:completion];
            }else{
                [self.controller presentViewController:vc animated:animated completion:completion];
            }
        }
        
    }
    self.navigationController = nil;
    self.controller = nil;
    
    // 操作完成后清除掉参数，避免浪费内存
    if (params.params && params.params.count>0) {
        [params.params removeAllObjects];
    }
}

- (void)go:(NSString *)url animated:(BOOL)animated params:(NSDictionary *)params completion:(RouterCompletion)completion
{
    
    GDRouterAction * Action = [[GDRouterCenter defaultCenter] actionOfPath:url];
    
    Class targetClass = Action.target;
    SEL action = Action.action;
    
    UIViewController       * currentVc = [self currentViewController];
    UINavigationController * navC = currentVc.navigationController;
    self.navigationController = navC;
    
    id target = [[targetClass alloc] init];
    
    NSMutableDictionary * fullParams = [NSMutableDictionary dictionary];
    
    if (Action.params && Action.params.count>0)
        [fullParams addEntriesFromDictionary:Action.params];
    if (params && params.count > 0)
        [fullParams addEntriesFromDictionary:params];
    
    [self setParams:fullParams forObject:target];
    
    if ([target isKindOfClass:[UIViewController class]]||
        [target isKindOfClass:[UINavigationController class]]||
        [target isKindOfClass:[UITabBarController class]]||
        [target isKindOfClass:[UITableViewController class]]||
        [target isKindOfClass:[UICollectionViewController class]]) {
        [self.navigationController pushViewController:target animated:animated];
    }
    
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:action withObject:params] ;
#pragma clang diagnostic pop
    } else {
        
        // 无响应处理
        [self def:target];
        return;
        
    }
    
}

- (NSDictionary*)paramsOfUrl:(NSString*)url
{
    return [[self routerParamsForUrl:url] controllerParams];
}

- (void)popViewControllerFromRouterAnimated:(BOOL)animated
{
    
    // 获取到当前的视图控制器
    UIViewController       * currentVc = [self currentViewController];
    UINavigationController * navVc = currentVc.navigationController;
    if (navVc) {
        self.navigationController = navVc;
        NSArray * viewControllers = self.navigationController.viewControllers;
        if (viewControllers.count == 1) {
            // 当前控制器是模态跳转过来的
            [self.navigationController dismissViewControllerAnimated:animated completion:nil];
        }else if ([viewControllers objectAtIndex:viewControllers.count-1] == currentVc) {
            // 当前控制器是push过来的
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.navigationController = nil;
    }else if (currentVc) {
        // 当前控制器没有导航控制器所以不可能是push过来的
        [currentVc dismissViewControllerAnimated:animated completion:nil];
    }else{
        if (!_openException) {
            NSLog(@"当前页面没有控制器！");
            return;
        }
        @throw [NSException exceptionWithName:@"⚠️路由器故障！！！"
                                       reason:@"当前页面没有控制器！"
                                     userInfo:nil];
    }
    
    
}
- (void)pop
{
    [self popViewControllerFromRouterAnimated:YES];
}
- (void)pop:(BOOL)animated
{
    [self popViewControllerFromRouterAnimated:animated];
}


- (RouterParams *)routerParamsForUrl:(NSString *)url
                         extraParams:(NSMutableDictionary *)extraParams
{
    if (!url) {
        if (!_openException) {
            NSLog(@"没有发现 url");
            return nil;
        }
        @throw [NSException exceptionWithName:@"⚠️路由器故障！！！"
                                       reason:@"没有发现 url"
                                     userInfo:nil];
    }
    
    if ([self.cachedRoutes objectForKey:url]) {
        // 从缓存中获取路由信息
        RouterParams * params = [self.cachedRoutes objectForKey:url];
        params.params = extraParams;
        return params;
    }
    if ([self.routes objectForKey:url]) {
        // 从注册表中获取路由信息
        RouterParams * params = [self.routes objectForKey:url];
        params.params = extraParams;
        [self.cachedRoutes setObject:params forKey:url];
        return params;
    }
    
    return nil;
}

- (RouterParams *)routerParamsForUrl:(NSString *)url
{
    return [self routerParamsForUrl:url extraParams: nil];
}

- (NSMutableDictionary *)paramsForUrl:(NSString *)url
                   extraParams:(NSDictionary *)extraParams
{
    
    NSMutableDictionary *params = [[GDRouterCenter defaultCenter] queryItemsInPath:url];
    if (extraParams) {
        [params addEntriesFromDictionary:extraParams];
    }
    return params;
}

- (UIViewController *)controllerForRouterParams:(RouterParams *)params
{
    UIViewController *controller = nil;
    if ([params cls]) {
        Class controllerClass = params.cls;
        controller = [[controllerClass alloc] init];
    }
    if ([params controller]) {
        Class controllerClass = [[params controller] class];
        controller = [[controllerClass alloc] init];
    }

    if (!controller) {
        if (!_openException) {
            NSLog(@"没有获取到控制器！");
            return nil;
        }
        @throw [NSException exceptionWithName:@"⚠️路由器故障！！！"
                                       reason:@"没有获取到控制器！"
                                     userInfo:nil];
    }
    if ([params controllerParams]) {
        NSArray * propertyList = [self getPropertyList:[controller class]];
        for (NSString * key in [params controllerParams]) {
            if ([propertyList containsObject:key]) {
                [controller setValue:[params controllerParams][key] forKey:key];
            }
        }
    }
    return controller;
}

#pragma mark 获取当前展现的 UIViewController

- (UIViewController *)currentViewController
{
    UIWindow * keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIView   * firstView  = [keyWindow.subviews firstObject];
    UIView   * secondView = [firstView.subviews firstObject];
    UIViewController * vc = [self parentController:secondView];
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
    return nil;
}

- (UIViewController *)parentController:(UIView *)view
{
    UIResponder *responder = [view nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark 获取一个类的属性列表

-(NSArray *)getPropertyList:(Class)klass
{
    NSMutableArray *propertyNamesArray = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(klass, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNamesArray addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNamesArray;
}

- (id)setParams:(NSDictionary *)params forObject:(id)object
{
    [[GDRouterCenter defaultCenter] model:object params:params];
    return object;
}

- (void)def:(id)obj
{
    // 无响应处理
    Class defTargetClass = NSClassFromString(@"GDRouterDefault");
    id defTarget = [[defTargetClass alloc] init];
    SEL defAction = NSSelectorFromString(@"notFound:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [defTarget performSelector:defAction withObject:obj];
#pragma clang diagnostic pop
    
}
@end


