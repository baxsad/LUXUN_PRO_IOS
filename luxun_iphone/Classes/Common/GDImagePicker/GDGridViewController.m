//
//  GDGridViewController.m
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDGridViewController.h"
#import "GDImagePickerController.h"
#import "GDGridViewCell.h"
#import "GDCameraViewController.h"

@implementation NSIndexSet (Convenience)
- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}
@end

@implementation UICollectionView (Convenience)
- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
@end

@interface GDGridViewController () <PHPhotoLibraryChangeObserver>
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    UICollectionViewFlowLayout *portraitLayout;
    UICollectionViewFlowLayout *landscapeLayout;
}

@property (nonatomic, strong) GDImagePickerController * picker;

@property (readwrite ,nonatomic, strong) GDAlbumModel * albumModel;

@property (nonatomic, copy ) NSString      *albumTitle;

@property (nonatomic, copy ) NSArray       *allAlbum;

@property (nonatomic, copy ) NSMutableArray*allAsset;

@property (nonatomic,assign) BOOL           collectionIsScrollEnd;

@property (nonatomic,assign) BOOL           toolBarIsShow;

// UI

@property (nonatomic, strong) UIButton     *nextButton;

@property (nonatomic, strong) UIView       *toolBar;

@property CGRect previousPreheatRect;

@end

static CGSize AssetGridThumbnailSize;
static CGSize collectionSize;
NSString * const GDGridViewCellIdentifier = @"GDGridViewCellIdentifier";

@implementation GDGridViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _allAsset = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    if (!iOS7Later) {
        // support full screen on iOS 6
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }

    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBarButtonItemAndTitleView];

    __weak typeof(self) weakSelf = self;
    [[GDAssetManager  manager] getAllAlbums:self.picker.mediaTypes completion:^(NSArray<GDAlbumModel *> *models) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.allAlbum = models;
        strongSelf.albumModel = models[0];
        [self maskeupAssetModelWithAlbumModel:_albumModel];
        strongSelf.albumTitle = strongSelf.albumModel.title;
        strongSelf.title = strongSelf.albumTitle;
        [strongSelf.collectionView reloadData];
        
    }];
    
    if (self.picker.observerPhotoChange) [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    [self resetCachedAssets];
    
}

- (void)maskeupAssetModelWithAlbumModel:(GDAlbumModel *)model
{
    [_allAsset removeAllObjects];
    if (_picker.showCameraButton) {
        GDAssetModel * CameraAssetModel = [[GDAssetModel alloc] init];
        CameraAssetModel.asset = [UIImage imageNamed:@"camera"];
        CameraAssetModel.type = GDAssetModelMediaTypeCamera;
        [_allAsset addObject:CameraAssetModel];
    }
    [model.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        GDAssetModel * model = [GDAssetModel modelWithAsset:obj];
        [_allAsset addObject:model];
        
    }];
    
}

- (void)setupNavigationBarButtonItemAndTitleView
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 0;//右边距
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithTitle:@"Cancle" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonTouch)];
    [barbutton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[fixedSpace,barbutton];
    if (iOS7Later) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    UIButton * selectAlbumButton = [[UIButton alloc] init];
    [selectAlbumButton setTitle:@"be a motherfucker" forState:UIControlStateNormal];
    [selectAlbumButton setTitleColor:UIColorHex(0x555555) forState:UIControlStateNormal];
    [selectAlbumButton sizeToFit];
    selectAlbumButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.navigationItem.titleView = selectAlbumButton;
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -7;
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(0, 0, 55, 25);
    [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_nextButton setBackgroundColor:[UIColor whiteColor]];
    _nextButton.layer.borderWidth = 1;
    _nextButton.layer.borderColor = [UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1].CGColor;
    [_nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _nextButton.layer.cornerRadius = 3;
    _nextButton.layer.masksToBounds = YES;
    self.navigationItem.rightBarButtonItems =
    @[negativeSeperator,[[UIBarButtonItem alloc] initWithCustomView:_nextButton]];

}

- (void)setupToolBar
{
    [self.view addSubview:self.toolBar];
    [self hidenToolBar];
}

- (void)hidenToolBar
{
    if (!_toolBarIsShow) {
        return;
    }
    CGRect hidenRect = CGRectMake(0, collectionSize.height, SCREEN_WIDTH, TOOL_BAR_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.collectionView.height = collectionSize.height;
        self.toolBar.frame = hidenRect;
        
    } completion:^(BOOL finished) {
        _toolBarIsShow = NO;
    }];
}

- (void)showToolBar
{
    if (_toolBarIsShow) {
        return;
    }
    CGRect showRect = CGRectMake(0, collectionSize.height - TOOL_BAR_HEIGHT, SCREEN_WIDTH, TOOL_BAR_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBar.frame = showRect;
        
    } completion:^(BOOL finished) {
        self.collectionView.height = collectionSize.height - TOOL_BAR_HEIGHT;
        if (_collectionIsScrollEnd) {
            CGPoint off = self.collectionView.contentOffset;
            off.y = self.collectionView.contentSize.height - self.collectionView.bounds.size.height + self.collectionView.contentInset.bottom;
            [self.collectionView setContentOffset:off animated:YES];
        }
        _toolBarIsShow = YES;
    }];
    
}

- (void)nextAction
{
    [self hidenToolBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCachedAssets];
    collectionSize = self.view.frame.size;
    [self setupToolBar];
}

- (void)dealloc
{
    [self resetCachedAssets];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)leftButtonTouch
{
    [self resetCachedAssets];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (instancetype)initWithPicker:(GDImagePickerController*)picker
{
    self.picker = picker;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        screenWidth = CGRectGetWidth(rect);
        screenHeight = CGRectGetHeight(rect);
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            screenHeight = CGRectGetWidth(rect);
            screenWidth = CGRectGetHeight(rect);
        }
        else
        {
            screenWidth = CGRectGetWidth(rect);
            screenHeight = CGRectGetHeight(rect);
        }
    }
    
    UICollectionViewFlowLayout *layout = [self collectionViewFlowLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    if (self = [super initWithCollectionViewLayout:layout])
    {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        
        AssetGridThumbnailSize = CGSizeMake(layout.itemSize.width * scale, layout.itemSize.height * scale);
        
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"GDGridViewCell" bundle:nil] forCellWithReuseIdentifier:GDGridViewCellIdentifier];
        
        self.collectionView.contentInset = UIEdgeInsetsMake(self.picker.minimumInteritemSpacing, 0, 0, 0);
        
    }
    return self;
}

#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    
    UICollectionViewFlowLayout *layout = [self collectionViewFlowLayoutForOrientation:toInterfaceOrientation];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(layout.itemSize.width * scale, layout.itemSize.height * scale);
    
    [self resetCachedAssets];
    
    for (GDGridViewCell *cell in [self.collectionView visibleCells]) {
        NSInteger currentTag = cell.tag;
        __weak typeof(GDGridViewCell *) weakCell = cell;
        [[GDAssetManager manager].cachingImageManager requestImageForAsset:cell.assetModel.asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info)
         {
             __weak typeof(GDGridViewCell *) strongCell = weakCell;
             if (strongCell.tag == currentTag) {
                 [strongCell.imageView setImage:result];
             }
         }];
    }
    
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

#pragma mark - Collection View Layout

- (UICollectionViewFlowLayout *)collectionViewFlowLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(!portraitLayout)
        {
            portraitLayout = [[UICollectionViewFlowLayout alloc] init];
            portraitLayout.minimumInteritemSpacing = self.picker.minimumInteritemSpacing;
            int cellTotalUsableWidth = screenWidth - (self.picker.colsInVertical-1)*self.picker.minimumInteritemSpacing;
            portraitLayout.itemSize = CGSizeMake(cellTotalUsableWidth/self.picker.colsInVertical, cellTotalUsableWidth/self.picker.colsInVertical);
            double cellTotalUsedWidth = (double)portraitLayout.itemSize.width*self.picker.colsInVertical;
            double spaceTotalWidth = (double)screenWidth-cellTotalUsedWidth;
            double spaceWidth = spaceTotalWidth/(double)(self.picker.colsInVertical-1);
            portraitLayout.minimumLineSpacing = spaceWidth;
        }
        return portraitLayout;
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape(orientation))
        {
            if(!landscapeLayout)
            {
                landscapeLayout = [[UICollectionViewFlowLayout alloc] init];
                landscapeLayout.minimumInteritemSpacing = self.picker.minimumInteritemSpacing;
                int cellTotalUsableWidth = screenHeight - (self.picker.colsInLandscape-1)*self.picker.minimumInteritemSpacing;
                landscapeLayout.itemSize = CGSizeMake(cellTotalUsableWidth/self.picker.colsInLandscape, cellTotalUsableWidth/self.picker.colsInLandscape);
                double cellTotalUsedWidth = (double)landscapeLayout.itemSize.width*self.picker.colsInLandscape;
                double spaceTotalWidth = (double)screenHeight-cellTotalUsedWidth;
                double spaceWidth = spaceTotalWidth/(double)(self.picker.colsInLandscape-1);
                landscapeLayout.minimumLineSpacing = spaceWidth;
            }
            return landscapeLayout;
        }
        else
        {
            if(!portraitLayout)
            {
                portraitLayout = [[UICollectionViewFlowLayout alloc] init];
                portraitLayout.minimumInteritemSpacing = self.picker.minimumInteritemSpacing;
                int cellTotalUsableWidth = screenWidth - (self.picker.colsInVertical-1)*self.picker.minimumInteritemSpacing;
                portraitLayout.itemSize = CGSizeMake(cellTotalUsableWidth/self.picker.colsInVertical, cellTotalUsableWidth/self.picker.colsInVertical);
                double cellTotalUsedWidth = (double)portraitLayout.itemSize.width*self.picker.colsInVertical;
                double spaceTotalWidth = (double)screenWidth-cellTotalUsedWidth;
                double spaceWidth = spaceTotalWidth/(double)(self.picker.colsInVertical-1);
                portraitLayout.minimumLineSpacing = spaceWidth;
            }
            return portraitLayout;
        }
    }
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // check if there are changes to the assets (insertions, deletions, updates)
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.albumModel.results];
        if (collectionChanges) {
            
            // get the new fetch result
            self.albumModel.results = [collectionChanges fetchResultAfterChanges];
            
            [self maskeupAssetModelWithAlbumModel:self.albumModel];
            
            UICollectionView *collectionView = self.collectionView;
            
            if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
                // we need to reload all if the incremental diffs are not available
                [collectionView reloadData];
                
            } else {
                // if we have incremental diffs, tell the collection view to animate insertions and deletions
                [collectionView performBatchUpdates:^{
                    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                    if ([removedIndexes count]) {
                        [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                    if ([insertedIndexes count]) {
                        NSArray * paths = [insertedIndexes aapl_indexPathsFromIndexesWithSection:0];
                        [collectionView insertItemsAtIndexPaths:paths];
                        if (self.picker.showCameraButton) {
                            for (NSIndexPath *path in [insertedIndexes aapl_indexPathsFromIndexesWithSection:0]) {
                                [self collectionView:collectionView didSelectItemAtIndexPath:path];
                            }
                        }
                    }
                    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                    if ([changedIndexes count]) {
                        [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                } completion:NULL];
            }
            
            [self resetCachedAssets];
        }
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedAssets];
    
    self.collectionIsScrollEnd = NO;
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    if(currentOffset==maximumOffset)
        
    {
        
        self.collectionIsScrollEnd = YES;
        
    }
    

}

#pragma mark - Asset Caching

- (void)resetCachedAssets
{
    [[GDAssetManager manager].cachingImageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GDGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GDGridViewCellIdentifier
                                                                     forIndexPath:indexPath];
    
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;
    
    GDAssetModel *assetModel = self.allAsset[indexPath.item];
    
    if (_picker.showCameraButton && indexPath.item == 0)
    {
        cell.selectIcon.hidden = YES;
        cell.selectButton.hidden = YES;
    }
    
    __weak typeof(GDGridViewCell *) weakCell = cell;
    [[GDAssetManager manager] getThumbnailPhotoWithAssetModel:assetModel
                                                         size:AssetGridThumbnailSize
                                                   completion:^(UIImage *photo, NSDictionary *info) {
                                                  __weak typeof(GDGridViewCell *) strongCell = weakCell;
                                                  if (strongCell.tag == currentTag) {
                                                      [strongCell.imageView setImage:photo];
                                                  }
                                              }];
        
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.allAsset.count;
    return count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showToolBar];
}


- (void)updateCachedAssets
{
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        [[GDAssetManager manager].cachingImageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [[GDAssetManager manager].cachingImageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (_picker.showCameraButton && indexPath.item == 0) continue;
        PHAsset *asset = [self.allAsset[indexPath.item] asset];
        [assets addObject:asset];
    }
    
    return assets;
}

#pragma mark -- getter

- (UIView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, collectionSize.height, SCREEN_WIDTH, TOOL_BAR_HEIGHT)];
        _toolBar.backgroundColor = self.picker.navBackgroundColor;
        _toolBarIsShow = NO;
    }
    return _toolBar;
}

@end
