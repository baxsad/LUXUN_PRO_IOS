//
//  O2HCache.m
//  2HUO
//
//  Created by iURCoder on 3/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "O2HCache.h"

@implementation O2HCache

+ (YYCache *)setObject:(id<NSCoding>)object forKey:(NSString *)key cacheName:(NSString *)name
{
    YYCache * cache = [[YYCache alloc] initWithName:name];
    [cache setObject:object forKey:key];
    return cache;
}

+ (id<NSCoding>)objectForKey:(NSString *)key cacheName:(NSString *)name
{
    YYCache * cache = [[YYCache alloc] initWithName:name];
    return [cache objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key cacheName:(NSString *)name
{
    YYCache * cache = [YYCache cacheWithName:name];
    [cache removeObjectForKey:key];
}

+ (void)removeAllCache
{
    YYCache * cache = [[YYCache alloc] initWithName:@""];
    [cache removeAllObjects];
}

@end
