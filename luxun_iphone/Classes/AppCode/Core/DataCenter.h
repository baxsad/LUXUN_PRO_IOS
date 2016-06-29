//
//  DataCenter.h
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Bangumis;
@interface DataCenter : NSObject

@property (nonatomic,strong) id luxunData;

+ (instancetype)defaultCenter;

@property (nonatomic, assign) BOOL isWifi;
@property (nonatomic) BOOL networkAvailable;

- (Bangumis *)getBangumisFromDic:(NSDictionary *)dic;

- (NSArray *)searchBngumiWithKeyWord:(NSString *)keyWord;

- (Bangumis *)getBangumisFromTopicsBangumis:(NSString *)bangumis;

@end
