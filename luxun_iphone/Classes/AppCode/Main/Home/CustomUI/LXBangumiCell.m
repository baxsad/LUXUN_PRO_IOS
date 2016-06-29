//
//  LXBangumiCell.m
//  luxun_iphone
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXBangumiCell.h"
#import <YYWebImage/YYWebImage.h>
#import "Bangumis.h"
#import <YYText/YYText.h>

@interface LXBangumiCell ()

@property (nonatomic, strong) UIImageView * bangumiIcon;
@property (nonatomic, strong) YYLabel * titleName;
@property (strong, nonatomic) UIImageView *setBackgroundImage;
@property (strong, nonatomic) YYLabel *setLable;
@property (strong, nonatomic) UIImageView *blurImage;
@property (strong, nonatomic) UIImageView *ts;
@property (strong, nonatomic) BangumiFrameModel * frameModel;

@end

@implementation LXBangumiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _ts = [[UIImageView alloc] initWithFrame:CGRectZero];
    _ts.backgroundColor = [UIColor clearColor];
    _ts.hidden = YES;
    [self addSubview:_ts];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    _bangumiIcon = [[UIImageView alloc] init];
    _bangumiIcon.backgroundColor = UIColorHex(0xffffff);
    [self addSubview:_bangumiIcon];
    
    _blurImage = [[UIImageView alloc] init];
    [_blurImage setImage:[UIImage imageNamed:@"bgm_blurImage"]];
    [self addSubview:_blurImage];
    
    _setBackgroundImage = [[UIImageView alloc] init];
    [self.setBackgroundImage setImage:[UIImage imageNamed:@"blur"]];
    [self addSubview:_setBackgroundImage];
    
    self.setLable = [[YYLabel alloc] init];
    _setLable.textColor = UIColorHex(0xffffff);
    _setLable.font = [UIFont boldSystemFontOfSize:13];
    _setLable.textAlignment = NSTextAlignmentCenter;
    _setLable.shadowColor = [UIColor grayColor];
    _setLable.shadowOffset = CGSizeMake(-1.2, 1.2);
    [self addSubview:_setLable];
    
    self.titleName = [[YYLabel alloc] init];
    _titleName.numberOfLines = 0;
    _titleName.textColor = UIColorHex(0xffffff);
    _titleName.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_titleName];
    
}



- (void)configModel:(BangumiFrameModel *)frameModel itemSzie:(CGSize)size radius:(CGFloat)radius
{
    if (_frameModel== frameModel) return;
    _frameModel = frameModel;
    
    [_bangumiIcon yy_cancelCurrentHighlightedImageRequest];
    [_bangumiIcon.layer removeAnimationForKey:@"bangumiicon.fade"];
    
    if (!_frameModel) {
        _bangumiIcon.image = nil;
        return;
    }
    
    @weakify(self);
    [_ts.layer yy_setImageWithURL:[NSURL URLWithString:frameModel.bangumi.cover]
                      placeholder:nil
                          options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation
                         progress:nil
                        transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                            image = [image imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];
                            image = [image imageByRoundCornerRadius:radius];
                            return image;
                        }
                       completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                           if (stage == YYWebImageStageFinished) {
                               if (image) {
                                   if ([[NSThread currentThread] isMainThread]) {
                                       @strongify(self);
                                       self.bangumiIcon.image = image;
                                       CATransition *transition = [CATransition animation];
                                       transition.duration = 0.125;
                                       transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                                       transition.type = kCATransitionFade;
                                       [self.bangumiIcon.layer addAnimation:transition forKey:@"bangumiicon.fade"];
                                   } else {
                                       dispatch_sync(dispatch_get_main_queue(), ^{
                                           @strongify(self);
                                           self.bangumiIcon.image = image;
                                           CATransition *transition = [CATransition animation];
                                           transition.duration = 0.125;
                                           transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                                           transition.type = kCATransitionFade;
                                           [self.bangumiIcon.layer addAnimation:transition forKey:@"bangumiicon.fade"];
                                       });
                                   }
                               }
                           }
                           
                           
                       }];
    
    self.bangumiIcon.frame = frameModel.bangumiIconFrame;
    self.blurImage.frame = frameModel.blurFrame;
    self.setBackgroundImage.frame = frameModel.setBackGroundImageFrame;
    self.setLable.frame = frameModel.setLableFrame;
    self.titleName.frame = frameModel.titleLableFrame;
    
    self.titleName.text = frameModel.bangumi.title;
    self.setLable.text = frameModel.bangumi.cur;
    self.titleName.displaysAsynchronously = YES;
    self.setLable.displaysAsynchronously = YES;
}


@end
