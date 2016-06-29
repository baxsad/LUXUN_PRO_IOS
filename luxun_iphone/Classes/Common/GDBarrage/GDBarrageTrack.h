//
//  GDBarrageTrack.h
//  luxun_iphone
//
//  Created by iURCoder on 4/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDBarrageLable;
/**
 *  轨道状态
 */
typedef NS_ENUM(NSUInteger, TrackState) {
    /**
     *  轨道空闲
     */
    TrackStateFree = 0,
    /**
     *  轨道繁忙
     */
    TrackStateBusy
};

@interface GDBarrageTrack : NSObject

@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,assign) TrackState state;

@property (nonatomic,weak) GDBarrageLable * lastElement;

@property (nonatomic,assign) CGFloat freeSpace;

@property (nonatomic,assign) CGRect trackFrame;

@end
