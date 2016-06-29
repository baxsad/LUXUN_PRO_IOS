//
//  UIDevice+HYSCat.h
//  BiHu_iPhone
//
//  Created by iURCoder on 12/2/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (HYSCat)


#pragma mark - Device Information

/// 系统版本号
+ (float)systemVersion;

/// 是否是 ipad
@property (nonatomic, readonly) BOOL isPad;

/// 是否是模拟器
@property (nonatomic, readonly) BOOL isSimulator;

/// 是否越狱
@property (nonatomic, readonly) BOOL isJailbroken;

/// 是否可以打电话
@property (nonatomic, readonly) BOOL canMakePhoneCalls;

/// 机器型号
@property (nonatomic, readonly) NSString *machineModel;

/// 机器型号名字
@property (nonatomic, readonly) NSString *machineModelName;

/// 系统启动时间
@property (nonatomic, readonly) NSDate *systemUptime;


#pragma mark - Network Information
/// ip 地址
@property (nonatomic, readonly) NSString *ipAddressWIFI;

/// 本机 ip 地址
@property (nonatomic, readonly) NSString *ipAddressCell;


#pragma mark - Disk Space
/// 磁盘空间大小
@property (nonatomic, readonly) int64_t diskSpace;

/// 空闲磁盘空间大小
@property (nonatomic, readonly) int64_t diskSpaceFree;

/// 已使用磁盘空间大小
@property (nonatomic, readonly) int64_t diskSpaceUsed;


#pragma mark - Memory Information
/// 内存大小
@property (nonatomic, readonly) int64_t memoryTotal;

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryUsed;

/// Free memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryFree;

/// Acvite memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryActive;

/// Inactive memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryInactive;

/// Wired memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryWired;

/// Purgable memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// Avaliable CPU processor count.
@property (nonatomic, readonly) NSUInteger cpuCount;

/// Current CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float cpuUsage;

/// Current CPU usage per processor (array of NSNumber), 1.0 means 100%. (nil when error occurs)
@property (nonatomic, readonly) NSArray *cpuUsagePerProcessor;

@end


#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

