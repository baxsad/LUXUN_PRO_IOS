//
//  LXTopicListCell.m
//  luxun_iphone
//
//  Created by 王锐 on 16/6/16.
//  Copyright © 2016年 iUR. All rights reserved.
//

#import "LXTopicListCell.h"
#import "Bangumis.h"
#import "Topics.h"
#import "LXBangumiCell.h"

@interface LXTopicListCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UIView * bgView;
@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@property (nonatomic, weak) IBOutlet UILabel * title;
@property (nonatomic, weak) IBOutlet UILabel * text;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * collectionHeightLayout;
@property (nonatomic, strong) Topic * model;

@end

static CGSize itemSize;

@implementation LXTopicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat itemWidth = (SCREEN_WIDTH-(ITEM_NUMBER_INLINE+1)*ITEM_PADDING)/ITEM_NUMBER_INLINE;
    CGFloat itemHeight = itemWidth/RATIO_OF_LENGTH_TO_WIDTH;
    itemSize = CGSizeMake(itemWidth, itemHeight);
    self.collectionHeightLayout.constant = itemHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:@"LXBangumiCell" bundle:nil] forCellWithReuseIdentifier:@"LXBangumiCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(Topic *)model
{
    if (model) {
        _model = model;
        self.title.text = model.title;
        self.text.text = model.text;
        [self.collectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.bangumiModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXBangumiCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LXBangumiCell" forIndexPath:indexPath];
    Bangumi * b = _model.bangumiModels[indexPath.item];
    [cell configModel:b.frameModel itemSzie:itemSize radius:3.0f];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
