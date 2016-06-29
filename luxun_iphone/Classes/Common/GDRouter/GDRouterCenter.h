//
//  GDRouterCenter.h
//  2HUO
//
//  Created by iURCoder on 4/14/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class GDRouterAction;

@interface GDRouterAction : NSObject

@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic) Class target;
@property (nonatomic) SEL action;

@end

@interface GDRouterCenter : NSObject

@property (nonatomic, copy)NSString *scheme;

+ (instancetype)defaultCenter;

- (GDRouterAction *)actionOfPath:(NSString *)path;

- (NSMutableDictionary *)queryItemsInPath:(NSString *)path;

- (BOOL)model:(id)object params:(NSDictionary *)params;

@end
