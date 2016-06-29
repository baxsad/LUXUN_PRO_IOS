//
//  UIView+EZGesture.h
//  BiHu_iPhone
//
//  Created by iURCoder on 1/19/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PinchGesture)(CGFloat scale);

@interface NSObject (Magic)
- (void)ezsetAssociateWeakValue:(id)value withKey:(void *)key;
- (id)ezgetAssociatedValueForKey:(void *)key;
@end

@interface UIView (EZGesture)<UIGestureRecognizerDelegate>

-(void)whenTapped:(void (^)(void))block;

- (void)addPinchGesture:(PinchGesture)block;//<- 捏合手势

+ (UIView *)getLine:(UIColor *)color rect:(CGRect)rect;

@end
