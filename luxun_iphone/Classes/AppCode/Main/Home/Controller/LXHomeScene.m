//
//  LXHomeScene.m
//  luxun_iphone
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXHomeScene.h"
#import "LXPlayScene.h"
#import "Bangumis.h"
#import "LXBangumiCell.h"
#import "DataCenter.h"
#import "LXBangumiSearchHeaderView.h"
#import "LXBangumiCollectionFooterView.h"
#import "LXBangumiCollectionHeaderView.h"
#import "GDEmptyDataSetter.h"

@interface LXHomeScene ()<UICollectionViewDelegate,UICollectionViewDataSource,GDPlaceHolderDelegate,NotDataPlaceHolderDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) GDReq * getComicListRequest;
@property (nonatomic, strong) Bangumis * bangumiData;

@end

static CGSize itemSize;

@implementation LXHomeScene

- (instancetype)init
{
    self = [super init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat itemWidth = (SCREEN_WIDTH-(ITEM_NUMBER_INLINE+1)*ITEM_PADDING)/ITEM_NUMBER_INLINE;
    CGFloat itemHeight = itemWidth/RATIO_OF_LENGTH_TO_WIDTH;
    itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.itemSize = itemSize;
    layout.sectionInset = UIEdgeInsetsMake(ITEM_PADDING, ITEM_PADDING, ITEM_PADDING, ITEM_PADDING);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.bounces = YES;
    [_collectionView setNeedsUpdateConstraints];
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.bangumiData!=nil) return;
    self.getComicListRequest.requestNeedActive = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_collectionView registerNib:[UINib nibWithNibName:@"LXBangumiCell" bundle:nil] forCellWithReuseIdentifier:@"LXBangumiCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"LXBangumiSearchHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LXBangumiSearchHeaderView"];
    [_collectionView registerNib:[UINib nibWithNibName:@"LXBangumiCollectionFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LXBangumiCollectionFooterView"];
    [_collectionView registerNib:[UINib nibWithNibName:@"LXBangumiCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LXBangumiCollectionHeaderView"];
    
    @weakify(self);
    self.getComicListRequest = [LXRequest getComicListRequest];
    self.getComicListRequest.requestNeedActive = YES;
    self.getComicListRequest.cachePolicy = GDRequestCachePolicyNoCache;
    [self.getComicListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            
            @strongify(self);
            self.bangumiData = [[Bangumis alloc] initWithDictionary:req.output error:nil];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @strongify(self);
                for (Bangumi * bangumi in self.bangumiData.updating) {
                    BangumiFrameModel * frameModel = [[BangumiFrameModel alloc] init];
                    frameModel.bangumi = bangumi;
                    bangumi.frameModel = frameModel;
                }
                for (Quars * quars in self.bangumiData.quars) {
                    for (Bangumi * bangumi in quars.bangumis) {
                        BangumiFrameModel * frameModel = [[BangumiFrameModel alloc] init];
                        frameModel.bangumi = bangumi;
                        bangumi.frameModel = frameModel;
                    }
                }
                
                [DataCenter defaultCenter].luxunData = req.output;

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView gd_reloadData];
                });
                
            });
            
        }
        if (req.failed) {
            [self.collectionView gd_reloadData];
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (_bangumiData ? 1 : 0) + _bangumiData.quars.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section ? ((Quars*)_bangumiData.quars[section-1]).bangumis.count : _bangumiData.updating.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXBangumiCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LXBangumiCell" forIndexPath:indexPath];
    Bangumi *model;
    if (indexPath.section == 0) {
        model = _bangumiData.updating[indexPath.item];
    }else{
        Quars * quars = _bangumiData.quars[indexPath.section-1];
        model = quars.bangumis[indexPath.item];
    }
    [cell configModel:model.frameModel itemSzie:itemSize radius:3.0f];
    return cell;
}

#pragma mark Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Bangumi * bangumi ;
    if (indexPath.section == 0) {
        bangumi = self.bangumiData.updating[indexPath.item];
    }else{
        Quars * quars = _bangumiData.quars[indexPath.section-1];
        bangumi = quars.bangumis[indexPath.item];
    }
    [[GDRouter sharedInstance] open:@"luxun://player" extraParams:@{@"bangumi":bangumi}];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        if (indexPath.section == 0) {
            LXBangumiSearchHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LXBangumiSearchHeaderView" forIndexPath:indexPath];
            reusableview = header;
        }else{
            LXBangumiCollectionHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LXBangumiCollectionHeaderView" forIndexPath:indexPath];
            Quars *quars = self.bangumiData.quars[indexPath.section - 1];
            [header configDate:quars.quarter];
            reusableview = header;
        }
        
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        LXBangumiCollectionFooterView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LXBangumiCollectionFooterView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [footer configModel:self.bangumiData.updating  isOver:NO];
        }else{
            Quars *quars = self.bangumiData.quars[indexPath.section - 1];
            [footer configModel:quars.bangumis  isOver:YES];
        }
        reusableview = footer;
    }
    
    return reusableview;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 55);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 60);
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 70);
    
}

#pragma mark 没有数据的占位图

- (UIView *)makePlaceHolderView
{
    if ([DataCenter defaultCenter].networkAvailable) {
        return [self notDataPlaceHolder];
    }else{
        return [self notNetPlaceHolder];
    }
    
}

- (UIView *)notNetPlaceHolder{
    __block NotNetPlaceHolder *notNetPlaceHolder = [[NotNetPlaceHolder alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                  reloadBlock:^{
                                                                      // 刷新数据
                                                                      self.getComicListRequest.requestNeedActive = YES;
                                                                  }] ;
    return notNetPlaceHolder;
}

- (UIView *)notDataPlaceHolder{
    NotDataPlaceHolder *notDataPlaceHolder = [[NotDataPlaceHolder alloc] initWithFrame:self.view.frame];
    notDataPlaceHolder.delegate = self;
    return notDataPlaceHolder;
}

#pragma mark - WeChatStylePlaceHolderDelegate Method

- (void)emptyOverlayClicked:(id)sender {
    // 刷新数据
    self.getComicListRequest.requestNeedActive = YES;
}

#pragma mark getter



@end
