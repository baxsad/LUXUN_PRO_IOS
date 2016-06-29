//
//  BangumiFrameModel.m
//  luxun_iphone
//
//  Created by iURCoder on 4/19/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "BangumiFrameModel.h"
#import "Bangumis.h"
#import <YYText/YYText.h>

@implementation BangumiFrameModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat itemWidth = (SCREEN_WIDTH-(ITEM_NUMBER_INLINE+1)*ITEM_PADDING)/ITEM_NUMBER_INLINE;
        CGFloat itemHeight = itemWidth/RATIO_OF_LENGTH_TO_WIDTH;
        _itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    return self;
}

- (void)setBangumi:(Bangumi *)bangumi
{
    if (_bangumi != bangumi) {
        _bangumi = bangumi;
        [self layout];
    }
}

- (void)layout
{
    [self reset];
    if (!_bangumi) return;
    self.bangumiIconFrame = CGRectMake(0, 0, _itemSize.width, _itemSize.height);
    self.blurFrame = _bangumiIconFrame;
    

    CGSize setSize = [_bangumi.cur sizeForFont:kSetFount size:_itemSize mode:NSLineBreakByWordWrapping];
    _setLableFrame = CGRectMake(kSetBackGroundImageMarginLeft, kSetBackGroundImageMarginTop, setSize.width + 2 * kSetBackGroundImagePadding, kSetBackGroundImageHeight);
    
    _setBackGroundImageFrame = _setLableFrame;
    _setBackGroundImageFrame.size.height = kSetBackGroundImageHeight;
    
    NSMutableAttributedString *titleNameText = [[NSMutableAttributedString alloc] initWithString:_bangumi.title];
    titleNameText.yy_font = kTitlNameFount;
    titleNameText.yy_color = kTitlNameTextColor;
    titleNameText.yy_alignment = NSTextAlignmentLeft;
    
    YYTextLayout * titleTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(_itemSize.width - 2.0*kSetTitleMarginLeftandRight, _itemSize.height) text:titleNameText];
    CGFloat titleY = _itemSize.height - kSetTitleMarginBottom - titleTextLayout.textBoundingSize.height;
    _titleLableFrame = CGRectMake(kSetTitleMarginLeftandRight, titleY, titleTextLayout.textBoundingSize.width, titleTextLayout.textBoundingSize.height);
    
    // 视频页
    
    NSInteger remainder = _bangumi.sets.count%SET_ITEM_NUMBER_IN_LINE;
    NSInteger lineNumber;
    if (remainder == 0) {
        lineNumber = _bangumi.sets.count/SET_ITEM_NUMBER_IN_LINE;
    }else{
        lineNumber = _bangumi.sets.count/SET_ITEM_NUMBER_IN_LINE + 1;
    }
    if (_bangumi.sets.count<=SET_ITEM_NUMBER_IN_LINE) {
        lineNumber = 1;
    }
    CGFloat height = lineNumber*SET_ITEM_HEIGHT + SET_ITEM_MARGIN__T_B*(lineNumber-1);
    _player_setsCollectionFrame = CGRectMake(0, kCollectionPadding, SCREEN_WIDTH, height);
    _player_setsCellHeight = height + kCollectionPadding * 2;
    
    CGFloat player_bangumiIconWidth = (SCREEN_WIDTH-2*kCellMargin)/3.0;
    CGFloat player_bangumiIconHeight = player_bangumiIconWidth/kIconRatio;
    CGRect player_bangumiIconFrame = CGRectMake(kCellMargin, kCellMargin, player_bangumiIconWidth, player_bangumiIconHeight);
    _player_bangumiIconFrame = player_bangumiIconFrame;
    
    CGFloat rightWidth = 2*player_bangumiIconWidth - kCellMargin;
    CGFloat leftInfoX = player_bangumiIconWidth + 2*kCellMargin;
    NSMutableAttributedString *playerBangumiTitleText = [[NSMutableAttributedString alloc] initWithString:_bangumi.title];
    playerBangumiTitleText.yy_font = kTitleFount;
    playerBangumiTitleText.yy_alignment = NSTextAlignmentLeft;
    YYTextLayout * playerTitleLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(rightWidth, 23) text:playerBangumiTitleText];
    _player_bangumiTitleFrame = CGRectMake(leftInfoX, kTitleMarginTop, playerTitleLayout.textBoundingSize.width, playerTitleLayout.textBoundingSize.height);
    
    _bangumi.weekString = [self weekString:_bangumi.week];
    NSMutableAttributedString *playerWeekText = [[NSMutableAttributedString alloc] initWithString:_bangumi.weekString];
    playerWeekText.yy_font = kWeekFount;
    playerWeekText.yy_alignment = NSTextAlignmentLeft;
    YYTextLayout * playerWeekLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(rightWidth, player_bangumiIconHeight) text:playerWeekText];
    CGFloat weekY = _player_bangumiTitleFrame.origin.y + _player_bangumiTitleFrame.size.height + kLineMargin;
    _player_bangumiWeekFrame = CGRectMake(leftInfoX, weekY, playerWeekLayout.textBoundingSize.width, playerWeekLayout.textBoundingSize.height);
    
    NSMutableAttributedString *playerDesText = [[NSMutableAttributedString alloc] initWithString:_bangumi.text];
    playerDesText.yy_font = kDesFount;
    playerDesText.yy_alignment = NSTextAlignmentLeft;
    playerDesText.yy_lineSpacing = 5;
    CGFloat desMaxHeight = player_bangumiIconHeight - _player_bangumiWeekFrame.origin.y - _player_bangumiWeekFrame.size.height + 10 - kLineMargin;
    YYTextLayout * playerDesLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(rightWidth,desMaxHeight ) text:playerDesText];
    CGFloat desY = _player_bangumiWeekFrame.origin.y + _player_bangumiWeekFrame.size.height + kLineMargin;
    _player_bangumiDesFrame = CGRectMake(leftInfoX, desY, playerDesLayout.textBoundingSize.width, playerDesLayout.textBoundingSize.height);
    
    _player_infoCellHeight = player_bangumiIconHeight + 2*kCellMargin;
}

- (NSString *)weekString:(NSInteger)week
{
    switch (week) {
        case 1:
            return @"周一更新";
            break;
        case 2:
            return @"周二更新";
            break;
        case 3:
            return @"周三更新";
            break;
        case 4:
            return @"周四更新";
            break;
        case 5:
            return @"周五更新";
            break;
        case 6:
            return @"周六更新";
            break;
        case 0:
            return @"周日更新";
            break;
            
        default:
            return @"最近更新";
            break;
    }
}

- (void)reset
{
    _bangumiIconFrame = CGRectZero;
    _setBackGroundImageFrame = CGRectZero;
    _setLableFrame = CGRectZero;
    _titleLableFrame = CGRectZero;
    _blurFrame = CGRectZero;
    
    _player_setsCellHeight = 0.0f;
    _player_infoCellHeight = 0.0f;
    _player_setsCollectionFrame = CGRectZero;
    _player_bangumiIconFrame = CGRectZero;
    _player_bangumiTitleFrame = CGRectZero;
    _player_bangumiWeekFrame = CGRectZero;
    _player_bangumiDesFrame = CGRectZero;
    _player_bangumiCollectFrame = CGRectZero;
}

@end
