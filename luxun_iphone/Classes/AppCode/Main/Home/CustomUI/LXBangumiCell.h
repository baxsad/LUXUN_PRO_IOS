//
//  LXBangumiCell.h
//  luxun_iphone
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BangumiFrameModel;

@interface LXBangumiCell : UICollectionViewCell

- (void)configModel:(BangumiFrameModel *)frameModel itemSzie:(CGSize)size radius:(CGFloat)radius;

@end
