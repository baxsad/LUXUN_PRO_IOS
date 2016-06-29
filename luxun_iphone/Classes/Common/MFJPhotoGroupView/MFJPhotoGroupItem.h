//
//  MFJPhotoGroupItem.h
//  2HUO
//
//  Created by iURCoder on 3/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFJPhotoGroupItem : NSObject
/**
 *  缩略图view
 */
@property (nonatomic,   strong) UIView  * thumbView;
/**
 *  原图尺寸
 */
@property (nonatomic,   assign) CGSize    largeImageSize;
/**
 *  原图url
 */
@property (nonatomic,   strong) NSURL   * largeImageURL;
/**
 *  缩略图 image 对象
 */
@property (nonatomic, readonly) UIImage * thumbImage;
@property (nonatomic, readonly) BOOL      thumbClippedToTop;
- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;
@end
