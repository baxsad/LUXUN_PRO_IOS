//
//  NSTimer+HYSCat.h
//  iUR_Util
//
//  Created by iURCoder on 11/11/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (HYSCat)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;


+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;


@end
