//
//  AppDelegate.m
//  luxun_iphone
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "AppDelegate.h"
#import "LXMainScene.h"
#import "IQKeyboardManager.h"
#import "IHNavigationController.h"
#import "LXTitleView.h"
#import "GDWBSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LXMainScene * main = [[LXMainScene alloc] init];
    IHNavigationController *nav = [[IHNavigationController alloc] initWithRootViewController:main];
    LXTitleView *titleView = [[LXTitleView alloc] init];
    titleView.rootViewController = main;
    [titleView setButtons:@[@"我",@"追番",@"时间线",@"专题"]];
    titleView.selectIndex = 1;
    main.navigationItem.titleView = titleView;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [GDRouter sharedInstance].openException = YES;
    [[GDRouter sharedInstance] reg];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    AFNetworkReachabilityManager *manager =
    [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [[RACObserve(manager, networkReachabilityStatus) skip:1]
     subscribeNext:^(NSNumber* status) {
         AFNetworkReachabilityStatus networkStatus = [status intValue];
         switch (networkStatus) {
             case AFNetworkReachabilityStatusUnknown:
             case AFNetworkReachabilityStatusNotReachable:
                 luxunSay(@"网络不给力");
                 [DataCenter defaultCenter].networkAvailable = NO;
                 [DataCenter defaultCenter].isWifi = NO;
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 luxunSay(@"当前使用移动数据网络");
                 [DataCenter defaultCenter].networkAvailable = YES;
                 [DataCenter defaultCenter].isWifi = NO;
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 luxunSay(@"当前使用wifi");
                 [DataCenter defaultCenter].networkAvailable = YES;
                 [DataCenter defaultCenter].isWifi = YES;
                 break;
         }
     }];
    
    
    [GDWBSDK registerApp:@"237001682" appSecret:@"7f86a18baebe26364db65b48ac5cbb20" redirectUrl:@"http://open.weibo.com/apps/237001682/info/advanced"];
    
    id obj = [[TMCache sharedCache] objectForKey:kUSERCACHE];
    NSDictionary *dic = [obj toDictionary];
    User * user = [[User alloc] initWithDictionary:dic error:NULL];
    [[AccountCenter shareInstance] save:user];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:[GDWBSDK shareInstance]];
}




@end
