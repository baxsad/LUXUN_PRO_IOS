//
//  LXBangumiSetCell.h
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Set;
@interface LXBangumiSetCell : UICollectionViewCell
- (void)configModel:(Set *)model isselected:(bool)selected;
@end
