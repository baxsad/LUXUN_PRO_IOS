//
//  MFJSettingCell.h
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFJSettingItem;

@interface MFJSettingCell : UITableViewCell

@property (nonatomic, strong) MFJSettingItem * item;
/** switch状态改变的block*/
@property (copy, nonatomic) void(^switchChangeBlock)(BOOL on);

+ (id)settingCellWithTableView:(UITableView *)tableView;

@end
