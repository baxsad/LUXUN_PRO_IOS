//
//  MFJSettingItem.h
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MFJSettingItemType) {
    MFJSettingItemTypeNone,  // 什么也没有
    MFJSettingItemTypeArrow, // 箭头
    MFJSettingItemTypeArrowSubTitle, // 箭头带描述
    MFJSettingItemTypeSubTitle, // 描述
    MFJSettingItemTypeSwitch // 开关
};

@interface MFJSettingItem : NSObject

@property (nonatomic,   copy) NSString *icon;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) NSString *subTitle;

@property (nonatomic, assign) MFJSettingItemType type;// Cell的样式
/** cell上开关的操作事件 */
@property (nonatomic,   copy) void (^switchBlock)(BOOL on) ;

@property (nonatomic,   copy) void (^selected)() ; // 点击cell后要执行的操作

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle type:(MFJSettingItemType)type;

@end
