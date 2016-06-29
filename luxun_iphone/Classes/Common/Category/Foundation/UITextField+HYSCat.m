//
//  UITextField+HYSCat.m
//  VSCAM_Photo_Group_iPhone
//
//  Created by iURCoder on 12/10/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "UITextField+HYSCat.h"

@implementation UITextField (HYSCat)

- (void)whenValueChanged:(void (^)(UITextField *sender))block
{
    [self addBlockForControlEvents:UIControlEventEditingChanged block:^(id sender) {
        block(sender);
    }];
}

@end
