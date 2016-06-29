//
//  GDRouterDefault.m
//  2HUO
//
//  Created by iURCoder on 4/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDRouterDefault.h"

@implementation GDRouterDefault

- (void)notFound:(id)sender
{
    // 未处理的请求都会走这里
    NSLog(@"action not found!");
}

- (void)pageNotFound
{
    // 404 not found
}

@end
