//
//  GDSecurityPolicy.h
//  2HUO
//
//  Created by iURCoder on 4/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDDefines.h"

@interface GDSecurityPolicy : NSObject

/**
 *  SSL Pinning证书的校验模式
 *  默认为 DRDSSLPinningModeNone
 */
@property (readonly, nonatomic, assign) GDSSLPinningMode SSLPinningMode;

/**
 *  是否允许使用Invalid 证书
 *  默认为 NO
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 *  是否校验在证书 CN 字段中的 domain name
 *  默认为 YES
 */
@property (nonatomic, assign) BOOL validatesDomainName;

/**
 *  创建新的SecurityPolicy
 *
 *  @param pinningMode 证书校验模式
 *
 *  @return 新的SecurityPolicy
 */
+ (instancetype)policyWithPinningMode:(GDSSLPinningMode)pinningMode;

@end
