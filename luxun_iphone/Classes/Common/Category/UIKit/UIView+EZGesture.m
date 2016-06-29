//
//  UIView+EZGesture.m
//  BiHu_iPhone
//
//  Created by iURCoder on 1/19/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "UIView+EZGesture.h"
#import <objc/runtime.h>

static char flashColorKey;


@implementation NSObject (Magic)
- (void)ezsetAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (id)ezgetAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}
@end

@implementation UIView (EZGesture)

- (void)addPinchGesture:(PinchGesture)block
{
    UIPinchGestureRecognizer * pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    pinch.delegate=self;
    [self ezsetAssociateWeakValue:block withKey:&flashColorKey];
    [self addGestureRecognizer:pinch];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    CGFloat scale=pinch.scale;
    PinchGesture block = [self ezgetAssociatedValueForKey:&flashColorKey];
    if (block) {
        block(scale);
    }
    pinch.scale=1;
}


-(void)whenTapped:(void (^)(void))block{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:recognizer];
    [recognizer.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer *sender){
        block();
    }];
}

+ (UIView *)getLine:(UIColor *)color rect:(CGRect)rect
{
    UIView * line = [[UIView alloc] initWithFrame:rect];
    line.backgroundColor = color;
    return line;
}

@end
