//
//  DataCenter.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "DataCenter.h"
#import "Bangumis.h"

@interface DataCenter ()

@property (nonatomic,strong) NSMutableDictionary * data;

@end

@implementation DataCenter

+ (instancetype)defaultCenter
{
    
    static dispatch_once_t pred;
    static DataCenter *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.data = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
    
}


- (id)luxunData
{
    return [[TMCache sharedCache] objectForKey:kLUXUNDATA];
}

- (void)setLuxunData:(id)luxunData
{
    [self.data removeAllObjects];
    // 所有的数据数组
    NSMutableArray * allData = [NSMutableArray array];
    // 获取updating数据数组
    NSArray *updating = luxunData[@"updating"];
    // updating数据加入数组
    [allData addObjectsFromArray:updating];
    
    NSArray * quars = luxunData[@"quars"];
    for (NSDictionary * dic in quars) {
        NSArray * bangumis = dic[@"bangumis"];
        [allData addObjectsFromArray:bangumis];
    }
    
    [[TMCache sharedCache] setObject:allData forKey:kLUXUNDATA];
}

- (Bangumis *)getBangumisFromDic:(NSDictionary *)dic
{
    NSMutableArray * response = [NSMutableArray array];
    NSArray * arr = dic[@"list"];
    NSArray * allData = [DataCenter defaultCenter].luxunData;
    @weakify(response,allData);
    [arr enumerateObjectsUsingBlock:^(id sobj, NSUInteger idx, BOOL *stop) {
        @strongify(response,allData);
        NSString * soriginal = sobj[@"original"];
        [allData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary * cacheDic = [NSMutableDictionary dictionaryWithDictionary:obj];
            NSString * original = cacheDic[@"original"];
            if ([original isEqualToString:soriginal]) {
                cacheDic[@"filename"] = sobj[@"filename"];
                cacheDic[@"cur"] = sobj[@"cur"];
                cacheDic[@"created"] = sobj[@"created"];
                [response addObject:cacheDic];
            }
        }];
    }];
    
    NSDictionary * bangumis = @{@"bangumis":response};
    
    Bangumis * bgms = [[Bangumis alloc] initWithDictionary:bangumis error:nil];
    
    return bgms;
}

- (NSArray *)searchBngumiWithKeyWord:(NSString *)keyWord
{
    return nil;
}

- (Bangumis *)getBangumisFromTopicsBangumis:(NSString *)bangumis
{
    NSMutableArray * response = [NSMutableArray array];
    NSArray * bangumisNameArray = [bangumis componentsSeparatedByString:@"\n"];
    NSArray * allData = [DataCenter defaultCenter].luxunData;
    @weakify(response,allData);
    [bangumisNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(response,allData);
        NSString * bangumiName = (NSString *)obj;
        [allData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary * cacheDic = [NSMutableDictionary dictionaryWithDictionary:obj];
            NSString * title = cacheDic[@"title"];
            if ([title isEqualToString:bangumiName]) {
                [response addObject:cacheDic];
            }
        }];
    }];
    
    NSDictionary * bangumisJson = @{@"bangumis":response};
    
    Bangumis * bgms = [[Bangumis alloc] initWithDictionary:bangumisJson error:nil];
    
    for (Bangumi * b in bgms.bangumis) {
        BangumiFrameModel * frameModel = [[BangumiFrameModel alloc] init];
        frameModel.bangumi = b;
        b.frameModel = frameModel;
    }
    
    return bgms;
}

@end
