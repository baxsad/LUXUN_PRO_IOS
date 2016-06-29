//
//  NSDate+HYSCat.m
//  BiHu_iPhone
//
//  Created by iURCoder on 11/23/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "NSDate+HYSCat.h"
#import <objc/runtime.h>

static const void *diffKey = &diffKey;
@implementation NSDate (HYSCat)
@dynamic diff;

- (NSString *)dateToString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

- (NSString *)dateToStringWithFormatterType:(NSString *)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

+ (NSDate *)systemDate
{
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    return [today dateByAddingTimeInterval:interval];
}

+ (NSString *)systemTimeStamp
{
    return [NSString stringWithFormat:@"%ld",(long)[[self systemDate] timeIntervalSince1970]];
}

- (NSString *)dateToTimeStamp
{
    return [NSString stringWithFormat:@"%ld",(long)[self timeIntervalSince1970]];
}

- (NSDate * (^)(NSDate*))equalTo
{
    return ^NSDate * (NSDate *otherDate){
        self.diff = [NSString stringWithFormat:@"%li",-(self.dateToTimeStamp.integerValue - otherDate.dateToTimeStamp.integerValue)];
        return self;
    };
}

- (NSString *)diffString
{
    return self.diff;
}

- (CGFloat   )diffFloat
{
    return self.diff.floatValue;
}

- (NSNumber *)diffNumber
{
    return self.diff.numberValue;
}

- (NSString *)diff
{
    return objc_getAssociatedObject(self, diffKey);
}

- (void)setDiff:(NSString *)diff
{
    objc_setAssociatedObject(self, diffKey, diff, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
