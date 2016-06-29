//
//  UIViewController+HYSCat.m
//  2HUO
//
//  Created by iURCoder on 3/21/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "UIViewController+HYSCat.h"

@implementation UIViewController (HYSCat)

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        for (NSString * key in params) {
            [self setValue:params[key] forKey:key];
        }
    }
    return self;
}

@end
