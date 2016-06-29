//
//  MFJSettingItem.m
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJSettingItem.h"

@implementation MFJSettingItem

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle type:(MFJSettingItemType)type
{
    MFJSettingItem *item = [[self alloc] init];
    item.icon     = icon;
    item.title    = title;
    item.subTitle = subTitle;
    item.type     = type;
    return item;
}

@end
