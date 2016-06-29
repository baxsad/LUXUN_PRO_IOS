//
//  MFJPhotoGroupCell.h
//  2HUO
//
//  Created by iURCoder on 3/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYAnimatedImageView.h>
#import "MFJPhotoGroupItem.h"

@interface MFJPhotoGroupCell : UIScrollView<UIScrollViewDelegate>
/**
 *  内容视图
 */
@property (nonatomic,   strong) UIView        * imageContainerView;
/**
 *  图片视图
 */
@property (nonatomic,   strong) UIImageView   * imageView;
/**
 *  当前图片页码
 */
@property (nonatomic,   assign) NSInteger        page;
/**
 *  是否显示加载进度
 */
@property (nonatomic,   assign) BOOL            showProgress;
/**
 *  图片加载进度
 */
@property (nonatomic,   assign) CGFloat         progress;
/**
 *  进度条
 */
@property (nonatomic,   strong) CAShapeLayer  * progressLayer;
/**
 *  item对象
 */
@property (nonatomic,   strong) MFJPhotoGroupItem * item;
/**
 *  是否加载完毕
 */
@property (nonatomic, readonly) BOOL              itemDidLoad;

- (void)resizeSubviewSize;

@end
