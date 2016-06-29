//
//  LXTopicOneCell.m
//  luxun_iphone
//
//  Created by 王锐 on 16/6/16.
//  Copyright © 2016年 iUR. All rights reserved.
//

#import "LXTopicOneCell.h"
#import "Bangumis.h"
#import "Topics.h"
#import "UIView+EZGesture.h"

@interface LXTopicOneCell ()

@property (nonatomic, weak) IBOutlet UIImageView * image;
@property (nonatomic, weak) IBOutlet UIView      * blur;
@property (nonatomic, weak) IBOutlet UILabel     * title;
@property (nonatomic, weak) IBOutlet UILabel     * text;
@property (nonatomic, strong) Bangumi            * model;

@end

@implementation LXTopicOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.image.clipsToBounds = YES;
    self.blur.backgroundColor = UIColorHex(0x555555);
    self.blur.alpha = 0.5;
    self.blur.userInteractionEnabled = YES;
    @weakify(self);
    [self.blur whenTapped:^{
        @strongify(self);
        [[GDRouter sharedInstance] open:@"luxun://player" extraParams:@{@"bangumi":self.model}];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(Topic *)model
{
    if (model) {
        Bangumi * b = nil;
        if (model.bangumiModels.count>0) {
            b = model.bangumiModels[0];
        }else{
            b = nil;
        }
        self.model = b;
        [self.image yy_setImageWithURL:[NSURL URLWithString:b.cover] options:YYWebImageOptionRefreshImageCache];
        
        if ([model.direction isEqualToString:@"left"]) {
            
        }
        if ([model.direction isEqualToString:@"right"]) {
            
        }
        self.title.text = model.title;
        self.text.text = model.text;
    }
}

@end
