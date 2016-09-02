//
//  LXRequest.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXRequest.h"

@implementation LXRequest

+ (GDReq*)userLoginRequest
{
    GDReq * req = [GDReq Request];
    req.STATICPATH = @"http://api.luxun.pro/?u";
    req.METHOD = @"POST";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.httpHeaderFields = @{@"Referer" : Referer};
    return req;
}

+ (GDReq*)getUserInfoRequest
{
    GDReq * req = [GDReq Request];
    req.STATICPATH = @"http://api.luxun.pro/?u";
    req.METHOD = @"POST";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.httpHeaderFields = @{@"Referer" : Referer};
    return req;
}

+ (GDReq*)getComicListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"luxun.json";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.httpHeaderFields = @{@"Referer" : Referer};
    return req;
}

+ (GDReq*)getTimeLineRequest
{
    GDReq * req = [GDReq Request];
    req.STATICPATH = @"http://api.luxun.pro/?mp4";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.httpHeaderFields = @{@"Referer" : Referer};
    return req;
}

+ (GDReq *)getDanMuRequest
{
    GDReq * req = [GDReq Request];
    req.STATICPATH = @"http://0.luxun.pro:163/?dm/lx:";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.httpHeaderFields = @{@"Referer" : Referer};
    return req;
}

+ (GDReq*)getTopicsRequest
{
    GDReq * req = [GDReq Request];
    req.STATICPATH = @"http://api.luxun.pro/?topics";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.httpHeaderFields = @{@"Referer" : Referer};
    return req;
}

@end
