//
//  GDRequestManager.h
//  2HUO
//
//  Created by iURCoder on 4/1/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDReq,GDGroupReq;

typedef void(^listenCallBack)(GDReq * _Nonnull req);

@interface GDAction : NSObject

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (nonnull instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (nonnull instancetype)shareInstance;

+ (nonnull instancetype)action;

- (void)Send:(nonnull GDReq  *)req;

- (void)sendRequests:(nonnull GDGroupReq *)groupreq;

- (void)cancelRequest:(nonnull GDReq  *)req;

- (void)listen:(nonnull listenCallBack)block;

- (nullable id)getCacheFromUrl:(nonnull GDReq *)req;

- (void)clearAllCache;

- (void)clearCacheFromUrl:(nonnull GDReq *)req;

@end
