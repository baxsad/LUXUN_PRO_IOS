//
//  BangumiFrameModel.h
//  luxun_iphone
//
//  Created by iURCoder on 4/19/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 首页

#define kSetFount  [UIFont boldSystemFontOfSize:13]
#define kTitlNameFount  [UIFont boldSystemFontOfSize:14]

#define kSetTextColor UIColorHex(0xffffff)
#define kTitlNameTextColor UIColorHex(0xffffff)

#define kSetBackGroundImagePadding 5.0f
#define kSetBackGroundImageHeight 20.0f
#define kSetBackGroundImageMarginTop 7.0f
#define kSetBackGroundImageMarginLeft 7.0f
#define kSetTitleMarginLeftandRight 5.0f
#define kSetTitleMarginBottom 7.0f

#pragma mark 视频页

#define kCellMargin 10.0f
#define kCollectionPadding 10.0f
#define kIconRatio 0.8f
#define kTitleMarginTop 15.0f
#define kTitleFount [UIFont boldSystemFontOfSize:19]
#define kWeekFount [UIFont systemFontOfSize:14]
#define kDesFount [UIFont systemFontOfSize:13]
#define kLineMargin 15.0f

@class Bangumi;
@interface BangumiFrameModel : NSObject
/*
 * 首页
 */
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) Bangumi *bangumi;
@property (nonatomic, assign) CGRect bangumiIconFrame;
@property (nonatomic, assign) CGRect setBackGroundImageFrame;
@property (nonatomic, assign) CGRect setLableFrame;
@property (nonatomic, assign) CGRect titleLableFrame;
@property (nonatomic, assign) CGRect blurFrame;
/*
 * 视频页
 */
@property (nonatomic, assign) CGFloat player_setsCellHeight;
@property (nonatomic, assign) CGFloat player_infoCellHeight;
@property (nonatomic, assign) CGRect player_setsCollectionFrame;
@property (nonatomic, assign) CGRect player_bangumiIconFrame;
@property (nonatomic, assign) CGRect player_bangumiTitleFrame;
@property (nonatomic, assign) CGRect player_bangumiWeekFrame;
@property (nonatomic, assign) CGRect player_bangumiDesFrame;
@property (nonatomic, assign) CGRect player_bangumiCollectFrame;
- (instancetype)init;
- (void)layout;
@end
