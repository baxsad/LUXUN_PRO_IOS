//
//  GDGridViewCell.h
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GDAssetModel;

@interface GDGridViewCell : UICollectionViewCell

@property (nonatomic, strong) GDAssetModel *assetModel;

@property (nonatomic, weak) IBOutlet UIImageView * imageView;

@property (nonatomic, weak) IBOutlet UIImageView * selectIcon;

@property (nonatomic, weak) IBOutlet UIButton * selectButton;

@end
