//
//  DanMu.m
//  luxun_iphone
//
//  Created by 王锐 on 16/8/18.
//  Copyright © 2016年 iUR. All rights reserved.
//

#import "DanMu.h"

@implementation DanMu

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (instancetype)setUp
{
    if (self.danmuList.count>0) {
        NSMutableDictionary * danmus = @{}.mutableCopy;
        for (NSArray * data in self.danmuList) {
            DanMuData * dmData = [[DanMuData alloc] init];
            dmData.n1 = data[0];
            dmData.n2 = data[1];
            dmData.title = data[2];
            dmData.color = [UIColor colorWithHexString:data[3]];
            dmData.showTime = data[4];
            dmData.note = data[5];
            [danmus setObject:dmData forKey:[NSString stringWithFormat:@"key_%@",dmData.showTime]];
        }
        self.DMKu = [NSDictionary dictionaryWithDictionary:danmus];
    }
    return self;
}

@end

@implementation DanMuData

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end