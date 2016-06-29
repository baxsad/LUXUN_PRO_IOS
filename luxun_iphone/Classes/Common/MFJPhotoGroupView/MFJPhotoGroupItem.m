//
//  MFJPhotoGroupItem.m
//  2HUO
//
//  Created by iURCoder on 3/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJPhotoGroupItem.h"

@interface MFJPhotoGroupItem()<NSCopying>

@end
@implementation MFJPhotoGroupItem

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.width < 1 || view.height < 1) return NO;
    return imageSize.height / imageSize.width > view.width / view.height;
}

- (id)copyWithZone:(NSZone *)zone {
    MFJPhotoGroupItem *item = [self.class new];
    return item;
}

@end
