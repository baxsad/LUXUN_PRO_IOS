//
//  GDImagePickerController.m
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDImagePickerController.h"
#import "GDGridViewController.h"
#import "GDAssetManager.h"

@interface GDImagePickerController ()<UINavigationControllerDelegate>

{
    NSTimer *_timer;
}

@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation GDImagePickerController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount
{
    
    self = [super init];
    if (self) {
        
        _maxImagesCount = maxImagesCount;
        _observerPhotoChange = NO;
        _showCameraButton = YES;
        
        // Grid 的一个配置参数
        _colsInVertical = 3;
        _colsInLandscape = 5;
        _minimumInteritemSpacing = 2.0;
        
        _navBackgroundColor = [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:239.0/255.0 alpha:1];
        
        // 选择要显示的分组
        _customSmartCollections = @[@(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                    @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                    @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                    @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
                                    @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
                                    @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                    @(PHAssetCollectionSubtypeSmartAlbumPanoramas)];
        
        // 将要显示的资源类型
        _mediaTypes = @[@(PHAssetMediaTypeAudio),
                        @(PHAssetMediaTypeVideo),
                        @(PHAssetMediaTypeImage)];
        
        if (![[GDAssetManager manager] authorizationStatusAuthorized]) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:YES];
        }else{
            [self setupNavigationController];
        }
        
    }
    return self;
}

- (void)observeAuthrizationStatusChange {
    if ([[GDAssetManager manager] authorizationStatusAuthorized]) {
        [self setupNavigationController];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setupNavigationController
{
    
    GDGridViewController * grid = [[GDGridViewController alloc] initWithPicker:self];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:grid];
    _navigationController.delegate = self;
    
    _navigationController.navigationBar.translucent = NO;
    [_navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    _navigationController.navigationBar.shadowImage = [UIImage new];
    [_navigationController.navigationBar setTintColor:_navBackgroundColor];
    [_navigationController.navigationBar setBarTintColor:_navBackgroundColor];
    
    [_navigationController willMoveToParentViewController:self];
    [_navigationController.view setFrame:self.view.frame];
    [self.view addSubview:_navigationController.view];
    [self addChildViewController:_navigationController];
    [_navigationController didMoveToParentViewController:self];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
}

@end
