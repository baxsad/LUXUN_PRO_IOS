//
//  GDWBSDK.h
//  luxun_iphone
//
//  Created by iURCoder on 4/21/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

typedef NS_ENUM(NSInteger, GDResponseStatusCode)
{
    GDResponseStatusCodeSuccess               = 0,//成功
    GDResponseStatusCodeUserCancel            = -1,//用户取消发送
    GDResponseStatusCodeSentFail              = -2,//发送失败
    GDResponseStatusCodeAuthDeny              = -3,//授权失败
    GDResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
    GDResponseStatusCodePayFail               = -5,//支付失败
    GDResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
    GDResponseStatusCodeUnsupport             = -99,//不支持的请求
    GDResponseStatusCodeUnknown               = -100,
};

@interface GDAccount : NSObject

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * accessToken;
@property (nonatomic, strong) NSDate * expirationDate;
@property (nonatomic, copy) NSString * refreshToken;

@end

typedef void (^GDLoginCallBack)(GDResponseStatusCode status,GDAccount * account);
typedef void (^GDUpdateAccessTokenCallBack)(BOOL sucess);

@interface GDWBSDK : NSObject<WeiboSDKDelegate,WBHttpRequestDelegate>

/**
 * 当前登录的账号
 */
@property (nonatomic, strong,readonly) GDAccount *currentAccount;
/**
 * 是否安装了微博客户端
 */
@property (nonatomic,readonly,assign,getter=isWeiboAppInstalled) BOOL weiboAppInstalled;
/**
 * 是否可以分享
 */
@property (nonatomic,readonly,assign,getter=isCanShareInWeiboAPP) BOOL canShareInWeiboAPP;
/**
 * SSO是否可用
 */
@property (nonatomic,readonly,assign,getter=isCanSSOInWeiboApp) BOOL canSSOInWeiboApp;
/**
 * 授权是否过期
 */
@property (nonatomic,readonly,assign,getter=isAuthenticated) BOOL authenticated;


+ (instancetype)shareInstance;
/**
 * 向微博客户端程序注册第三方应用
 * @param appKey 微博开放平台第三方应用appKey
 * @return 注册成功返回YES，失败返回NO
 */
+ (BOOL)registerApp:(NSString *)appKey appSecret:(NSString *)appSecret redirectUrl:(NSString *)redirectUrl;
/**
 * 打开微博客户端程序（只是打开好像没什么蛋用）
 * @return 成功打开返回YES，失败返回NO
 */
- (BOOL)open;
/*
 * 第三方调用微博短信注册或者登陆
 * @param navTitle 为登陆页navigationBar的title，如果为空的话，默认为“验证码登陆”
 */
+ (void)messageRegister:(NSString *)navTitle;
/**
 * 如果安装了微博客户端并且支持SSO就跳转到客户端授权，没有安装或者不支持就打开web页登录授权
 * @param sso 是否使用SSO
 * @param complete 授权回调
 */
- (void)loginSSO:(BOOL)sso complete:(GDLoginCallBack)complete;
/**
 * @abstract 使用RefreshToken去换取新的身份凭证AccessToken.
 * @discussion 在SSO授权登录后，服务器会下发有效期为7天的refreshToken以及有效期为1天的AccessToken。
               当有效期为1天的AccessToken过期时，可以调用该接口带着refreshToken信息区换取新的AccessToken。
 * @param refreshToken 是否使用SSO
 * @param complete 回调
 */
- (void)updateAccessTokenUseRefreshToken:(NSString *)refreshToken complete:(GDUpdateAccessTokenCallBack)complete;
/**
 * 取消应用授权，将不能正常使用微博API
 */
- (void)logout;
/**
 * 设置WeiboSDK的调试模式
 * 当开启调试模式时，WeiboSDK会在控制台输出详细的日志信息，开发者可以据此调试自己的程序。默认为 NO
 @param enabled 开启或关闭WeiboSDK的调试模式
 */
+ (void)deBug:(BOOL)enabled;
/**
 * 发送微博
 * @param title 发送出去的连接的标题
 * @param content 发送出去的连接的描述
 * @param image 发送出去的连接的图片
 * @param content 发送出去的连接的地址
 */
- (void)post:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString*)url;

@end
