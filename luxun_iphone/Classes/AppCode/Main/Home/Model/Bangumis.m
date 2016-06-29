//
//  Bangumis.m
//  luxun_iphone
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "Bangumis.h"

#define kVideoSource @"http://usagi.luxun.pro"

@implementation Bangumis
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation Quars
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation Bangumi
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (NSString *)videoUrlWithUri:(NSString *)uri
{
    NSString * ecodeStr = self.original.urlEncode;
    NSString * fullUrl = [NSString stringWithFormat:@"%@/%@/%@",kVideoSource,ecodeStr,uri.urlEncode];
    return fullUrl;
}

- (NSString *)timeLineBangumiIcon
{
    return [NSString stringWithFormat:@"http://0.luxun.pro:12580/thumb/%@.jpg",self.filename.urlEncode];
}


@end


@implementation Set
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end