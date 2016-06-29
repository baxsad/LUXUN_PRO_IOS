//
//  O2HBaseTableViewCell.h
//  2HUO
//
//  Created by iURCoder on 3/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+HYSCat.h"

typedef NS_ENUM(NSInteger, SeparatorViewPosition){
    SeparatorViewPositionBottom,
    SeparatorViewPositionTop
};

@interface O2HBaseTableViewCell : UITableViewCell
- (NSIndexPath*)indexPath;
-(void)addSeparatorWithLeftMargin:(CGFloat)left rightMargin:(CGFloat)right color:(UIColor *)color positon:(SeparatorViewPosition)position;
@end
