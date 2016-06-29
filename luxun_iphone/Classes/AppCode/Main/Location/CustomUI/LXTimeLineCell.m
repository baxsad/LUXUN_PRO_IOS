//
//  LXTimeLineCell.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXTimeLineCell.h"
#import "Bangumis.h"
#import <YYWebImage/YYWebImage.h>

@interface LXTimeLineCell()

@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *set;
@property (nonatomic, weak) IBOutlet UILabel *time;

@end

@implementation LXTimeLineCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.icon.clipsToBounds = YES;
}

- (void)configModel:(Bangumi *)model
{
    if (model) {
        NSString * imageUrl = model.timeLineBangumiIcon;
        [self.icon yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
        self.title.text = model.title;
        self.set.text = [NSString stringWithFormat:@"第 %li 话",[model.cur integerValue]];
        self.time.text = model.created.timeAgo;
    }
}



@end
