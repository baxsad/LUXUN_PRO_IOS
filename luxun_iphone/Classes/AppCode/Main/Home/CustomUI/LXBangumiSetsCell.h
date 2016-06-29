//
//  LXBangumiSetsCell.h
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Bangumi;

@protocol LXBangumiSetSelectDelegate <NSObject>

- (void)setDidSelectedAtIndex:(NSInteger)index;

@end

@interface LXBangumiSetsCell : UITableViewCell

@property (nonatomic, weak, nullable) id<LXBangumiSetSelectDelegate>delegate;

- (void)configModel:(nullable Bangumi *)model;

@end
