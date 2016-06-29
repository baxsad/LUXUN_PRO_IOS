//
//  GDReq.h
//  2HUO
//
//  Created by iURCoder on 3/31/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDSecurityPolicy.h"
#import "GDDefines.h"

@class GDSecurityPolicy;
@class GDReq;

typedef void(^listenCallBack)(GDReq * _Nonnull req);

@interface GDReq : NSObject
/** 安全协议设置 */
@property (nonatomic,strong,nullable) GDSecurityPolicy         * securityPolicy;
/** 错误码返回 */
@property(nonatomic,strong,nullable)NSString                   * requestID;
/** 序列化后的数据 */
@property(nonatomic,strong,nullable)NSDictionary               * output;
/** 请求使用字典参数 */
@property(nonatomic,strong,nullable)NSMutableDictionary        * params;
/** 获取的字符串数据 */
@property(nonatomic,strong,nullable)NSString                   * responseString;
/** 请求的错误 */
@property(nonatomic,strong,nullable)NSError                    * error;
/** /Request状态 */
@property(nonatomic,assign)GDRequestStatus                       status;
/** 请求的链接 */
@property(nonatomic,strong,nullable)NSURL                      * url;
/** 错误消息或者服务器返回的MSG */
@property(nonatomic,strong,nullable)NSString                   * message;
/** 错误码返回 */
@property(nonatomic,strong,nullable)NSString                   * codeKey;
/** 正确码 */
@property(nonatomic,strong,nullable)NSString                   * exactitudeKey;
/** key path */
@property(nonatomic,strong,nullable)NSString                   * exactitudeKeyPath;
/** 协议（http:/https:/ftp:） */
@property(nonatomic,strong,nullable)NSString                   * SCHEME;
/** 域名 */
@property(nonatomic,strong,nullable)NSString                   * HOST;
/** 请求路径 */
@property(nonatomic,strong,nullable)NSString                   * PATH;
/** 追加的路径 */
@property(nonatomic,strong,nullable)NSString                   * APPENDPATH;
/** 其他路径 */
@property(nonatomic,strong,nullable)NSString                   * STATICPATH;
/** 提交方式 (GET/POST)*/
@property(nonatomic,copy,nullable)NSString                     * METHOD;
/** 是否需要检查错误码 */
@property(nonatomic,assign)BOOL                                  needCheckCode;
/** 返回数据格式 */
@property(nonatomic,assign)GDResponseSerializerType              responseSerializer;
/** 可接受的序列化返回数据的格式 */
@property(nonatomic,strong,nullable)NSSet                      * acceptableContentTypes;
/** Http头参数设置 */
@property(nonatomic,strong,nullable)NSDictionary               * httpHeaderFields;
/** 是否启动发送请求(为MVVM设计) */
@property(nonatomic,assign)BOOL                                  requestNeedActive;
/** AFN返回的NSURLSessionDataTask */
@property(nonatomic,strong,nullable)NSURLSessionDataTask       * task;
/** AFN返回的NSURLSessionDownloadTask */
@property(nonatomic,strong,nullable)NSURLSessionDownloadTask   * downloadTask;
/** 设置请求超时时间，默认是60S。*/
@property (nonatomic, assign) NSTimeInterval                     timeoutInterval;
/** 请求是否超时 */
@property(nonatomic,assign)BOOL                                  isTimeout;
/** 是否第一次加载 */
@property(nonatomic,assign)BOOL                                  isFirstRequest;
/** 缓存策略 */
@property (nonatomic,assign)GDRequestCachePolicy                 cachePolicy;

/** 上传文件列表 */
@property(nonatomic,strong,nullable)NSDictionary               * requestFiles;
/** 已上传数据大小 */
@property(nonatomic,assign)long long                             totalBytesWritten;
/** 全部需要上传的数据大小 */
@property(nonatomic,assign)long long                             totalBytesNeedToWrite;

@property (nonatomic, copy, nullable) void (^requestProgressBlock)( NSProgress * _Nullable progress);

/** 下载链接 */
@property(nonatomic,strong,nullable)NSString                   * downloadUrl;
/** 下载到目标路径 */
@property(nonatomic,strong,nullable)NSString                   * targetPath;
/** 已下载传数据大小 */
@property(nonatomic,assign)long long                             totalBytesRead;
/** 全部需要下载的数据大小 */
@property(nonatomic,assign)long long                             totalBytesNeedToRead;
/** 是否冻结，下次联网时继续(保留设计) */
@property(nonatomic,assign)BOOL                                  freezable;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (nonnull instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (nonnull instancetype)Request;

+ (nonnull instancetype)RequestWithMethod:(nonnull NSString *)method;

- (nonnull instancetype)initRequest;

- (nonnull instancetype)initWithRequestMethod:(nonnull NSString *)method;

- (BOOL)succeed;

- (BOOL)sending;

- (BOOL)failed;

- (BOOL)Error;

- (BOOL)cancled;

- (BOOL)timeOut;

- (void)start;

- (void)cancle;

- (void)listen:(nonnull listenCallBack)block;

- (nullable NSString*)requestID;

- (NSURLRequestCachePolicy)RequestCachePolicy;

- (nullable NSString *)appendPathInfo;

@end
