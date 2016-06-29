//
//  NSString+GDExtent.m
//  2HUO
//
//  Created by iURCoder on 4/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "NSObject+GDExtend.h"

@implementation NSObject (GDExtend)

-(BOOL)isNotEmpty{
    return !(self == nil
             || [self isKindOfClass:[NSNull class]]
             || ([self respondsToSelector:@selector(length)]
                 && [(NSData *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));
    
}

@end
