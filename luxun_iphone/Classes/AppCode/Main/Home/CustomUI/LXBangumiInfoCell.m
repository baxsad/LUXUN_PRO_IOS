//
//  LXBangumiInfoCell.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXBangumiInfoCell.h"
#import "Bangumis.h"
#import <YYWebImage/YYWebImage.h>
#import <YYText/YYText.h>

@interface LXBangumiInfoCell ()

@property (nonatomic, strong) UIImageView * bangumiIcon;
@property (nonatomic, strong) YYLabel * titleLable;
@property (nonatomic, strong) YYLabel * weekLable;
@property (nonatomic, strong) YYLabel * desLable;
@property (nonatomic, strong) UIButton * collectButton;

@end

@implementation LXBangumiInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.width = SCREEN_WIDTH;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _bangumiIcon = [[UIImageView alloc] init];
    _titleLable = [[YYLabel alloc] init];
    _weekLable = [[YYLabel alloc] init];
    _desLable = [[YYLabel alloc] init];
    _collectButton = [[UIButton alloc] init];
    [self addSubview:_bangumiIcon];
    [self addSubview:_titleLable];
    [self addSubview:_weekLable];
    [self addSubview:_desLable];
    [self addSubview:_collectButton];
    
    _bangumiIcon.contentMode = UIViewContentModeScaleAspectFill;
    _bangumiIcon.clipsToBounds = YES;
    _titleLable.font = [UIFont boldSystemFontOfSize:19];
    _weekLable.font = [UIFont systemFontOfSize:14];
    _titleLable.numberOfLines = 0;
    _desLable.numberOfLines = 0;
    _desLable.textColor = UIColorHex(0x999999);
    _weekLable.textColor = UIColorHex(0x7F7F7F);
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configModel:(Bangumi *)model
{
    if (model) {
        _bangumiIcon.frame = model.frameModel.player_bangumiIconFrame;
        _titleLable.frame = model.frameModel.player_bangumiTitleFrame;
        _weekLable.frame = model.frameModel.player_bangumiWeekFrame;
        _desLable.frame = model.frameModel.player_bangumiDesFrame;
        [_bangumiIcon.layer yy_setImageWithURL:[NSURL URLWithString:model.cover] placeholder:nil];
        _titleLable.text = model.title;
        _weekLable.text = model.weekString;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.text];
        text.yy_font = [UIFont systemFontOfSize:13];
        text.yy_lineSpacing = 5;
        _desLable.attributedText = text;
    }
}

@end
