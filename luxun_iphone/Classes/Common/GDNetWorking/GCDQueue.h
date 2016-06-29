//
//  GCDQueue.h
//  2HUO
//
//  Created by iURCoder on 4/12/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDGroup : NSObject
@property (strong, readonly, nonatomic) dispatch_group_t dispatchGroup;
- (instancetype)init;
- (instancetype)initWithDispatchGroup:(dispatch_group_t)dispatchGroup;
- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(double)seconds;
@end

@interface GCDQueue : NSObject

@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueue;
+ (GCDQueue *)highPriorityGlobalQueue;
+ (GCDQueue *)lowPriorityGlobalQueue;
+ (GCDQueue *)backgroundPriorityGlobalQueue;
- (instancetype)init;
- (instancetype)initSerial;
- (instancetype)initConcurrent;
- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue;
- (void)queueBlock:(dispatch_block_t)block;
- (void)queueBlock:(dispatch_block_t)block afterDelay:(double)seconds;
- (void)queueAndAwaitBlock:(dispatch_block_t)block;
- (void)queueAndAwaitBlock:(void (^)(size_t))block iterationCount:(size_t)count;
- (void)queueBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)queueNotifyBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)queueBarrierBlock:(dispatch_block_t)block;
- (void)queueAndAwaitBarrierBlock:(dispatch_block_t)block;
- (void)suspend;
- (void)resume;

@end
