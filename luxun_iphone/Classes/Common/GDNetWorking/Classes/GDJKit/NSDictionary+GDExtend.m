//
//  NSDictionary+GDExtend.m
//  2HUO
//
//  Created by iURCoder on 4/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "NSDictionary+GDExtend.h"

@implementation NSDictionary (GDExtend)

- (NSString *)joinToPath{
    NSMutableArray *array = [NSMutableArray array];
    [self each:^(id key, id value) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [array addObject:str];
    }];
    return [array componentsJoinedByString:@"&"];
}

- (NSDictionary *)each:(void (^)(id key, id value))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        block(key, value);
    }];
    return self;
}

- (id)objectAtPath:(NSString *)path
{
    return [self objectAtPath:path separator:nil];
}

- (id)objectAtPath:(NSString *)path separator:(NSString *)separator
{
    if ( nil == separator )
    {
        path = [path stringByReplacingOccurrencesOfString:@"." withString:@"/"];
        separator = @"/";
    }
    NSArray * array = [path componentsSeparatedByString:separator];
    if ( 0 == [array count] )
    {
        return nil;
    }
    
    NSObject * result = nil;
    NSDictionary * dict = self;
    
    for ( NSString * subPath in array )
    {
        if ( 0 == [subPath length] )
            continue;
        
        result = [dict objectForKey:subPath];
        if ( nil == result )
            return nil;
        
        if ( [array lastObject] == subPath )
        {
            return result;
        }
        else if ( NO == [result isKindOfClass:[NSDictionary class]] )
        {
            return nil;
        }
        
        dict = (NSDictionary *)result;
    }
    
    return (result == [NSNull null]) ? nil : result;
}


@end
