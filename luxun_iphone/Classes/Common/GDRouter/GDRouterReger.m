//
//  GDRouter+Extent.m
//  2HUO
//
//  Created by iURCoder on 3/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDRouterReger.h"
#import "GDRouter.h"

#import "LXPlayScene.h"

@implementation GDRouterReger

+ (void)reg
{
    LXPlayScene * playerScene = [[LXPlayScene alloc] init];
    [[GDRouter sharedInstance] reg:@"luxun://player" toController:playerScene];
}

+ (void)clearCache
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    Class cls = NSClassFromString(@"UPRouter");
    id target  = [[cls alloc] init];
    SEL selector = NSSelectorFromString(@"cacheClear");
    if ([target respondsToSelector:selector]) {
        [target performSelector:selector];
    }
#pragma clang diagnostic pop
    
}

+ (NSDictionary *)targetMap
{
    return @{@"temai":@"MFUHomeScene"};
}

+ (NSDictionary *)actionMap
{
    return @{@"add":@"rightButtonTouch"};
}

@end
