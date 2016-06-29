//
//  Account.h
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>


@class User;

typedef NS_ENUM(NSUInteger, UserLoginType) {
    UserLoginTypeWeiBo                = 0,
    UserLoginTypeOICQ                 = 1,
};

typedef void (^UserLoginCallBack)(BOOL success);
typedef void (^UserLoginResultBlock)(BOOL success, NSString * token,NSString *uid);
typedef void (^UserLogoutCallBack)(BOOL success);
typedef void (^ClearCacheCallBack)(BOOL success,CGFloat progress);

@interface AccountCenter : NSObject

@property (nonatomic, strong) User     * user;
@property (nonatomic,   copy) NSString * sss;
@property (nonatomic, strong) UIImage  * userHeadFace;

+ (instancetype)shareInstance;

- (void)save:(User *)user;

- (void)login:(UserLoginType)type complete:(UserLoginResultBlock)complete;

- (void)logout;

- (void)clearCache:(ClearCacheCallBack)callback;

@end
