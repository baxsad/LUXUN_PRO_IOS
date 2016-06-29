//
//  LXTableView.m
//  luxun_iphone
//
//  Created by iURCoder on 4/19/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXTableView.h"

@implementation LXTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}

@end
