//
//  LXBangumiSetsCell.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXBangumiSetsCell.h"
#import "LXBangumiSetCell.h"
#import "Bangumis.h"
@interface LXBangumiSetsCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) Bangumi * model;
@property (nonatomic, assign) NSInteger selectItem;

@end

@implementation LXBangumiSetsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.width = SCREEN_WIDTH;
    self.backgroundColor = [UIColor whiteColor];
    self.exclusiveTouch = YES;
    self.clipsToBounds = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat setWith = (SCREEN_WIDTH - 20 - SET_ITEM_MARGIN__L_R * (SET_ITEM_NUMBER_IN_LINE-1))/SET_ITEM_NUMBER_IN_LINE;
    layout.itemSize = CGSizeMake(setWith, SET_ITEM_HEIGHT);
    layout.minimumLineSpacing = SET_ITEM_MARGIN__L_R;
    layout.minimumInteritemSpacing = SET_ITEM_MARGIN__T_B;
    layout.sectionInset = SETS_COLLECTION_INSET;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"LXBangumiSetCell" bundle:nil] forCellWithReuseIdentifier:@"LXBangumiSetCell"];
    [self addSubview:_collectionView];
    
    return self;
}

- (void)configModel:(Bangumi *)model
{
    if (model) {
        _model = model;
        
        _collectionView.frame = model.frameModel.player_setsCollectionFrame;
        [self.collectionView reloadData];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.sets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXBangumiSetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LXBangumiSetCell" forIndexPath:indexPath];
    Set * set = _model.sets[indexPath.item];
    BOOL selected = [_model.cur isEqualToString:set.set];
    if (selected) {
        self.selectItem = indexPath.item;
    }
    [cell configModel:set isselected:selected];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_selectItem == indexPath.item) return;
    
    Set * set = _model.sets[indexPath.item];
    _model.cur = set.set;
    
    NSIndexPath *indexPatho=[NSIndexPath indexPathForRow:_selectItem inSection:0];
    [collectionView reloadItemsAtIndexPaths:@[indexPatho,indexPath]];
    
    if ([self.delegate respondsToSelector:@selector(setDidSelectedAtIndex:)]) {
        [self.delegate setDidSelectedAtIndex:indexPath.item];
    }
}

@end
