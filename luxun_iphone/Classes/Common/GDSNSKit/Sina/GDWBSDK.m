//
//  GDWBSDK.m
//  luxun_iphone
//
//  Created by iURCoder on 4/21/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDWBSDK.h"

#define kCACHE_KEY @"GDWBSDK_ACCOUNT_CACHE"

@implementation GDAccount


@end

@interface GDWBSDK ()

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *redirectUrl;
@property (nonatomic, copy) GDLoginCallBack complete;

@end

@implementation GDWBSDK

+ (instancetype)shareInstance
{
    static GDWBSDK *shareInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[self.class alloc]init];
    });
    return shareInstance;
}

#pragma mark 注册应用

+ (BOOL)registerApp:(NSString *)appKey appSecret:(NSString *)appSecret redirectUrl:(NSString *)redirectUrl
{
    [GDWBSDK shareInstance].appKey = appKey;
    [GDWBSDK shareInstance].appSecret = appSecret;
    [GDWBSDK shareInstance].redirectUrl = redirectUrl;
    [[GDWBSDK shareInstance] getAccountFromeCache];
    return [WeiboSDK registerApp:appKey];
}

- (void)saveInCache:(NSDictionary *)response
{
    
    [[NSUserDefaults standardUserDefaults] setObject:response forKey:kCACHE_KEY];
    
}

- (void)getAccountFromeCache
{
    NSDictionary * response = [[NSUserDefaults standardUserDefaults] objectForKey:kCACHE_KEY];
    GDAccount * account = [[GDAccount alloc] init];
    account.uid = response[@"uid"];
    account.accessToken = response[@"access_token"];
    account.refreshToken = response[@"refresh_token"];
    account.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[response[@"expires_in"] integerValue]];
    _currentAccount = account;
}

#pragma mark 是否过期

- (BOOL)isAuthenticated
{
    if ([GDWBSDK shareInstance].currentAccount == nil) return YES;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDate *overdueDate = [GDWBSDK shareInstance].currentAccount.expirationDate;
    NSTimeInterval overdue = [overdueDate timeIntervalSince1970];
    return overdue - now < 0 ? YES : NO;
}

#pragma mark 是否注册了应用

- (BOOL)isReg
{
    return ([GDWBSDK shareInstance].appKey && [GDWBSDK shareInstance].appSecret && [GDWBSDK shareInstance].redirectUrl);
}

#pragma mark 是否安装微博

- (BOOL)isWeiboAppInstalled
{
    return [WeiboSDK isWeiboAppInstalled];
}

#pragma mark 是否支持SSO

- (BOOL)isCanSSOInWeiboApp
{
    return [WeiboSDK isCanSSOInWeiboApp];
}

#pragma mark 是否可分享

- (BOOL)isCanShareInWeiboAPP
{
    return [WeiboSDK isCanShareInWeiboAPP];
}

#pragma mark 打开微博客户端

-(BOOL)open
{
    if (![self isWeiboAppInstalled]) return NO;
    return [WeiboSDK openWeiboApp];
}

#pragma mark 短信注册账号

+ (void)messageRegister:(NSString *)navTitle
{
    [GDWBSDK messageRegister:navTitle];
}

#pragma mark 登录授权

- (void)loginSSO:(BOOL)sso complete:(GDLoginCallBack)complete
{
    if (![self isReg]) return;
    [GDWBSDK shareInstance].complete = complete;
    if (![GDWBSDK shareInstance].isAuthenticated) {
        if (complete) {
            complete(GDResponseStatusCodeSuccess,[GDWBSDK shareInstance].currentAccount);
        }
        return;
    }
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = [GDWBSDK shareInstance].redirectUrl;
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

#pragma mark 使用RefreshToken去换取新的身份凭证AccessToken

- (void)updateAccessTokenUseRefreshToken:(NSString *)refreshToken complete:(GDUpdateAccessTokenCallBack)complete
{
    if ([GDWBSDK shareInstance].currentAccount.refreshToken.length<1 && refreshToken.length<1)
    {
        if (complete) {
            complete(NO);
        }
        return;
    }
    NSString * rToken ;
    rToken = [GDWBSDK shareInstance].currentAccount.refreshToken;
    if (refreshToken) {
        rToken = refreshToken;
    }
    NSOperationQueue *updateQueue = [[NSOperationQueue alloc]init];
    [WBHttpRequest requestForRenewAccessTokenWithRefreshToken:rToken queue:updateQueue withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        if (result && !error) {
            if (complete) {
                GDAccount * account = [GDWBSDK shareInstance].currentAccount;
                account.accessToken = result[@"access_token"];
                account.refreshToken = result[@"refresh_token"];
                account.uid = result[@"uid"];
                [self saveInCache:result];
                complete(YES);
            }
        }else{
            if (complete) {
                complete(NO);
            }
        }
    }];
}

#pragma mark 登出，取消授权

- (void)logout
{
    if (!([GDWBSDK shareInstance].currentAccount.accessToken.length > 0)) return;
    [WeiboSDK logOutWithToken:[GDWBSDK shareInstance].currentAccount.accessToken delegate:self withTag:@"user1"];
    _currentAccount = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCACHE_KEY];
}

#pragma mark 开启关闭调试模式

+ (void)deBug:(BOOL)enabled
{
    [WeiboSDK enableDebugMode:enabled];
}

#pragma mark 分享

- (void)post:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString*)url
{
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"";
    webpage.title = title;
    webpage.description = content;
    webpage.thumbnailData = UIImagePNGRepresentation(image);;
    webpage.webpageUrl = url;
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"share": title,@"url":url};
    [WeiboSDK sendRequest:request];
}

#pragma mark 收到一个来自微博客户端程序的响应

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
    }else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        GDResponseStatusCode statusCode = (GDResponseStatusCode)[(WBAuthorizeResponse *)response statusCode];
        if (statusCode == GDResponseStatusCodeSuccess) {
            GDAccount * account = [[GDAccount alloc] init];
            account.uid = [(WBAuthorizeResponse *)response userID];
            account.accessToken = [(WBAuthorizeResponse *)response accessToken];
            account.expirationDate = [(WBAuthorizeResponse *)response expirationDate];
            account.refreshToken = [(WBAuthorizeResponse *)response refreshToken];
            _currentAccount = account;
            [self saveInCache:response.requestUserInfo];
            if ([GDWBSDK shareInstance].complete) {
                [GDWBSDK shareInstance].complete(statusCode,account);
            }
        }else{
            if ([GDWBSDK shareInstance].complete) {
                [GDWBSDK shareInstance].complete(statusCode,nil);
            }
        }
    }
}

#pragma mark 收到一个来自微博客户端程序的请求

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

@end
