//
//  Account.m
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "AccountCenter.h"
#import "TMCache.h"
#import <YYWebImage/YYWebImage.h>
#import "GDWBSDK.h"

@implementation AccountCenter

+ (instancetype)shareInstance
{
    static AccountCenter *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[AccountCenter alloc] init];
    });
    return account;
}

- (void)save:(User *)user
{
    
    if (!user) {
        [[TMCache sharedCache] removeObjectForKey:kUSERCACHE];
        self.user = nil;
        self.sss =nil;
        self.userHeadFace = nil;
        return;
    }
    
    self.user = user;
    self.sss = user.sss;
    self.userHeadFace = [UIImage imageWithUrl:user.avatar];
    [[TMCache sharedCache] setObject:self.user forKey:kUSERCACHE block:^(TMCache* cache, NSString* key, id object) {
        
    }];
}

- (void)login:(UserLoginType)type complete:(UserLoginResultBlock)complete
{
    [[GDWBSDK shareInstance] loginSSO:YES complete:^(GDResponseStatusCode status, GDAccount *account) {
        if (status == GDResponseStatusCodeSuccess) {
            if (complete) {
                complete(YES,account.accessToken,account.uid);
            }
        }else{
            if (complete) {
                complete(NO,nil,nil);
            }
        }
    }];
}

- (void)logout
{
    [[GDWBSDK shareInstance] logout];
    [self save:nil];
}

- (void)clearCache:(ClearCacheCallBack)callback
{
    [[TMCache sharedCache] removeAllObjects];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        // progress
        if (callback) {
            callback(NO,removedCount/totalCount);
        }
    } endBlock:^(BOOL error) {
        // end
        if (callback) {
            callback(YES,1.0);
        }
    }];
    
}

@end
