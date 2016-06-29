//
//  GDSecurityPolicy.m
//  2HUO
//
//  Created by iURCoder on 4/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDSecurityPolicy.h"

@interface GDSecurityPolicy ()

@property (readwrite, nonatomic, assign) GDSSLPinningMode SSLPinningMode;

@end

@implementation GDSecurityPolicy

+ (instancetype)policyWithPinningMode:(GDSSLPinningMode)pinningMode {
    GDSecurityPolicy *securityPolicy = [[GDSecurityPolicy alloc] init];
    if (securityPolicy) {
        securityPolicy.SSLPinningMode           = pinningMode;
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName      = YES;
    }
    return securityPolicy;
}

@end
