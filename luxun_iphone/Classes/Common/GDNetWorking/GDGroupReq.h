//
//  GDGroupReq.h
//  2HUO
//
//  Created by iURCoder on 4/2/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDReq;
@class GDGroupReq;

@protocol GDGroupRequestsProtocol <NSObject>

- (void)groupRequestsDidFinished:(nonnull GDGroupReq *)groupReq;

@end

@interface GDGroupReq : NSObject

@property (nonatomic, strong, readonly, nullable) NSMutableSet *requestsSet;

@property (nonatomic, weak, nullable) id<GDGroupRequestsProtocol> delegate;

- (void)addRequest:(nonnull GDReq *)req;

- (void)addRequests:(nonnull NSSet *)reqs;

- (void)start;

@end
