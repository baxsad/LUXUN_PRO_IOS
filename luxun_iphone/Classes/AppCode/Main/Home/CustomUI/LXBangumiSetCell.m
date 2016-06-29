//
//  LXBangumiSetCell.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXBangumiSetCell.h"
#import "Bangumis.h"

@interface LXBangumiSetCell ()

@property (nonatomic, weak) IBOutlet UILabel *set;

@end

@implementation LXBangumiSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = SET_ITEM_HEIGHT/2;
    self.layer.masksToBounds = YES;
}

- (void)configModel:(Set *)model isselected:(bool)selected
{
    if (model) {
        _set.text = model.set;
        if (selected) {
            self.backgroundColor = SET_BG_COLOR_SELECTED;
            self.set.textColor = SET_TITLE_COLOR_SELECTED;
        }else{
            self.backgroundColor = SET_BG_COLOR_NORMALL;
            self.set.textColor = SET_TITLE_COLOR_NORMALL;
        }
    }
}

@end
