//
//  CALayer+MFJExtent.h
//  2HUO
//
//  Created by iURCoder on 3/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (MFJExtent)

- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

- (void)removePreviousFadeAnimation;

- (void)setTransformScale:(CGFloat)v;

- (void)setCenter:(CGPoint)center;

@end
