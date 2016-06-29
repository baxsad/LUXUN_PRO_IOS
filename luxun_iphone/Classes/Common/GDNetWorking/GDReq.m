//
//  GDReq.m
//  2HUO
//
//  Created by iURCoder on 3/31/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDReq.h"
#import "GDAction.h"

@interface GDReq ()

@property (nonatomic, strong) GDAction * action;

@end

@implementation GDReq

+ (nonnull instancetype)Request
{
    return [self RequestWithMethod:@"GET"];
}

+ (nonnull instancetype)RequestWithMethod:(nonnull NSString *)method
{
    return [[self alloc] initWithRequestMethod:method];
}

- (nonnull instancetype)initRequest
{
    return [self initWithRequestMethod:@"GET"];
}

- (nonnull instancetype)initWithRequestMethod:(nonnull NSString *)method
{
    self = [super init];
    if(self){
        [self loadRequest];
        self.METHOD = method;
    }
    return self;
}

- (void)loadRequest
{
    self.securityPolicy         = [self reqSecurityPolicy];
    self.cachePolicy            = GDRequestCachePolicyNoCache;
    self.output                 = nil;
    self.params                 = [NSMutableDictionary dictionary];
    self.responseString         = nil;
    self.error                  = nil;
    self.status                 = GDRequestStatusNotStart;
    self.url                    = nil;
    self.message                = nil;
    self.codeKey                = nil;
    self.exactitudeKey          = GD_REQUEST_RIGHT_CODE;
    self.exactitudeKeyPath      = GD_ERROR_CODE_PATH;
    self.SCHEME                 = nil;
    self.HOST                   = nil;
    self.PATH                   = @"";
    self.APPENDPATH             = @"";
    self.STATICPATH             = @"";
    self.needCheckCode          = NO;
    self.responseSerializer     = GDResponseSerializerTypeJSON;
    self.timeoutInterval        = GD_API_REQUEST_TIME_OUT;
    self.isFirstRequest         = YES;
    self.isTimeout              = NO;
    self.acceptableContentTypes = [self responseAcceptableContentTypes];
    self.httpHeaderFields       = [self requestHTTPHeaderField];
    self.action                 = [GDAction action];
    [self loadActive];
    
}

- (void)loadActive
{
    self.requestNeedActive = NO;
}

- (void)setRequestNeedActive:(BOOL)requestNeedActive
{
    if (self.requestNeedActive == requestNeedActive) {
        return;
    }else{
        if (requestNeedActive == YES) {
            [self start];
            _requestNeedActive = NO;
        }else{
            return;
        }
    }
}

- (void)setParams:(NSMutableDictionary *)params
{
    if ([params isKindOfClass:[NSDictionary class]]) {
        _params = [params mutableCopy];return;
    }
    _params = params;
}

- (BOOL)succeed
{
    if(self.output == nil){
        return NO;
    }
    return GDRequestStatusSuccess == self.status ? YES : NO;
}

- (BOOL)sending
{
    return GDRequestStatusSending == self.status ? YES : NO;
}

- (BOOL)failed
{
    return (GDRequestStatusFailed == self.status
            || GDRequestStatusError == self.status
            || GDRequestStatusTimeOut == self.status
            || GDRequestStatusCancle == self.status)
    ? YES : NO;
}

- (BOOL)Error
{
    return GDRequestStatusError == self.status ? YES : NO;
}

- (BOOL)cancled
{
    return GDRequestStatusCancle == self.status ? YES : NO;
}

- (BOOL)timeOut
{
    return GDRequestStatusTimeOut == self.status ? YES : NO;
}

- (void)start
{
    if (self.action) {
        [self.action Send:self];
    }
}

- (void)cancle
{
    if (self.action) {
        [self.action cancelRequest:self];
    }
}

- (void)listen:(nonnull listenCallBack)block
{
    if (block && self.action) {
        [self.action listen:block];
    }
}

- (NSURLRequestCachePolicy)RequestCachePolicy {
    return NSURLRequestUseProtocolCachePolicy;
}

- (nullable GDSecurityPolicy *)reqSecurityPolicy {
    GDSecurityPolicy *securityPolicy;
#ifdef DEBUG
    securityPolicy = [GDSecurityPolicy policyWithPinningMode:GDSSLPinningModeNone];
#else
    securityPolicy = [GDSecurityPolicy policyWithPinningMode:GDSSLPinningModePublicKey];
#endif
    return securityPolicy;
}

- (nullable NSDictionary *)requestHTTPHeaderField {
    return @{
             @"Content-Type" : @"application/json; charset=utf-8",
             };
}

- (nullable NSSet *)responseAcceptableContentTypes{
    return [NSSet setWithObjects:@"text/plain" ,
            @"application/json",
            @"text/json",
            @"text/javascript",
            @"text/html",
            @"image/png",
            @"image/jpeg",
            @"application/rtf",
            @"image/gif",
            @"application/zip",
            @"audio/x-wav",
            @"image/tiff",
            @" 	application/x-shockwave-flash",
            @"application/vnd.ms-powerpoint",
            @"video/mpeg",
            @"video/quicktime",
            @"application/x-javascript",
            @"application/x-gzip",
            @"application/x-gtar",
            @"application/msword",
            @"text/css",
            @"video/x-msvideo",
            @"text/xml", nil];
}

-(NSString *)appendPathInfo{
    __block NSString *pathInfo = self.pathInfo;
    if(pathInfo.isNotEmpty){
        [self.params enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL *stop) {
            NSString *par = [NSString stringWithFormat:@"(\\{%@\\})",key];
            NSString *str = [NSString stringWithFormat:@"%@",value];
            
            pathInfo = [[[NSRegularExpression alloc] initWithPattern:par options:0 error:nil] stringByReplacingMatchesInString:pathInfo options:0 range:NSMakeRange(0, pathInfo.length) withTemplate:str];
        }];
    }
    return pathInfo;
}

-(NSString *)pathInfo{
    return nil;
}

- (nullable NSString*)requestID{
    NSAssert(self.url.isNotEmpty, @"url is empty");
    if (_requestID) {
        return _requestID;
    }
    NSString * ID = @"";
    if([self.METHOD isEqualToString:@"GET"]){
        ID = self.url.absoluteString.MD5;
    }else if(self.params.isNotEmpty){
        ID = [NSString stringWithFormat:@"%@%@",self.url,[self.params joinToPath]].MD5;
    }else{
        ID = [NSString stringWithFormat:@"%@",self.url].MD5;
    }
    _requestID = ID;
    return ID;
}


@end
