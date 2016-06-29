//
//  O2HCache.h
//  2HUO
//
//  Created by iURCoder on 3/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "YYCache.h"

@interface O2HCache : YYCache

+ (YYCache *)setObject:(id<NSCoding>)object forKey:(NSString *)key cacheName:(NSString *)name;

+ (id<NSCoding>)objectForKey:(NSString *)key cacheName:(NSString *)name;

+ (void)removeObjectForKey:(NSString *)key cacheName:(NSString *)name;

+ (void)removeAllCache;

@end
