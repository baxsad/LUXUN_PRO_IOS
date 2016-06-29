//
//  GDBarrageClock.h
//  luxun_iphone
//
//  Created by iURCoder on 4/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDBarrageClock : NSObject

/// 通过回调block初始化时钟,block中返回逻辑时间,其值会受到speed的影响.
+ (instancetype)clockWithHandler:(void (^)(NSTimeInterval time))block;

/// 时间流速,默认值为1.0f; 设置必须大于0,否则无效.
@property(nonatomic,assign)CGFloat speed;

/// 启动时间引擎,根据刷新频率返回逻辑时间.
- (void)start;

/// 关闭时间引擎; 一些都已结束,或者重新开始,或者归于沉寂.
- (void)stop;

/// 暂停,相等于把speed置为0; 不过通过start可以恢复.
- (void)pause;


@end
