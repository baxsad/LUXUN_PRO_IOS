//
//  LXPlayScene.h
//  luxun_iphone
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "IHBaseViewController.h"

@class Bangumi;

@interface LXPlayScene : IHBaseViewController

@property (nonatomic, strong) Bangumi * bangumi;

@end

@interface LXVideoSource : NSObject

@property (nonatomic, copy) NSString * sourceHOST;
@property (nonatomic, assign) BOOL isReadyUse;
+ (NSArray *)makeWithSource:(NSArray *)sources;

@end