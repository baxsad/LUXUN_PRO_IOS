//
//  GDBarrage.h
//  luxun_iphone
//
//  Created by iURCoder on 4/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "GDBarrageElement.h"

/**
 *  弹幕状态
 */
typedef NS_ENUM(NSUInteger, BarrageState) {
    /**
     *  弹幕准备
     */
    BarrageWait = 1,
    /**
     *  弹幕关闭
     */
    BarrageStop,
    /**
     *  弹幕运动
     */
    BarrageStart,
    /**
     *  弹幕暂停
     */
    BarragePause
};

@protocol GDBarrageElement;


@interface GDBarrageConfiguration : NSObject

@property (nonatomic) CGFloat fontSize;

@end


@interface GDBarrage : NSObject

/**
 *  弹幕显示所在的UIView
 */
@property (nonatomic,strong,readonly)UIView * view;

/**
 *  弹幕状态
 */
@property (nonatomic,assign,readonly) BarrageState barrageState;

- (instancetype)initWithView:(UIView *)view Configuration:(GDBarrageConfiguration *)configuration;

/**
 *  弹幕滚动
 */
- (void)start;

/**
 *  弹幕暂停
 */
- (void)pause;

/**
 *  弹幕停止
 */
- (void)stop;

/**
 *  发射弹幕
 *
 *  @param element 弹幕对象
 */
- (void)receive:(GDBarrageElement *)element;

/**
 *  加载弹幕
 *
 *  @param element 弹幕对象集合
 */
- (void)load:(NSArray<GDBarrageElement> *)elements;

@end
