//
//  WeChatStylePlaceHolder.h
//  CYLTableViewPlaceHolder
//
//  Created by 陈宜龙 on 15/12/23.
//  Copyright © 2015年 http://weibo.com/luohanchenyilong/ ÂæÆÂçö@iOSÁ®ãÂ∫èÁä≠Ë¢Å. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotDataPlaceHolderDelegate <NSObject>

@required

- (void)emptyOverlayClicked:(id)sender;

@end

@interface NotDataPlaceHolder : UIView

@property (nonatomic, weak) id<NotDataPlaceHolderDelegate> delegate;

@end
