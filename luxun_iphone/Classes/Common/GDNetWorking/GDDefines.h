//
//  GDNETDefines.h
//  2HUO
//
//  Created by iURCoder on 3/31/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#ifndef GDNETDefines_h
#define GDNETDefines_h

#import <AFNetworking/AFNetworking.h>
#import "GDKit.h"
#import "TMCache.h"
#import "GCDQueue.h"

#ifdef isTest

//测试接口

#define kFileUpload @"182.92.180.73"
static  NSString* const kWebBaseUrl = @"http://10.0.1.12:8081/iLikeTest/";

#define kHostPath @"http://0.luxun.pro:12580"

#else

//正式接口
#define kFileUpload @"182.92.180.73"
static NSString* const kWebBaseUrl = @"http://www.caimiapp.com/";

#define kHostPath @"http://0.luxun.pro:12580"

#endif

#define GD_REQUEST_RIGHT_CODE  0
#define GD_ERROR_CODE_PATH     @"error_code"

#define GD_CACHE_NAME  @"gd.request.url.cache.disk.biubiubiu"

// RequestCachePolicy
typedef NS_ENUM(NSUInteger, GDRequestCachePolicy) {
    GDRequestCachePolicyNoCache           = 0 , /**< 不缓存    */
    GDRequestCachePolicyReadCache         = 1 << 0, /**< 缓存,每次都优先从缓存读取    */
    GDRequestCachePolicyReadCacheFirst    = 1 << 1 /**< 缓存,第一次从缓存读取以后不读缓存    */
};

// 网络请求状态
typedef NS_ENUM(NSInteger, GDRequestStatus) {
    GDRequestStatusSending = 0 << 1,  /**< 请求发送中    */
    GDRequestStatusSuccess = 1 << 0,  /**< 请求成功      */
    GDRequestStatusFailed  = 1 << 1,  /**< 请求失败      */
    GDRequestStatusError   = 3 << 0,  /**< 请求错误      */
    GDRequestStatusCancle  = 1 << 2,  /**< 请求已取消    */
    GDRequestStatusTimeOut = 5,       /**< 请求超时      */
    GDRequestStatusNotStart= 6,       /**< 请求未开始    */
    GDRequestStatusStart   = 7        /**< 开始请求      */
};

// 请求返回的序列化格式
typedef NS_ENUM(NSUInteger, GDResponseSerializerType) {
    GDResponseSerializerTypeHTTP    = 0,
    GDResponseSerializerTypeJSON    = 1 << 0
};

/**
 *  SSL Pinning
 */
typedef NS_ENUM(NSUInteger, GDSSLPinningMode) {
    /**
     *  不校验Pinning证书
     */
    GDSSLPinningModeNone,
    /**
     *  校验Pinning证书中的PublicKey.
     *  知识点可以参考
     *  https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning
     */
    GDSSLPinningModePublicKey,
    /**
     *  校验整个Pinning证书
     */
    GDSSLPinningModeCertificate,
};

typedef void (^GDRequestBlock)(void);

// GD 默认的请求超时时间
#define GD_API_REQUEST_TIME_OUT     29
#define MAX_HTTP_CONNECTION_PER_HOST 5


#endif /* GDNETDefines_h */
