//
//  GDTableViewPlaceHolderDelegate.h
//  luxun_iphone
//
//  Created by iURCoder on 4/20/16.
//  Copyright © 2016 iUR. All rights reserved.
//

@protocol GDPlaceHolderDelegate <NSObject>

@required
/*!
 @brief  make an empty overlay view when the tableView is empty
 @return an empty overlay view
 */
- (UIView *)makePlaceHolderView;

@optional
/*!
 @brief enable tableView scroll when place holder view is showing, it is disabled by default.
 @attention There is no need to return  NO, it will be NO by default
 @return enable tableView scroll, you can only return YES
 */
- (BOOL)enableScrollWhenPlaceHolderViewShowing;

@end

