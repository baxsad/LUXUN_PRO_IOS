//
//  LXRequest.h
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDReq.h"

@interface LXRequest : GDReq

// 授权后获取用户信息
+ (GDReq*)getUserInfoRequest;

// 用户登录授权
+ (GDReq*)userLoginRequest;

// 追番
+ (GDReq*)getComicListRequest;

// 时间线
+ (GDReq*)getTimeLineRequest;

// 获取弹幕
+ (GDReq*)getDanMuRequest;

// 获取专题
+ (GDReq*)getTopicsRequest;

@end
