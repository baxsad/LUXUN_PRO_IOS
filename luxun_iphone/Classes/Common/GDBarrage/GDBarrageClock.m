//
//  GDBarrageClock.m
//  luxun_iphone
//
//  Created by iURCoder on 4/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDBarrageClock.h"

@interface GDBarrageClock()
{
    void (^_block)(NSTimeInterval time);
    CADisplayLink * _displayLink; // 周期
    NSDate * _previousDate; // 上一次更新时间
    CGFloat _pausedSpeed; // 暂停之前的时间流速
}
///是否处于启动状态
@property(nonatomic,assign)BOOL launched;
///逻辑时间
@property(nonatomic,assign)NSTimeInterval time;

@end

@implementation GDBarrageClock

+ (instancetype)clockWithHandler:(void (^)(NSTimeInterval time))block
{
    GDBarrageClock * clock = [[GDBarrageClock alloc]initWithHandler:block];
    return clock;
}

- (instancetype)initWithHandler:(void (^)(NSTimeInterval time))block
{
    if (self = [super init]) {
        _block = block;
        [self reset];
    }
    return self;
}

- (void)reset
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    _speed = 1.0f;
    _pausedSpeed = _speed;
    self.launched = NO;
}

- (void)update
{
    [self updateTime];
    _block(self.time);
}

- (void)start
{
    if (self.launched) {
        _speed = _pausedSpeed;
    }
    else
    {
        _previousDate = [NSDate date];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.launched = YES;
    }
}

- (void)setSpeed:(CGFloat)speed
{
    if (speed > 0.0f) {
        if (_speed != 0.0f) { // 非暂停状态
            _speed = speed;
        }
        _pausedSpeed = speed;
    }
}

- (void)pause
{
    _speed = 0.0f;
}

- (void)stop
{
    [_displayLink invalidate];
    [self reset];
}

/// 更新逻辑时间系统
- (void)updateTime
{
    NSDate * currentDate = [NSDate date];
    self.time += [currentDate timeIntervalSinceDate:_previousDate] * self.speed;
    _previousDate = currentDate;
}


@end
