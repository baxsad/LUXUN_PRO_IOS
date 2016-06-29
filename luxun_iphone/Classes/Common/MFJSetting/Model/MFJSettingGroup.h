//
//  MFJSettingGroup.h
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFJSettingGroup : NSObject

@property (nonatomic,   copy) NSString * header; // 头部标题
@property (nonatomic,   copy) NSString * footer; // 尾部标题
@property (nonatomic, strong) NSArray  * items;  // 中间的条目

@end
